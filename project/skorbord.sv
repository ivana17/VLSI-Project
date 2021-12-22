`include "uvm_macros.svh"
import uvm_pkg::*;
import transakcija_sv_unit::*;

class skorbord extends uvm_scoreboard;

	`uvm_component_utils(skorbord)

	function new(string name = "skorbord", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	// TODO
	bit[14:0] control;
	bit serial_input_lsb;
	bit serial_input_msb;
	bit [7:0] parallel_input;
	bit serial_output_lsb;
	bit  serial_output_msb;
	bit [7:0] parallel_output;
	integer position;

	uvm_analysis_imp #(transakcija,skorbord) imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		imp = new ("imp", this);
	endfunction

	virtual function write(transakcija t);
		// TODO
		control = t.control; 
		serial_input_lsb = t.serial_input_lsb;
		serial_input_msb = t.serial_input_msb;
		parallel_input = t.parallel_input;


		if(!(parallel_output ^ t.parallel_output) && !(serial_output_lsb ^ t.serial_output_lsb) && !(serial_output_msb ^ t.serial_output_msb))
			`uvm_info("SKB", $sformatf("PASS! position:%0d parallel_out=%8b , lsb_out=%0d , msb_out=%0d",position,parallel_output,serial_output_lsb,serial_output_msb), UVM_NONE)
		else
			`uvm_error("SKB", $sformatf("ERROR! position:%0d Exp: paral = %8b , lsb = %0d , msb = %0d Got: t.paral = %8b , t.lsb = %0d , t.msb = %0d",position,parallel_output,serial_output_lsb,serial_output_msb,t.parallel_output,t.serial_output_lsb,t.serial_output_msb))
		

		
		begin : break_nb
			for (position = 0; position < 15; position = position + 1) begin
				if ((control & (1'b1 << position)) != 0)
					disable break_nb;	// napustanje for petlje
			end
		end
		
		serial_output_msb = 1'b0;
		serial_output_lsb = 1'b0;

		case (position)
			0:
				{serial_output_msb,parallel_output,serial_output_lsb} = 10'h000;
			1:
				{serial_output_msb,parallel_output,serial_output_lsb} = {1'b0,t.parallel_input,1'b0};
			2:
				{serial_output_msb, parallel_output} = parallel_output + 1'b1;
			3:
				{serial_output_msb, parallel_output} = parallel_output - 1'b1;
			4:
				{serial_output_msb, parallel_output} = parallel_output + t.parallel_input;
			5:
				{serial_output_msb, parallel_output} = parallel_output - t.parallel_input;
			6:
				parallel_output = parallel_output ^ 8'hFF;
			7:
				{serial_output_msb, parallel_output} = {parallel_output, t.serial_input_lsb};
			8:
				{parallel_output, serial_output_lsb} = {t.serial_input_msb, parallel_output};
			9:
				{serial_output_msb, parallel_output} = {parallel_output, 1'b0};
			10:
				{parallel_output, serial_output_lsb} = {1'b0, parallel_output};
			11:
				{serial_output_msb, parallel_output} = {parallel_output, 1'b0};
			12:
				{parallel_output, serial_output_lsb} = {parallel_output[7], parallel_output};
			13:
				{serial_output_msb, parallel_output} = {parallel_output, parallel_output[7]};
			14:
				{parallel_output, serial_output_lsb} = {parallel_output[0], parallel_output};
			default:
				parallel_output = t.parallel_input;
		endcase


	endfunction

endclass
