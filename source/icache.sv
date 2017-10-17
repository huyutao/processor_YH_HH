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

logic 		hit;

icachef_t iaddr;
assign iaddr.tag = icf.iload[31:6];
assign iaddr.idx = icf.iload[5:2];
assign iaddr.bytoff = icf.iload[1:0];
assign dcif.imemload = instr[iaddr.idx].data;
assign icf.imemaddr =  dcif.imemaddr;
assign dcif.ihit = hit;

icache_t instr [15:0];
istate_t state, next_state;

always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state <= IDLE;
		for (i = 0; i < 16; i++) begin
			 instr[i].tag <= 0;
			 instr[i].data <= 0;
			 instr[i].valid <= 0;
		end
	end else begin
		state <= next_state;
		if (hit) begin
			instr[iaddr.idx].tag 	<= instr[iaddr.idx].tag;
			instr[iaddr.idx].data   <= instr[iaddr.idx].data;
			instr[iaddr.idx].valid  <= instr[iaddr.idx].valid;
		end else begin
			instr[iaddr.idx].tag 	<= tag;
			instr[iaddr.idx].data   <= data;
			instr[iaddr.idx].valid  <= valid;
		end		
	end
end

always_comb begin
	hit = 0;
	if (instr[iaddr.idx].tag == iaddr.tag) begin
		if (instr[iaddr.idx].valid) begin
			hit = 1;
		end 
	end
end // always_comb

always_comb begin
	icf.iREN = 0;
	if (dcif.imemREN == 0) begin
		tag = instr[iaddr.idx].tag;
		data = instr[iaddr.idx].data;
		valid = instr[iaddr.idx].valid;
	end else begin
		casez (state) 
		IDLE:
		begin
		tag = iaddr.tag;
		data = icf.iload;
		valid = instr[iaddr.idx].valid;	
		if (!hit)
			next_state = LD;
		end
		LD:
		begin
			icf.iREN = 1;
			tag = instr[iaddr.idx].tag;
			data = instr[iaddr.idx].data;
			valid = 1;	
			if (!icf.iwait)
				next_state = IDLE;
		end
		endcase
	end
end



endmodule // icache
