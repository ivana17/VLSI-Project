`include "uvm_macros.svh"
import uvm_pkg::*;
import test_sv_unit::*;

module testbench;

	reg clk;

	// TODO
	interfejs i(clk);
	register d(  i.rst_n,
		clk,  	
		i.control, 	
		i.serial_input_lsb, 	
		i.serial_input_msb, 	
		i.parallel_input, 
		i.serial_output_lsb, 
		i.serial_output_msb, 
		i.parallel_output);

	initial begin
		clk <= 0;
		uvm_config_db#(virtual interfejs)::set(null, "*", "i", i);
		run_test("test");
	end

	always
		#10 clk = ~clk;

endmodule
