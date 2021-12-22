`include "uvm_macros.svh"
import uvm_pkg::*;
import monitor_sv_unit::*;
import agent_sv_unit::*;
import skorbord_sv_unit::*;

class okruzenje extends uvm_env;

	`uvm_component_utils(okruzenje)

	function new(string name = "okruzenje", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	agent a;
	skorbord sb;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a = agent::type_id::create("a", this);
		sb = skorbord::type_id::create("sb", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		a.m.port.connect(sb.imp);
	endfunction

endclass
