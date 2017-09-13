// mapped needs this
`include "request_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  request_unit_if ruif();
  // test program
  test PROG (ruif,nRST,CLK);
  // DUT
`ifndef MAPPED
  request_unit DUT(CLK, nRST, ruif);
`else
  request_unit DUT(
    .\ruif.d_hit (ruif.d_hit),
    .\ruif.cu_dren_out (ruif.cu_dren_out),
    .\ruif.cu_dwen_out (ruif.cu_dwen_out),

    .\ruif.d_ren (ruif.d_ren),
    .\ruif.d_wen (ruif.d_wen),

    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(request_unit_if.tb ruif, output logic nRST, input logic CLK);

  parameter PERIOD = 10;

  initial begin

  nRST = 0;
  ruif.cu_dren_out = 0;
  ruif.cu_dwen_out = 0;
  ruif.d_hit = 0; 

  #(PERIOD*2);
  nRST = 1;
  #(PERIOD*2);
  ruif.cu_dren_out = 1;
  #(PERIOD*2);
  ruif.d_hit = 1;
  #(PERIOD);
  ruif.cu_dren_out = 0;
  ruif.cu_dwen_out = 0;
  ruif.d_hit = 0; 
  #(PERIOD);
  ruif.cu_dwen_out = 1;
  #(PERIOD*2);
  ruif.d_hit = 1;
  #(PERIOD*2);

  end

endprogram
