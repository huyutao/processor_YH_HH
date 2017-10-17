// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"



module icache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if.icache icf
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

logic [2:0] idx;

icachef_t iaddr;
assign iaddr.tag = icf.iload[31:6];
assign iaddr.idx = icf.iload[5:2];
assign iaddr.bytoff = icf.iload[1:0];

icache_t instr [15:0];

always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		for (i = 0; i < 16; i++) begin
			 instr[i].tag <= 0;
			 instr[i].data <= 0;
			 instr[i].valid <= 0;
		end
	end else begin
		instr[iaddr.idx].tag 	<= tag;
		instr[iaddr.idx].data   <= data;
		instr[iaddr.idx].valid  <= valid;		
	end
end

always_comb begin



end // always_comb
endmodule // icache