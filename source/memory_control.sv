/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;


always_comb 
begin
  ccif.ramaddr = '0;
  ccif.ramREN = 0;
  ccif.ramWEN = 0;
  ccif.ramstore = '0;

  ccif.dwait = 1;
  ccif.iwait = 1;
  ccif.dload = '0;
  ccif.iload = '0;

  if (ccif.dREN)
  begin
    ccif.ramaddr = ccif.daddr;
    ccif.ramREN = 1;
  end
  else if (ccif.dWEN)
  begin
    ccif.ramaddr = ccif.daddr;
    ccif.ramstore = ccif.dstore;
    ccif.ramWEN = 1;
  end
  else if (ccif.iREN)
  begin 
    ccif.ramaddr = ccif.iaddr;
    ccif.ramREN = 1;
  end


  if (ccif.ramstate == ACCESS)
  begin
    if (ccif.dWEN)
    begin
      ccif.dwait = 0;
    end 
    else if (ccif.dREN)
    begin
      ccif.dload = ccif.ramload;
      ccif.dwait = 0;
    end 
    else if (ccif.iREN)
    begin
      ccif.iload = ccif.ramload;
      ccif.iwait = 0;
    end
  end
end


endmodule