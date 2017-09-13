`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"

interface program_counter_if;
  // import types
  import cpu_types_pkg::*;
  import diaosi_types_pkg::*;

  logic [15:0] imm16;
  logic [25:0] j_addr26;
  word_t jr;
  PCSrc_t PCSrc;
  logic pc_next;

  word_t i_addr;


  // pc file ports
  modport pc (
    input   imm16,j_addr26,jr,PCsrc,pc_next,
    output  i_addr
  );
  // register file tb
  /*
  modport tb (
    input   wen,wsel,rsel1,rsel2,j_addr26,imm16,imm32,lui,alu_op,
    output  ru_dhit_in, ru_ihit_in, instr, branch_eq
  );*/
endinterface

`endif //REGISTER_FILE_IF_VH
