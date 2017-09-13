/*
  Written by Yutao Hu
  alu interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic     zero_flag, negative_flag, overflow_flag;
  word_t    a, b, out;
  aluop_t   op;

  // register file ports
  modport af (
    input   op, a, b,
    output  out, zero_flag, negative_flag, overflow_flag
  );
  // register file tb
  modport tb (
    input  out, zero_flag, negative_flag, overflow_flag,
    output   op, a, b
  );
endinterface

`endif //REGISTER_FILE_IF_VH
