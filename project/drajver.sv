`include "uvm_macros.svh"
import uvm_pkg::*;
import transakcija_sv_unit::*;

class drajver extends uvm_driver #(transakcija);

	`uvm_component_utils(drajver)

	function new(string name = "drajver", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual interfejs i;
	transakcija t;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual interfejs)::get(this, "", "i", i))
			`uvm_fatal("DRV", "Neuspesno dohvatanje interfejsa")
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item_port.get_next_item(t);
			drive_item(t);
			seq_item_port.item_done();
		end
	endtask

	virtual task drive_item(transakcija t);
		@(posedge i.clk);
		i.control <= t.control;
		i.serial_input_lsb <= t.serial_input_lsb ;
		i.serial_input_msb <= t.serial_input_msb ;
		i.parallel_input <= t.parallel_input ;
	endtask

endclass
