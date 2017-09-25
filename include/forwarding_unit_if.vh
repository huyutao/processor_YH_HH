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
  logic          emwen,mwwen;
  Store_t        store;
  opcode_t       imemload;
  regbits_t      dersel1, dersel2, emsel, mwsel;
  ALUSrc_t       ALUSrc;
  // register file ports
  modport fu (
    input   ALUSrc, emsel, emwen, dersel1, dersel2, imemload, mwwen, mwsel,
    output  forwardA, forwardB, store
  );
  // register file tb
  modport tb (
    output   ALUSrc, emsel, emwen, dersel1, dersel2, imemload, mwwen, mwsel,
    input    forwardA, forwardB, store
  );
endinterface

`endif
