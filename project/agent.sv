`include "uvm_macros.svh"
import uvm_pkg::*;
import transakcija_sv_unit::*;
import drajver_sv_unit::drajver;
import monitor_sv_unit::*;

class agent extends uvm_agent;

	`uvm_component_utils(agent)

	function new(string name = "agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	drajver d;
	monitor m;
	uvm_sequencer #(transakcija) s;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		s = uvm_sequencer#(transakcija)::type_id::create("s", this);
		d = drajver::type_id::create("d", this);
		m = monitor::type_id::create("m", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		d.seq_item_port.connect(s.seq_item_export);
	endfunction

endclass
