/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  caches_if cif
);
  // import types
  import cpu_types_pkg::word_t;

  parameter CPUID = 0;


  // icache
  icache  ICACHE(dcif, cif, CLK, nRST);
  // dcache
  dcache  DCACHE(dcif, cif, CLK, nRST);

endmodule
  // single cycle instr saver (for memory ops)

/*
  word_t instr;
  word_t daddr;
  always_ff @(posedge CLK)
  begin
    if (!nRST)
    begin
      instr <= '0;
      daddr <= '0;
    end
    else
    if (dcif.ihit)
    begin
      instr <= cif.iload;
      daddr <= dcif.dmemaddr;
    end
  end


  // dcache invalidate before halt
  assign dcif.flushed = dcif.halt;

  //single cycle
  assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  assign dcif.imemload = cif.iload;
  assign dcif.dmemload = cif.dload;


  assign cif.iREN = dcif.imemREN;
  assign cif.dREN = dcif.dmemREN;
  assign cif.dWEN = dcif.dmemWEN;
  assign cif.dstore = dcif.dmemstore;
  assign cif.iaddr = dcif.imemaddr;
  assign cif.daddr = dcif.dmemaddr;
*/