/*
  Written by Yutao Hu
  alu test bench
*/

// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  // interface
  alu_if aluif ();
  // test program
  test PROG (aluif);
  // DUT
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
    .\aluif.op (aluif.op),
    .\aluif.a (aluif.a),
    .\aluif.b (aluif.b),
    .\aluif.out (aluif.out),
    .\aluif.zero_flag (aluif.zero_flag),
    .\aluif.negative_flag (aluif.negative_flag),
    .\aluif.overflow_flag (aluif.overflow_flag)
  );
`endif

endmodule

program test(alu_if.tb aluif);
  import cpu_types_pkg::*;

  parameter PERIOD = 10;

  initial begin
  aluif.a = 32'b101;
  aluif.b = 32'b1;
  aluif.op = ALU_SLL;
  # PERIOD;
  aluif.a = 32'b101;
  aluif.b = 32'b1;
  aluif.op = ALU_SRL;
  # PERIOD;
  aluif.a = 32'b101;
  aluif.b = 32'b1;
  aluif.op = ALU_ADD;
  # PERIOD;
  aluif.a = 32'h22;
  aluif.b = 32'h7FFFFFFF;
  aluif.op = ALU_ADD;
  # PERIOD;
  aluif.a = 32'b101;
  aluif.b = 32'b1;
  aluif.op = ALU_SUB;
  # PERIOD;
  aluif.a = 32'b1;
  aluif.b = 32'b101;
  aluif.op = ALU_SUB;
  # PERIOD;
  aluif.a = 32'b111;
  aluif.b = 32'b101;
  aluif.op = ALU_AND;
  # PERIOD;
  aluif.a = 32'b10;
  aluif.b = 32'b101;
  aluif.op = ALU_OR;
  # PERIOD;
  aluif.a = 32'b1;
  aluif.b = 32'b101;
  aluif.op = ALU_XOR;
  # PERIOD;
  aluif.a = 32'b1;
  aluif.b = 32'b101;
  aluif.op = ALU_NOR;
  # PERIOD;
  aluif.a = 32'hAFFFFFFF;
  aluif.b = 32'b101;
  aluif.op = ALU_SLT;
  # PERIOD;
  aluif.a = 32'hAFFFFFFF;
  aluif.b = 32'b101;
  aluif.op = ALU_SLTU;
  # PERIOD;
  end

endprogram
