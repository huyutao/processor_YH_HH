/*
  Hanwen Huang
  huang651@purdue.edu
  Yutao Hu
  CEO@purdue.com

  hazard_unit
*/
`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"
interface forwarding_unit_if;

  import cpu_types_pkg::*;
  import diaosi_types_pkg::*;

  Forward_t      forwardA, forwardB;
  logic          wen_o3,wen_o4;
  Store_t        store;
  regbits_t      rsel1_o2, rsel2_o2, wsel_o3, wsel_o4;
  ALUSrc_t       ALUSrc;
  // register file ports
  modport fu (
    input   ALUSrc, wsel_o3, wen_o3, rsel1_o2, rsel2_o2, wen_o4, wsel_o4,
    output  forwardA, forwardB, store
  );
  // register file tb
  modport tb (
    output   ALUSrc, wsel_o3, wen_o3, rsel1_o2, rsel2_o2, wen_o4, wsel_o4,
    input    forwardA, forwardB, store
  );
endinterface

`endif
