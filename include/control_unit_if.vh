/*
  Eric Villasenor
  evillase@gmail.com

  control_unit interface
*/
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
  logic ru_dhit_in, ru_ihit_in;

  funct_t funct;
  opcode_t opcode;
  regbits_t rs,rt,rd;

  logic pc_next;
  aluop_t alu_op;
  logic ru_iren_out, ru_dren_out, ru_dwen_out;
  regbits_t wsel,rsel1,rsel2;
  logic wen;
  logic [15:0] imm16;
  logic [25:0] j_addr26;
  logic [4:0] shamt;
  logic [31:0] lui;
  PCSrc_t PCsrc;
  W_mux_t W_mux;
  ALUSrc_t ALUSrc;
  ExtOP_t ExtOP;

  


  // register file ports
  modport cu (
    input   instr, zero_f,overflow_f, ru_dhit_in, ru_ihit_in,
    output  pc_next, alu_op, ru_iren_out, ru_dren_out, ru_dwen_out,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCsrc, 
    W_mux, ALUSrc, ExtOP
  );
  // register file tb
  modport tb (
    input   wen,wsel,rsel1,rsel2,j_addr26,imm16,imm32,lui,alu_op,
    output  ru_dhit_in, ru_ihit_in, instr, branch_eq
  );
endinterface

`endif //REGISTER_FILE_IF_VH
