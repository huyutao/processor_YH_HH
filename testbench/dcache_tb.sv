// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

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
  dcache DUT(dcif, cif, CLK, nRST);

`else
  dcache DUT(
    .\CLK(CLK),
    .\nRST(nRST),
    .\dcif.halt(dcif.halt),
    .\dcif.dmemREN(dcif.dmemREN),
    .\dcif.dmemWEN(dcif.dmemWEN),
    .\dcif.dmemaddr(dcif.dmemaddr),
    .\dcif.dmemstore(dcif.dmemstore),  
    .\cif.ccwait(cif.ccwait),
    .\cif.ccinv(cif.ccinv),
    .\cif.ccsnoopaddr(cif.ccsnoopaddr),
    .\cif.dwait(cif.dwait),
    .\cif.dload(cif.dload)
  );
`endif
endmodule

program test;

import cpu_types_pkg::*;
  parameter PERIOD = 10;
  initial begin
  dcache_tb.nRST = 0;
  dcache_tb.dcif.halt = 0;
  dcache_tb.dcif.dmemstore = 0;
  dcache_tb.dcif.dmemWEN = 0;
  dcache_tb.dcif.dmemREN = 0;
  dcache_tb.dcif.dmemaddr = 0;
  dcache_tb.cif.dwait = 1;
  dcache_tb.cif.dload = 2'b10;
  dcache_tb.cif.ccwait = 0;
  dcache_tb.cif.ccsnoopaddr = 0;
  dcache_tb.cif.ccinv = 0;
  #(PERIOD);
  dcache_tb.nRST = 1;
  #(PERIOD);
//read empty values  address tag 1 index 111 blockoffset 1
  dcache_tb.dcif.dmemREN = 1;
  dcache_tb.dcif.dmemaddr = 32'b1111100;      //miss     -1
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  
  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD)
  dcache_tb.dcif.dmemREN = 0;
  #(PERIOD*2);          //wait

//write datas address  ld test  tag 1 index 111 block offset 1
  dcache_tb.dcif.dmemWEN = 1;
  dcache_tb.dcif.dmemaddr = 32'b1111100;
  dcache_tb.dcif.dmemstore = 32'b11;          //hit = 1    1 
  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD)
  dcache_tb.dcif.dmemWEN = 0;
  #(PERIOD);

  dcache_tb.dcif.dmemWEN = 1;
  dcache_tb.dcif.dmemaddr = 32'b1111100;
  dcache_tb.dcif.dmemstore = 32'b111;        //hit = 2     2
  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD)
  dcache_tb.dcif.dmemWEN = 0;
  #(PERIOD);

  dcache_tb.dcif.dmemWEN = 1;
  dcache_tb.dcif.dmemaddr = 32'b1111100;      //7C
  dcache_tb.dcif.dmemstore = 32'b1111;       //hit = 3     3
  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD)
  dcache_tb.dcif.dmemWEN = 0;
  #(PERIOD);

//read datas address before ans = 32'b1111   //hit = 4     4
  dcache_tb.dcif.dmemREN = 1;
  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD); 
  dcache_tb.dcif.dmemREN = 0;
  #(PERIOD*2); 


//write back test  tag 11 index111 blockoffset 1
  dcache_tb.dcif.dmemWEN = 1;
  dcache_tb.dcif.dmemaddr = 32'b11111100;     //FC
  dcache_tb.dcif.dmemstore = 32'b110;        //miss       2
  dcache_tb.cif.dwait = 1;
  dcache_tb.cif.dload = 32'b111111;
  #(PERIOD)
  @(negedge dcache_tb.CLK)
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD); 
  dcache_tb.dcif.dmemWEN = 0;
  #(PERIOD*2); 

  dcache_tb.dcif.dmemWEN = 1;
  dcache_tb.cif.dwait = 1;                  //            3
  dcache_tb.dcif.dmemaddr = 32'b11111100;    //dirty   hit = 5
  dcache_tb.dcif.dmemstore = 32'b1100; 

  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD); 
  dcache_tb.dcif.dmemWEN = 0;
  #(PERIOD*2); 

  dcache_tb.dcif.dmemWEN = 1;
  dcache_tb.dcif.dmemaddr = 32'b111111100;
  dcache_tb.dcif.dmemstore = 32'b110;        //miss wb
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  @(negedge dcache_tb.CLK)
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  @(posedge dcache_tb.dcif.dhit)
  #(PERIOD); 
  dcache_tb.dcif.dmemWEN = 0;
  #(PERIOD*3); 

  dcache_tb.cif.ccwait = 1;
  dcache_tb.cif.ccsnoopaddr = 32'b11111100;
  #(PERIOD);    
  @(negedge dcache_tb.CLK)
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.ccwait = 0;
  dcache_tb.cif.ccsnoopaddr = 0;

  dcache_tb.cif.ccwait = 1;
  dcache_tb.cif.ccsnoopaddr = 32'b11111100;
  #(PERIOD);    
  @(negedge dcache_tb.CLK)
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.ccwait = 0;
  dcache_tb.cif.ccsnoopaddr = 0;
  #(PERIOD);
  dcache_tb.cif.ccwait = 1;
  dcache_tb.cif.ccsnoopaddr = 32'b11111100;
  dcache_tb.cif.ccinv = 1;
  #(PERIOD);
  dcache_tb.cif.ccwait = 0; 
  #(PERIOD);
  dcache_tb.cif.ccwait = 1;
  dcache_tb.cif.ccsnoopaddr = 32'b11111100;
  dcache_tb.cif.ccinv = 0;
  #(PERIOD);    
  dcache_tb.cif.ccwait = 0;
//halt
  dcache_tb.dcif.halt = 1;
  #(PERIOD);  
  #(PERIOD);                     //flush block 0
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;  
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;      //flush block 1
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;
  #(PERIOD);    
  dcache_tb.cif.dwait = 0;
  #(PERIOD); 
  dcache_tb.cif.dwait = 1;   
  #(PERIOD);  
 
  end
 endprogram