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
module ex_mem(
  input logic CLK, nRST, 
  stage_if.ex_mem em
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

always_ff@(posedge CLK, negedge nRST) begin
	if (!nRST) begin
		em.jump_addr_o3    <= '{default:0};
		em.npc_o3 		   <= '{default:0};
		em.branch_addr_o3  <= '{default:0};
		em.jr_addr_o3      <= '{default:0};
		em.PCSrc_o3        <= ADD4_DIAOSI;
		em.W_mux_o3        <= LUI_DIAOSI;
		em.LUI_o3          <= '{default:0};
		em.wen_o3          <= '{default:0};
		em.wsel_o3         <= '{default:0};
		em.d_wen_o3        <= '{default:0};
		em.d_ren_o3        <= '{default:0};
		em.dmemstore_o3    <= '{default:0};
		em.halt_o3         <= '{default:0};
		em.dmemaddr_o3     <= '{default:0};
		em.imemload_o3     <= '{default:0};
	end
	else begin
		if (em.flushed == 1) begin 
			em.jump_addr_o3    <= '{default:0};
			em.npc_o3 		   <= '{default:0};
			em.branch_addr_o3  <= '{default:0};
			em.jr_addr_o3      <= '{default:0};
			em.PCSrc_o3        <= ADD4_DIAOSI;
			em.W_mux_o3        <= LUI_DIAOSI;;
			em.LUI_o3          <= '{default:0};
			em.wen_o3          <= '{default:0};
			em.wsel_o3         <= '{default:0};
			em.d_wen_o3        <= '{default:0};
			em.d_ren_o3        <= '{default:0};
			em.dmemstore_o3    <= '{default:0};
			em.halt_o3         <= '{default:0};  
			em.dmemaddr_o3     <= '{default:0};
			em.imemload_o3     <= '{default:0};
		end
		else if (em.pipe3_en == 1) begin
 			em.jump_addr_o3    <= em.jump_addr_i3;
			em.npc_o3 		   <= em.npc_i3;
			em.branch_addr_o3  <= em.branch_addr_i3;
			em.jr_addr_o3      <= em.jr_addr_i3;
			em.PCSrc_o3        <= em.PCSrc_i3;
			em.W_mux_o3        <= em.W_mux_i3;
			em.LUI_o3          <= em.LUI_i3;
			em.wen_o3          <= em.wen_i3;
			em.wsel_o3         <= em.wsel_i3;
			em.d_wen_o3        <= em.d_wen_i3;
			em.d_ren_o3        <= em.d_ren_i3;
			em.dmemstore_o3    <= em.dmemstore_i3;
			em.halt_o3         <= em.halt_i3;
			em.dmemaddr_o3     <= em.dmemaddr_i3;
			em.imemload_o3     <= em.imemload_i3;             
		end	
		else begin
 			em.jump_addr_o3    <= em.jump_addr_o3;
			em.npc_o3 		   <= em.npc_o3;
			em.branch_addr_o3  <= em.branch_addr_o3;
			em.jr_addr_o3      <= em.jr_addr_o3;
			em.PCSrc_o3        <= em.PCSrc_o3;
			em.W_mux_o3        <= em.W_mux_o3;
			em.LUI_o3          <= em.LUI_o3;
			em.wen_o3          <= em.wen_o3;
			em.wsel_o3         <= em.wsel_o3;
			em.d_wen_o3        <= em.d_wen_o3;
			em.d_ren_o3        <= em.d_ren_o3;
			em.dmemstore_o3    <= em.dmemstore_o3;
			em.halt_o3         <= em.halt_o3; 
			em.dmemaddr_o3     <= em.dmemaddr_o3;  
			em.imemload_o3     <= em.imemload_o3;    		
		end 
	end // else
end // always_ff@(posedge CLK, negedge nRST)
endmodule // ex_mem