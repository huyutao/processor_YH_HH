`include "program_counter_if.vh"
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"

module program_counter (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
  /*
  input   imm16,j_addr26,jr,PCSrc,pc_next,
    output  i_addr
    */

);
  // import types
  import cpu_types_pkg::*;
  program_counter_if pcif();

  word_t add4_addr,branch_addr,jump_addr,next_addr;

  assign add4_addr = dpif.i_addr+4;
  assign branch_addr = dpif.i_addr+dpif.imm16;
  assign jump_addr = {dpif.i_addr[31:28],dpif.j_addr26,2'b0};

  always @(posedge CLK, negedge nRST)
  begin
    if (1'b0 == nRST)
    begin
      pcif.i_addr <= '{default:0};
    end
    else
    begin
      if (pcif.pc_next)
        pcif.i_addr <= next_addr;
    end
  end

  always_comb 
  begin
    casez(dpif.PCSrc)
      ADD4_DIAOSI: next_addr = add4_addr;
      JUMP_DIAOSI: next_addr = jump_addr;
      JR_DIAOSI: next_addr = dpif.jr;
      BRANCH_DIAOSI: next_addr = branch_addr;
      default: 
        next_addr = add4_addr;
     endcase
  end

endmodule
