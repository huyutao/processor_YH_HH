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

	if (fu.emwen & (fu.emsel != 0) & (fu.emsel == fu.dersel1))
		fu.forwardA = ALUOUT_DS;

	if (fu.emwen & (fu.emsel != 0) & (fu.emsel == fu.dersel2))
		fu.forwardB = ALUOUT_DS;	

	if (fu.emwen & (fu.emsel != 0) & (fu.emsel == fu.dersel1) & (fu.imemload == LUI)) 
		fu.forwardA = LUI_DS;

	if (fu.emwen & (fu.emsel != 0) & (fu.emsel == fu.dersel2) & (fu.imemload == LUI))
		fu.forwardB = LUI_DS;	

	if (fu.mwwen & (fu.mwsel != 0) & (fu.mwsel == fu.dersel1))
		fu.forwardA = DATA_DS;
		
	if (fu.mwwen & (fu.mwsel != 0) & (fu.mwsel == fu.dersel2))
		fu.forwardB = DATA_DS;

end

endmodule