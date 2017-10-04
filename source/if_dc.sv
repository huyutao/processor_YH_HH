/*
  Hanwen Huang
  huang651@purdue.edu
  Yutao Hu
  CEO@purdue.com

  reg for if_dc
*/

`include "cpu_types_pkg.vh"
`include "stage_if.vh"
module if_dc(
  input logic CLK, nRST, 
  stage_if.if_dc id
);

import cpu_types_pkg::*;


always_ff@(posedge CLK, negedge nRST) begin
	if (!nRST) begin
		id.npc_o1 <= '{default:0};
		id.imemload_o1 <= '{default:0};
	end 
  else begin
      if (id.hz_flushed1) begin
        id.npc_o1 <= id.npc_o1;
        id.imemload_o1 <= '{default:0};

    	end else if (id.pipe1_en == 1) begin
        id.npc_o1 <= id.npc_i1;
    		id.imemload_o1 <= id.imemload_i1;
    	end 
      else begin
        id.npc_o1 <= id.npc_o1;
    		id.imemload_o1 <= id.imemload_o1;
    	end
  end
end
endmodule