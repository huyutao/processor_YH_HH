/*
  Hanwen Huang
  huang651@purdue.edu
  Yutao Hu
  CEO@purdue.com
  
  reg for ex_mem
*/
`include "diaosi_types_pkg.vh"
`include "cpu_types_pkg.vh"
`include "stage_if.vh"
module mem_wb(
  input logic CLK, nRST, 
  stage_if.mem_wb mw
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

always_ff@(posedge CLK, negedge nRST) begin
	if (!nRST) begin
		mw.jump_addr_o4      <= '{default:0};
		mw.npc_o4            <= '{default:0};
		mw.branch_addr_o4    <= '{default:0};
		mw.jr_addr_o4        <= '{default:0};
		mw.PCSrc_o4          <= ADD4_DIAOSI;
		mw.W_mux_o4          <= LUI_DIAOSI;
		mw.LUI_o4            <= '{default:0};
		mw.wen_o4            <= '{default:0};
		mw.wsel_o4           <= '{default:0};
		mw.dmemload_o4       <= '{default:0};
		mw.dmemaddr_o4       <= '{default:0};   
		mw.imemload_o4       <= '{default:0};   
		mw.d_ren_o4          <= '{default:0};
	end // if (!nRST)
	else begin
		if (mw.wb_en == 1) begin
			mw.jump_addr_o4      <= mw.jump_addr_i4;
			mw.npc_o4            <= mw.npc_i4;
			mw.branch_addr_o4    <= mw.branch_addr_i4;
			mw.jr_addr_o4        <= mw.jr_addr_i4;
			mw.PCSrc_o4          <= mw.PCSrc_i4;
			mw.W_mux_o4          <= mw.W_mux_i4;
			mw.LUI_o4            <= mw.LUI_i4;
			mw.wen_o4            <= mw.wen_i4;
			mw.wsel_o4           <= mw.wsel_i4;
			mw.dmemload_o4       <= mw.dmemload_i4;
			mw.dmemaddr_o4       <= mw.dmemaddr_i4;   	
			mw.imemload_o4       <= mw.imemload_i4;   
			mw.d_ren_o4          <= mw.d_ren_i4;		
		end // if (mw.en == 1)
		else begin
			mw.jump_addr_o4      <= mw.jump_addr_o4;
			mw.npc_o4            <= mw.npc_o4;
			mw.branch_addr_o4    <= mw.branch_addr_o4;
			mw.jr_addr_o4        <= mw.jr_addr_o4;
			mw.PCSrc_o4          <= mw.PCSrc_o4;
			mw.W_mux_o4          <= mw.W_mux_o4;
			mw.LUI_o4            <= mw.LUI_o4;
			mw.wen_o4            <= mw.wen_o4;
			mw.wsel_o4           <= mw.wsel_o4;
			mw.dmemload_o4       <= mw.dmemload_o4;
			mw.dmemaddr_o4       <= mw.dmemaddr_o4;   
			mw.imemload_o4       <= mw.imemload_o4;
			mw.d_ren_o4          <= mw.d_ren_o4;
		end // else
	end // else
end // always_ff@(posedge CLK, negedge nRST)
endmodule // ex_mem