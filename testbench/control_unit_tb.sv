// mapped needs this
`include "control_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  control_unit_if cuif();
  // test program
  test PROG (cuif,nRST,CLK);
  // DUT
`ifndef MAPPED
  control_unit DUT(CLK, nRST, cuif);
`else
  control_unit DUT(
    .\cuif.instr (cuif.instr),
    .\cuif.zero_f (cuif.zero_f),
    .\cuif.overflow_f (cuif.overflow_f),
    .\cuif.i_hit (cuif.i_hit),
    .\cuif.d_hit (cuif.d_hit),

    .\cuif.pc_next (cuif.pc_next),
    .\cuif.alu_op (cuif.alu_op),
    .\cuif.i_ren (cuif.i_ren),
    .\cuif.ru_dren_out (cuif.ru_dren_out),
    .\cuif.ru_dwen_out (cuif.ru_dwen_out),
    .\cuif.wsel (cuif.wsel),
    .\cuif.rsel1 (cuif.rsel1),
    .\cuif.rsel2 (cuif.rsel2),
    .\cuif.wen (cuif.wen),
    .\cuif.imm16 (cuif.imm16),
    .\cuif.j_addr26 (cuif.j_addr26),
    .\cuif.shamt (cuif.shamt),
    .\cuif.lui (cuif.lui),
    .\cuif.PCsrc (cuif.PCsrc),
    .\cuif.W_mux (cuif.W_mux),
    .\cuif.ALUSrc (cuif.ALUSrc),
    .\cuif.ExtOP (cuif.ExtOP),
    .\cuif.halt (cuif.halt),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(control_unit_if.tb cuif, output logic nRST, input logic CLK);

  parameter PERIOD = 10;

  initial begin

  nRST = 0;
  cuif.instr = 0;
  cuif.zero_f = 0;
  cuif.overflow_f = 0;
  cuif.d_hit = 0; 
  cuif.i_hit = 0;

  #(PERIOD*2);
  nRST = 1;
  #(PERIOD*2);
  cuif.instr = 32'h340100F0;
  #(PERIOD*2);
  cuif.i_hit = 1;
  cuif.instr = 32'h3C07DEAD;
  #(PERIOD);
  cuif.i_hit = 0;
  #(PERIOD);
  cuif.i_hit = 1;
  cuif.instr = 32'h8C230000;
  #(PERIOD);
  cuif.i_hit = 0;
  #(PERIOD);
  cuif.d_hit = 1;
  cuif.instr = 32'hAC440004;
  #(PERIOD*2);
  end

endprogram
