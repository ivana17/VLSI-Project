module register (
	input rst_n,
	input clk,
	input [14:0] control,
	input serial_input_lsb,
	input serial_input_msb,
	input [7:0] parallel_input,
	output serial_output_lsb,
	output serial_output_msb,
	output [7:0] parallel_output
);
	
	localparam CONTROL_CLEAR = 0;
	localparam CONTROL_LOAD = 1;
	localparam CONTROL_INC = 2;
	localparam CONTROL_DEC = 3;
	localparam CONTROL_ADD = 4;
	localparam CONTROL_SUB = 5;
	localparam CONTROL_INVERT = 6;
	localparam CONTROL_SERIAL_INPUT_LSB = 7;
	localparam CONTROL_SERIAL_INPUT_MSB = 8;
	localparam CONTROL_SHIFT_LOGICAL_LEFT = 9;
	localparam CONTROL_SHIFT_LOGICAL_RIGHT = 10;
	localparam CONTROL_SHIFT_ARITHMETIC_LEFT = 11;
	localparam CONTROL_SHIFT_ARITHMETIC_RIGHT = 12;
	localparam CONTROL_ROTATE_LEFT = 13;
	localparam CONTROL_ROTATE_RIGHT = 14;
	
	reg [7:0] data_reg, data_next;
	reg serial_lsb_reg, serial_lsb_next;
	reg serial_msb_reg, serial_msb_next;
	
	assign parallel_output = data_reg;
	assign serial_output_lsb = serial_lsb_reg;
	assign serial_output_msb = serial_msb_reg;
	
	always @(posedge clk, negedge rst_n) begin
		if (rst_n == 1'b0) begin
			data_reg <= 8'h00;
			serial_lsb_reg <= 1'b0;
			serial_msb_reg <= 1'b0;
		end
		else begin
			data_reg <= data_next;
			serial_lsb_reg <= serial_lsb_next;
			serial_msb_reg <= serial_msb_next;
		end
	end
	
	always @(*) begin : next_state_nb
		integer position;
		begin : break_nb
			for (position = 0; position < 15; position = position + 1) begin
				if ((control & (1'b1 << position)) != 0)
					disable break_nb;	// napustanje for petlje
			end
		end
		
		serial_lsb_next = 1'b0;
		serial_msb_next = 1'b0;
		
		case (position)
			CONTROL_CLEAR:
				data_next = 8'h00;
			CONTROL_LOAD:
				data_next = parallel_input;
			CONTROL_INC:
				{serial_msb_next, data_next} = data_reg + 1'b1;
			CONTROL_DEC:
				{serial_msb_next, data_next} = data_reg - 1'b1;
			CONTROL_ADD:
				{serial_msb_next, data_next} = data_reg + parallel_input;
			CONTROL_SUB:
				{serial_msb_next, data_next} = data_reg - parallel_input;
			CONTROL_INVERT:
				data_next = data_reg ^ 8'hFF;
			CONTROL_SERIAL_INPUT_LSB:
				{serial_msb_next, data_next} = {data_reg, serial_input_lsb};
			CONTROL_SERIAL_INPUT_MSB:
				{data_next, serial_lsb_next} = {serial_input_msb, data_reg};
			CONTROL_SHIFT_LOGICAL_LEFT:
				{serial_msb_next, data_next} = {data_reg, 1'b0};
			CONTROL_SHIFT_LOGICAL_RIGHT:
				{data_next, serial_lsb_next} = {1'b0, data_reg};
			CONTROL_SHIFT_ARITHMETIC_LEFT:
				{serial_msb_next, data_next} = {data_reg, 1'b0};
			CONTROL_SHIFT_ARITHMETIC_RIGHT:
				{data_next, serial_lsb_next} = {data_reg[7], data_reg};
			CONTROL_ROTATE_LEFT:
				{serial_msb_next, data_next} = {data_reg, data_reg[7]};
			CONTROL_ROTATE_RIGHT:
				{data_next, serial_lsb_next} = {data_reg[0], data_reg};
			default:
				data_next = data_reg;
		endcase
	end

endmodule
