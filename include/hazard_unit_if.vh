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
  logic      flushed1, pipe1_en, flushed2, flushed3, pipe2_en, pipe3_en, pipe4_en,
             pc_en, dhit, branch_sel, ihit; //dren_2, dwen_2, dren_1;
  PCSrc_t    pc_src;
  regbits_t  rsel1, rsel2, wsel, wsel_o3;   
  opcode_t   opcode;
  word_t     rfrs, rfrt;   
  modport hu (
  	input    pc_src, dhit, rsel1, rsel2, wsel, branch_sel, opcode, ihit,   //dren_2, dwen_2, dren_1,
  	         rfrs, rfrt, wsel_o3, 
    output   pc_en, flushed1, pipe1_en, flushed2, flushed3, pipe2_en, pipe3_en, pipe4_en
  );


endinterface
`endif
