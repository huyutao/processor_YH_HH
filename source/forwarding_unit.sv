/*
  Hanwen Huang
  huang651@purdue.edu
  Yutao Hu
  CEO@purdue.com

  forwarding_unit
*/

`include "cpu_types_pkg.vh"
`include "forwarding_unit_if.vh"
`include "diaosi_types_pkg.vh"
module forwarding_unit (
	forwarding_unit_if.fu fu
);
import cpu_types_pkg::*;
import diaosi_types_pkg::*;
always_comb 
begin
	fu.forwardA = RDAT_DS;
	fu.forwardB = RDAT_DS;
	fu.store    = RDAT2_STORE_O2_DIAOSI;
	if (fu.wen_o3 & (fu.wsel_o3 == fu.rsel2_o2) & (fu.ALUSrc == EXT_DIAOSI))
		fu.store    = DMEMADDR_STORE_O3_DIAOSI;

	if (fu.wen_o4 & (fu.wsel_o4 == fu.rsel2_o2) & (fu.ALUSrc == EXT_DIAOSI))
		fu.store    = DMEMADDR_STORE_O4_DIAOSI;

	if (fu.wen_o3 & (fu.wsel_o3 == fu.rsel1_o2))
		fu.forwardA = OUT3_DIAOSI;

	if (fu.wen_o3 & (fu.wsel_o3 == fu.rsel2_o2) & (fu.ALUSrc == RDAT2_DIAOSI))
		fu.forwardB = OUT3_DIAOSI;	

	if (fu.wen_o4 & (fu.wsel_o4 == fu.rsel1_o2))
		fu.forwardA = OUT4_DIAOSI;
		
	if (fu.wen_o4 & (fu.wsel_o4 == fu.rsel2_o2) & (fu.ALUSrc == RDAT2_DIAOSI))
		fu.forwardB = OUT4_DIAOSI;

end

endmodule