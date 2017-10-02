/*
  Hanwen Huang
  huang651@purdue.edu
  Yutao Hu
  CEO@purdue.com

  reg for dc_ex
*/
`include "diaosi_types_pkg.vh"
`include "cpu_types_pkg.vh"
`include "stage_if.vh"
module dc_ex(
  input logic CLK, nRST, 
  stage_if.dc_ex de
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

always_ff@(posedge CLK, negedge nRST) begin
	if (!nRST) begin
		de.npc_o2      <= '{default:0};
		de.ext32_o2    <= '{default:0};
		de.j_addr26_o2 <= '{default:0};
		de.imm16_o2    <= '{default:0};
		de.LUI_o2      <= '{default:0};
        de.zero_sel_o2 <= BEQ_DIAOSI;
        de.PCSrc_o2    <= ADD4_DIAOSI;
        de.ALUSrc_o2   <= RDAT2_DIAOSI;
        de.W_mux_o2    <= LUI_DIAOSI;
        de.shamt_o2    <= '{default:0};
        de.halt_o2     <= '{default:0};
        de.d_ren_o2    <= '{default:0};
        de.d_wen_o2    <= '{default:0};
        de.wen_o2      <= '{default:0};
        de.wsel_o2     <= '{default:0};
        de.alu_op_o2   <= ALU_SLL;
        de.rdat2_o2    <= '{default:0};
        de.rdat1_o2    <= '{default:0};
        de.imemload_o2 <= '{default:0};
        de.rsel1_o2    <= '{default:0};  
        de.rsel2_o2    <= '{default:0};
	end 
  	else begin
        if (de.hz_flushed2) begin
            de.npc_o2      <= '{default:0};
            de.ext32_o2    <= '{default:0};
            de.j_addr26_o2 <= '{default:0};
            de.imm16_o2    <= '{default:0};
            de.LUI_o2      <= '{default:0};
            de.zero_sel_o2 <= BEQ_DIAOSI;
            de.PCSrc_o2    <= ADD4_DIAOSI;
            de.ALUSrc_o2   <= RDAT2_DIAOSI;
            de.W_mux_o2    <= LUI_DIAOSI;
            de.shamt_o2    <= '{default:0};
            de.halt_o2     <= '{default:0};
            de.d_ren_o2    <= '{default:0};
            de.d_wen_o2    <= '{default:0};
            de.wen_o2      <= '{default:0};
            de.wsel_o2     <= '{default:0};
            de.alu_op_o2   <= ALU_SLL;
            de.rdat2_o2    <= '{default:0};
            de.rdat1_o2    <= '{default:0};
            de.imemload_o2 <= '{default:0};
            de.rsel1_o2    <= '{default:0};  
            de.rsel2_o2    <= '{default:0};
        end
    	else if (de.id_en2 == 1) begin
            de.npc_o2       <= de.npc_i2;
            de.ext32_o2     <= de.ext32_i2;
            de.j_addr26_o2  <= de.j_addr26_i2;
            de.imm16_o2     <= de.imm16_i2;
            de.LUI_o2       <= de.LUI_i2;
            de.zero_sel_o2  <= de.zero_sel_i2;
            de.PCSrc_o2     <= de.PCSrc_i2;
            de.ALUSrc_o2    <= de.ALUSrc_i2;
            de.W_mux_o2     <= de.W_mux_i2;
            de.shamt_o2     <= de.shamt_i2;
            de.halt_o2      <= de.halt_i2;
            de.d_ren_o2     <= de.d_ren_i2;
            de.d_wen_o2     <= de.d_wen_i2;
            de.wen_o2       <= de.wen_i2;
            de.wsel_o2      <= de.wsel_i2;
            de.alu_op_o2    <= de.alu_op_i2;
            de.rdat2_o2     <= de.rdat2_i2;
            de.rdat1_o2     <= de.rdat1_i2;
            de.imemload_o2  <= de.imemload_i2;
            de.rsel1_o2     <= de.rsel1_i2;  
            de.rsel2_o2     <= de.rsel2_i2;
    	end 
        else begin
            de.npc_o2       <= de.npc_o2;
            de.ext32_o2     <= de.ext32_o2;
            de.j_addr26_o2  <= de.j_addr26_o2;
            de.imm16_o2     <= de.imm16_o2;
            de.LUI_o2       <= de.LUI_o2;
            de.zero_sel_o2  <= de.zero_sel_o2;
            de.PCSrc_o2     <= de.PCSrc_o2;
            de.ALUSrc_o2    <= de.ALUSrc_o2;
            de.W_mux_o2     <= de.W_mux_o2;
            de.shamt_o2     <= de.shamt_o2;
            de.halt_o2      <= de.halt_o2;
            de.d_ren_o2     <= de.d_ren_o2;
            de.d_wen_o2     <= de.d_wen_o2;
            de.wen_o2       <= de.wen_o2;
            de.wsel_o2      <= de.wsel_o2;
            de.alu_op_o2    <= de.alu_op_o2;
            de.rdat2_o2     <= de.rdat2_o2;
            de.rdat1_o2     <= de.rdat1_o2;
            de.imemload_o2  <= de.imemload_o2;
            de.rsel1_o2     <= de.rsel1_o2;  
            de.rsel2_o2     <= de.rsel2_o2;
    	end
    end
end
endmodule
