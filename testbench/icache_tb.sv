// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module icache_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif();
  datapath_cache_if dcif();
  // test program
  test PROG();

`ifndef MAPPED
  icache DUT(CLK, nRST, dcif, cif);

`else
  icache DUT(
    .\CLK(CLK),
    .\nRST(nRST),
    .\dcif.imemREN(dcif.imemREN),
    .\dcif.imemaddr(dcif.imemaddr),
    .\cif.iwait(cif.iwait),
    .\cif.iload(cif.iload)
  );
`endif

endmodule

program test;
import cpu_types_pkg::*;
  parameter PERIOD = 10;
  initial begin

	int Num;	

	icache_tb.nRST = 1;
    

