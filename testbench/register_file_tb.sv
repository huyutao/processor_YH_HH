/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (rfif,nRST,CLK);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(register_file_if.tb rfif, output logic nRST, input logic CLK);
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  parameter PERIOD = 10;

  initial begin

  nRST = 0;
  #(PERIOD*5);
  nRST = 1;
  rfif.rsel1 = 5'b0;
  rfif.rsel2 = 5'b1;
  rfif.wsel = 5'b1;
  rfif.wdat = v1;
  rfif.WEN = 1;
  #(PERIOD*5);
  rfif.rsel1 = 5'b1;
  rfif.rsel2 = 5'b11;
  rfif.wsel = 5'b11;
  rfif.wdat = v2;
  rfif.WEN = 1;
  #(PERIOD*2);
  rfif.WEN = 0;
  rfif.rsel1 = 5'b11;
  rfif.rsel2 = 5'b100;
  rfif.wsel = 5'b100;
  rfif.wdat = v3;
  #(PERIOD*2);
  rfif.rsel2 = 5'b1;
  #(PERIOD*2);
  rfif.rsel1 = 5'b100;
  rfif.wsel = 5'b100;
  rfif.wdat = v3;
  rfif.WEN = 1;
  #(PERIOD*2);
  rfif.WEN = 1;
  rfif.rsel2 = 5'b100;
  end

endprogram
