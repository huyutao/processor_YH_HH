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
  test PROG (CLK,nRST,ccif);

  assign ramif.ramstore = ccif.ramstore; 
  assign ramif.ramWEN = ccif.ramWEN; 
  assign ramif.ramREN = ccif.ramREN; 
  assign ramif.ramaddr = ccif.ramaddr; 
  assign ccif.ramload = ramif.ramload; 
  assign ccif.ramstate = ramif.ramstate; 

`ifndef MAPPED
  bus_controller DUT();
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
    nRST = 1;
    #(PERIOD)
    @(posedge bus_controller_tb.CLK);          //CIF0 INVALID LOCALR  PUT READ ON BUS; CIF1 INVALID SNOOPR 
    bus_controller_tb.cif0.cctrans = 1
   	bus_controller_tb.cif0.dREN = 1;
   	bus_controller_tb.cif0.daddr = 32'b1111100; //tag:1 index:111 block:1
    @(posedge bus_controller_tb.CLK);        
    bus_controller_tb.cif1.cctrans = 1
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif1.cctrans = 0
    bus_controller_tb.cif0.cctrans = 0
/*
    #(PERIOD)                                   //CIF0 Shared SNOOPW;  CIF1 INVALID LOCALW  PUT  W ON BUS
    bus_controller_tb.cif1.cctrans = 1;
    bus_controller_tb.cif0.dREN = 0;
    bus_controller_tb.cif1.dWEN = 1;
    bus_controller_tb.cif1.daddr = 32'b11111100; //tag:11 index:111 block:1
    bus_controller_tb.cif1.dstore = 32'b111;
    //@(posedge ~bus_controller_tb.cif0.ccwait);
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif0.cctrans = 1;
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif0.cctrans = 0;

    # (PERIOD);           //CIF0 INVALID LOCALW  PUT  W ON BUS; CIF1 MODIFIED SNOOPW   WB
    bus_controller_tb.cif1.dWEN = 0;
    bus_controller_tb.cif0.dWEN = 1;
    bus_controller_tb.cif0.daddr = 32'b11111100; //tag:11 index:111 block:1 
    bus_controller_tb.cif0.dstore = 32'b1111;   
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif1.cctrans = 1;
    bus_controller_tb.cif1.ccwrite = 1;     //???
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif1.cctrans = 0;
    bus_controller_tb.cif1.ccwrite = 0;    
    #(PERIOD*3)    

    # PERIOD;           //CIF0 MODIFIED SNOOPR  WB   ; CIF1 INVALID LOCALR PUT READ ON BUS
    bus_controller_tb.cif0.dWEN = 0;
    bus_controller_tb.cif1.dREN = 1;
   	bus_controller_tb.cif1.daddr = 32'b1111100; //tag:1 index:111 block:1    
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif1.cctrans = 1;
    bus_controller_tb.cif1.ccwrite = 1;     //???
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif1.cctrans = 0;
    bus_controller_tb.cif1.ccwrite = 0;    
    #(PERIOD*3)    

    # PERIOD;           //CIF0 Shared LOCALW   PUT INVALIDATION;  CIF1 Shared SNOOPW
    bus_controller_tb.cif1.dREN = 0;
    bus_controller_tb.cif0.dWEN = 1;
   	bus_controller_tb.cif0.daddr = 32'b10111100; //tag:10 index:111 block:1  
   	bus_controller_tb.cif0.dstore = 32'b11;
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif1.cctrans = 1;
    bus_controller_tb.cif1.ccwrite = 0;     //???
    @(posedge bus_controller_tb.CLK);
    bus_controller_tb.cif1.cctrans = 0;
    bus_controller_tb.cif1.ccwrite = 0; 

    # PERIOD;           //CIF0 MODIFIED;        CIF1 INVALID

*/

    //@(posedge dcif.dhit);
    //@(negedge CLK);


    dump_memory();
  end


task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    dcif.imemaddr = 0;
    dcif.dmemWEN = 0;
    dcif.imemREN = 0;

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

      dcif.imemaddr = i << 2;
      dcif.imemREN = 1;
      repeat (4) @(posedge CLK);
      if (dcif.imemload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,dcif.imemload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),dcif.imemload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      dcif.imemREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask

endprogram
