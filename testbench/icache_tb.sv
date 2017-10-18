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

	icache_tb.nRST = 0;
	icache_tb.dcif.imemREN = 0;
	icache_tb.dcif.imemaddr = 0;
	icache_tb.cif.iwait = 0;
	icache_tb.cif.iload = 0;
  #(PERIOD);
  icache_tb.nRST = 1;
 	icache_tb.dcif.imemREN = 1'b1;
  #(PERIOD);
//read 111110     imemload = 32'b10101010
	icache_tb.dcif.imemaddr = 32'b111110;
	icache_tb.cif.iwait = 1;

  #(PERIOD);
  @(negedge icache_tb.CLK);
  icache_tb.cif.iwait = 0;
  icache_tb.cif.iload = 32'b10101010;
  @(posedge icache_tb.CLK);

  icache_tb.cif.iwait = 1;
  #(PERIOD);
//read 1111111010  imemload = 32'b101010010
	icache_tb.dcif.imemaddr = 32'b1111111010;
	icache_tb.cif.iwait = 1;
  icache_tb.cif.iload = 32'b101010010;

  #(PERIOD);
  @(negedge icache_tb.CLK);
	icache_tb.cif.iwait = 0;

  @(posedge icache_tb.CLK);

  icache_tb.cif.iwait = 1;
  #(PERIOD);
//read 111110  imemload = 32'b10101010
	icache_tb.dcif.imemaddr = 32'b111110;
  #(PERIOD);

//read 1111110 change tag      imemload = 101010100
	icache_tb.dcif.imemaddr = 32'b1111110;
  icache_tb.cif.iload = 32'b101010100;

  #(PERIOD);
  @(negedge icache_tb.CLK);
  icache_tb.cif.iwait = 0;

  @(posedge icache_tb.CLK);
  icache_tb.cif.iwait = 1;
    #(PERIOD);

  end
 endprogram