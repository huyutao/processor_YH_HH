/*
  Hanwen Huang
  huang651@purdue.edu

  pc register
*/
`include "pc_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module pc (
   input  logic         CLK, nRST,
   pc_if.pc pcif
);

always_ff@(posedge CLK, negedge nRST) begin
  if (!nRST) 
      pcif.PC <= '0;
  else begin
      if (pcif.pc_en == 1)
          pcif.PC <= pcif.pc3;
      else                    //?
          pcif.PC <= pcif.PC;

  end
end

assign pcif.npc = pcif.PC+4;

endmodule
