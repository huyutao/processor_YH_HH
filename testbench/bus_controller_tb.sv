// interfaces
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
// cpu types
`include "cpu_types_pkg.vh"


// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module bus_controller_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif0();
  caches_if cif1();
  cpu_ram_if ramif();
  
  ram ram(CLK,nRST,ramif);
  cache_control_if #(.CPUS(2)) ccif (cif0, cif1);
// test program setup
  test PROG();

  assign ramif.ramstore = ccif.ramstore; 
  assign ramif.ramWEN = ccif.ramWEN; 
  assign ramif.ramREN = ccif.ramREN; 
  assign ramif.ramaddr = ccif.ramaddr; 
  assign ccif.ramload = ramif.ramload; 
  assign ccif.ramstate = ramif.ramstate; 

`ifndef MAPPED
  bus_controller DUT(ccif,CLK,nRST);
`else
  bus_controller DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\ccif.iREN (ccif.iREN),
    .\ccif.dREN (ccif.dREN),
    .\ccif.dWEN (ccif.dWEN),
    .\ccif.dstore (ccif.dstore),
    .\ccif.iaddr (ccif.iaddr),
    .\ccif.daddr (ccif.daddr),
    .\ccif.ramload (ccif.ramload),
    .\ccif.ramstate (ccif.ramstate),
    .\ccif.ccwrite (ccif.ccwrite),
    .\ccif.cctrans (ccif.cctrans),
    .\ccif.iwait (ccif.iwait),
    .\ccif.dwait (ccif.dwait),
    .\ccif.iload (ccif.iload),
    .\ccif.dload (ccif.dload),
    .\ccif.ramstore (ccif.ramstore),
    .\ccif.ramaddr (ccif.ramaddr),
    .\ccif.ramWEN (ccif.ramWEN),
    .\ccif.ramREN (ccif.ramREN),
    .\ccif.ccwait (ccif.ccwait),
    .\ccif.ccinv (ccif.ccinv),
    .\ccif.ccsnoopaddr (ccif.snoopaddr)
  );
`endif

endmodule

program test;
  import cpu_types_pkg::*;
  parameter PERIOD = 10;

  initial begin
    bus_controller_tb.nRST = 0;
    bus_controller_tb.cif0.iREN = 0;
    bus_controller_tb.cif0.dREN = 0;
    bus_controller_tb.cif0.dWEN = 0;
    bus_controller_tb.cif0.dstore = 0;
    bus_controller_tb.cif0.iaddr = 0;
    bus_controller_tb.cif0.daddr = 0;
    bus_controller_tb.cif0.ccwrite = 0;
    bus_controller_tb.cif0.cctrans = 0;

    bus_controller_tb.cif1.iREN = 0;
    bus_controller_tb.cif1.dREN = 0;
    bus_controller_tb.cif1.dWEN = 0;
    bus_controller_tb.cif1.dstore = 0;
    bus_controller_tb.cif1.iaddr = 0;
    bus_controller_tb.cif1.daddr = 0;
    bus_controller_tb.cif1.ccwrite = 0;
    bus_controller_tb.cif1.cctrans = 0;
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.nRST = 1;

    #(PERIOD)
    @(posedge bus_controller_tb.CLK);          //CIF0 INVALID LOCALR  PUT READ ON BUS; CIF1 INVALID SNOOPR 
    bus_controller_tb.cif0.cctrans = 1;
    bus_controller_tb.cif0.dREN = 1;
    bus_controller_tb.cif0.daddr = 32'b1111000; //tag:1 index:111 block:0
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif0.cctrans = 0;        
    bus_controller_tb.cif1.cctrans = 1;
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif0.daddr = 32'b1111100; //tag:1 index:111 block:1
    bus_controller_tb.cif1.cctrans = 0;
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif0.dREN = 0;
    @(posedge bus_controller_tb.CLK);

    #(PERIOD)
    @(posedge bus_controller_tb.CLK);          //wb
    bus_controller_tb.cif0.cctrans = 0;
    bus_controller_tb.cif0.dWEN = 1;
    bus_controller_tb.cif0.dstore = 32'b111;
    bus_controller_tb.cif0.daddr = 32'b11110000; //tag:11 index:110 block:0
    @(posedge bus_controller_tb.CLK); 
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif0.daddr = 32'b11110100; //tag:11 index:110 block:1
    bus_controller_tb.cif0.dstore = 32'b11101;
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif0.dWEN = 0;
    @(posedge bus_controller_tb.CLK);

    #(PERIOD)
    @(posedge bus_controller_tb.CLK);          //iren
    bus_controller_tb.cif0.cctrans = 0;
    bus_controller_tb.cif0.iREN = 1;
    bus_controller_tb.cif0.iaddr = 32'b11110100; //tag:11 index:110 block:0
    @(posedge bus_controller_tb.CLK); 
    @(negedge bus_controller_tb.cif0.iwait);
    #(PERIOD)
    bus_controller_tb.cif0.iREN = 0;    

    #(PERIOD)
    @(posedge bus_controller_tb.CLK);          //ccwb
    bus_controller_tb.cif0.cctrans = 1;
    bus_controller_tb.cif0.dREN = 1;
    bus_controller_tb.cif0.daddr = 32'b11111000; //tag:11 index:111 block:0
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif0.cctrans = 0;        
    bus_controller_tb.cif1.cctrans = 1;
    bus_controller_tb.cif1.ccwrite = 1;
    bus_controller_tb.cif1.dstore = 32'b11;
    bus_controller_tb.cif1.daddr = 32'b11111000; //tag:11 index:111 block:0
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif0.daddr = 32'b11111100; //tag:11 index:111 block:1
    bus_controller_tb.cif1.daddr = 32'b11111100; //tag:11 index:111 block:1
    bus_controller_tb.cif1.cctrans = 0;
    bus_controller_tb.cif1.dstore = 32'b10;
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif1.ccwrite = 0; 
    bus_controller_tb.cif0.dREN = 0;
    @(posedge bus_controller_tb.CLK);

/*
    #(PERIOD)
    @(posedge bus_controller_tb.CLK);          //wb
    bus_controller_tb.cif0.cctrans = 0;
    bus_controller_tb.cif0.dWEN = 1;
    bus_controller_tb.cif0.dstore = 32'b111;
    bus_controller_tb.cif0.daddr = 32'b11110000; //tag:11 index:110 block:0
    @(posedge bus_controller_tb.CLK); 
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif0.daddr = 32'b11110100; //tag:11 index:110 block:1
    bus_controller_tb.cif0.dstore = 32'b11101;
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)
    bus_controller_tb.cif0.dWEN = 0;
    @(posedge bus_controller_tb.CLK);

    #(PERIOD)
    @(posedge bus_controller_tb.CLK);          //CIF0  LOCALR  PUT READ ON BUS; CIF1 MODIFIED SNOOPR 
    bus_controller_tb.cif0.cctrans = 0;
    bus_controller_tb.cif0.iREN = 1;
    bus_controller_tb.cif0.iaddr = 32'b11110100; //tag:11 index:110 block:0
    @(posedge bus_controller_tb.CLK); 
    @(negedge bus_controller_tb.cif0.dwait);
    #(PERIOD)

    //@(posedge dcif.dhit);
    //@(negedge CLK);

*/
    dump_memory();
  end


task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    ramif.memaddr = 0;
    ramif.memWEN = 0;
    ramif.memREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      ramif.memaddr = i << 2;
      ramif.memREN = 1;
      repeat (4) @(posedge bus_controller_tb.CLK);
      if (ramif.ramload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,ramif.ramload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),ramif.ramload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      ramif.memREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

endprogram