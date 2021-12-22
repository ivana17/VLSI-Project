interface interfejs (
	input bit clk
);

	logic rst_n;
	logic[14:0] control;
	logic serial_input_lsb;
	logic serial_input_msb;
	logic[7:0] parallel_input;
	logic serial_output_lsb;
	logic serial_output_msb;
	logic[7:0] parallel_output;


endinterface
