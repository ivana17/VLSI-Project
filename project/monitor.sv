`include "uvm_macros.svh"
import uvm_pkg::*;
import transakcija_sv_unit::*;

class monitor extends uvm_monitor;

	`uvm_component_utils(monitor)

	function new(string name = "monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual interfejs i;
	uvm_analysis_port #(transakcija) port;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual interfejs)::get(this, "", "i", i))
			`uvm_fatal("MON", "Neuspesno dohvatanje interfejsa")
		port = new ("port", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			@(posedge i.clk);
				if(i.rst_n) begin
					transakcija t = transakcija::type_id::create("t");
					t.control = i.control;
					t.serial_input_lsb = i.serial_input_lsb ;
					t.serial_input_msb = i.serial_input_msb ;
					t.parallel_input = i.parallel_input ;
					t.serial_output_lsb = i.serial_output_lsb ;
					t.serial_output_msb = i.serial_output_msb ;
					t.parallel_output = i.parallel_output ;
					port.write(t);
				end
		end
		
		
	endtask

endclass
