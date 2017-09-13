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
  logic zero_f,overflow_f;
  logic i_hit, d_hit;

  logic pc_next;
  aluop_t alu_op;
  logic i_ren, ru_dren_out, ru_dwen_out;
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
    input   instr, zero_f,overflow_f, i_hit, d_hit,
    output  pc_next, alu_op, i_ren, ru_dren_out, ru_dwen_out,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCSrc, 
    W_mux, ALUSrc, ExtOP, halt
  );
  // register file tb
  modport tb (
    input   pc_next, alu_op, i_ren, ru_dren_out, ru_dwen_out,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCSrc, 
    W_mux, ALUSrc, ExtOP, halt,
    output  instr, zero_f,overflow_f, d_hit, i_hit
  );
endinterface

`endif