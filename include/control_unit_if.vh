`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;
  import diaosi_types_pkg::*;

  word_t instr;
  ZERO_SEL_t zero_sel;
  //logic i_hit;

  //logic pc_next;
  aluop_t alu_op;
  logic d_ren, d_wen;
  regbits_t wsel,rsel1,rsel2;
  logic wen;
  logic [15:0] imm16;
  logic [25:0] j_addr26;
  logic [4:0] shamt;
  logic [31:0] lui;
  PCSrc_t PCSrc;
  W_mux_t W_mux;
  ALUSrc_t ALUSrc;
  ExtOP_t ExtOP;
  logic halt;

  // register file ports
  modport cu (
    input   instr, 
    output  alu_op, d_ren, d_wen,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCSrc, 
    W_mux, ALUSrc, ExtOP, halt, zero_sel
  );
  // register file tb
  modport tb (
    input   alu_op, d_ren, d_wen,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCSrc, 
    W_mux, ALUSrc, ExtOP, halt, zero_sel,
    output  instr
  );

endinterface

`endif