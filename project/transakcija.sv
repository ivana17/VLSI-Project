`include "uvm_macros.svh"
import uvm_pkg::*;

class transakcija extends uvm_sequence_item;

	// TODO
	rand bit [14:0] control;
	rand bit serial_input_lsb;
	rand bit serial_input_msb;
	rand bit [7:0] parallel_input;
	bit serial_output_lsb;
	bit  serial_output_msb;
	bit [7:0] parallel_output;

	`uvm_object_utils_begin(transakcija)
		// TODO
		`uvm_field_int(control, UVM_ALL_ON)
		`uvm_field_int(serial_input_lsb, UVM_ALL_ON)
		`uvm_field_int(serial_input_msb, UVM_ALL_ON)
		`uvm_field_int(parallel_input, UVM_ALL_ON)
		`uvm_field_int(serial_output_lsb, UVM_ALL_ON)
		`uvm_field_int(serial_output_msb, UVM_ALL_ON)
		`uvm_field_int(parallel_output, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "transakcija");
		super.new(name);
	endfunction

	// TODO
	virtual function string convert2str();
		int i;
		for(i=0;i<15 && control[i] != 1;i++);
 		return $sformatf("control=%d, serial_input_lsb=%0d, serial_input_msb=%0d, parallel_input=%8b", i, serial_input_lsb, serial_input_msb, parallel_input);
	endfunction

endclass
