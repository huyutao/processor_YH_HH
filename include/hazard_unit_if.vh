/*
  Hanwen Huang
  huang651@purdue.edu
  Yutao Hu
  CEO@purdue.com

  hazard_unit
*/
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"
`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH



interface hazard_unit_if;

  import cpu_types_pkg::*;
  import diaosi_types_pkg::*;  
  logic      flushed1, id_en1, flushed2, id_en2, pc_en, d_ren, branch_sel; //dren_2, dwen_2, dren_1;
  PCSrc_t    pc_src;
  regbits_t  rsel1, rsel2, wsel;   
  opcode_t   opcode;

  modport hu (
  	input    pc_src, d_ren, rsel1, rsel2, wsel, branch_sel, opcode,   //dren_2, dwen_2, dren_1,
  	output   pc_en, flushed1, id_en1, flushed2, id_en2
  );

  modport tb (
  	output  pc_src, d_ren, rsel1, rsel2, wsel, branch_sel, opcode,
  	input   pc_en, flushed1, id_en1, flushed2, id_en2
  );

endinterface
`endif
