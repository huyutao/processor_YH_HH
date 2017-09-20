`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  word_t PC, pc3, npc;
  logic pc_en;


  modport pc (
	input pc_en, pc3,
	output PC, npc
  );

  modport tb (
	input PC, npc,
	output pc_en, pc3
  );
endinterface

`endif
