/*
  Written by Yutao Hu
  alu test bench
*/

// mapped needs this

`include "datapath_cache_if.vh"
`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"



// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  datapath_cache_if dcif();

  caches_if cif();
  cache_control_if ccif (cif,cif);
  cpu_ram_if ramif();
  

  ram ram(CLK,nRST,ramif);
  caches cache_test(CLK, nRST, dcif, cif);
  

  // test program
  test PROG (CLK,nRST,dcif);

  assign ramif.ramstore = ccif.ramstore; 
  assign ramif.ramWEN = ccif.ramWEN; 
  assign ramif.ramREN = ccif.ramREN; 
  assign ramif.ramaddr = ccif.ramaddr; 
  assign ccif.ramload = ramif.ramload; 
  assign ccif.ramstate = ramif.ramstate; 

  // DUT
`ifndef MAPPED
  memory_control DUT(CLK,nRST,ccif);

`else
  memory_control DUT(
    .\CLK (CLK),
    .\nRST (nRST),
    .\ccif.ramload (ccif.ramload),
    .\ccif.ramstate (ccif.ramstate),

    .\ccif.ramstore (ccif.ramstore),
    .\ccif.ramWEN (ccif.ramWEN),
    .\ccif.ramREN (ccif.ramREN),
    .\ccif.ramaddr (ccif.ramaddr)
  );
`endif



endmodule

program test(
  input logic CLK,
  output logic nRST,
  datapath_cache_if.dp dcif
/* 
      modport dp (
    input   ihit, imemload, dhit, dmemload,
    output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
            dmemstore, dmemaddr
  );
*/
  );
  import cpu_types_pkg::*;
  parameter PERIOD = 10;

  initial begin
    nRST = 1;
    dcif.halt = 0;
    dcif.imemREN = 0;
    dcif.imemaddr = 0;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 0;
    # PERIOD;
    nRST = 0;
    # PERIOD;
    nRST = 1;
    # (PERIOD*2);     //read first addr to instru
    dcif.imemREN = 1;
    dcif.imemaddr = 32'h0004;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 32'h0008;
    # (PERIOD*2);     //free
    dcif.imemREN = 0;
    dcif.imemaddr = 32'h0004;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 32'h0008;
    # (2*PERIOD);
    dcif.imemREN = 1;    //read second addr to data
    dcif.imemaddr = 32'h0004;
    dcif.dmemREN = 1;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 32'h0008;
    @(posedge dcif.dhit);
    @(negedge CLK);
    dcif.imemREN = 0;      //free
    dcif.imemaddr = 32'h0004;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 32'h84;
    # (PERIOD*2);
    dcif.imemREN = 1;
    dcif.imemaddr = 32'h84;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 32'h84;
    # (PERIOD*2);
    dcif.imemREN = 1;      //write
    dcif.imemaddr = 32'h84;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 1;
    dcif.datomic = 0;
    dcif.dmemstore = 32'h12345678;
    dcif.dmemaddr = 32'h84;
    @(posedge dcif.dhit);
    @(negedge CLK);
    dcif.imemREN = 0;     //free
    dcif.dmemWEN = 0;
    # (PERIOD*2);       //read to instruct
    dcif.imemREN = 1;
    dcif.imemaddr = 32'h0084;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 32'h12345678;
    dcif.dmemaddr = 32'h84;
    # (PERIOD*2);        //free
    dcif.imemaddr = 32'h84;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.datomic = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 32'h84;
    # (PERIOD*2);

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
