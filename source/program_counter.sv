`include "program_counter_if.vh"
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"

module program_counter (
  input logic CLK, nRST,
  program_counter_if.pc pcif
  /*
  input   imm16,j_addr26,jr,PCSrc,pc_next,
    output  i_addr,jar_addr
    */

);
  // import types
  import cpu_types_pkg::*;
  import diaosi_types_pkg::*;
  

  word_t add4_addr,branch_addr,jump_addr,next_addr;

  assign add4_addr = pcif.i_addr+4;
  assign branch_addr = add4_addr+{pcif.imm16,2'b0};
  assign jump_addr = {pcif.i_addr[31:28],pcif.j_addr26,2'b0};
  assign pcif.jar_addr = add4_addr;
  
  always @(posedge CLK, negedge nRST)
  begin
    if (1'b0 == nRST)
    begin
      pcif.i_addr <= '{default:0};
    end
    else
    begin
      if (pcif.pc_next)
      begin
        pcif.i_addr <= next_addr;
      end
    end
  end

  always_comb 
  begin
    casez(pcif.PCSrc)
      ADD4_DIAOSI: next_addr = add4_addr;
      JUMP_DIAOSI: next_addr = jump_addr;
      JR_DIAOSI: next_addr = pcif.jr;
      BRANCH_DIAOSI: next_addr = branch_addr;
      default: 
        next_addr = add4_addr;
     endcase
  end

endmodule
