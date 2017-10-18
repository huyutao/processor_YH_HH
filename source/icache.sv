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
integer     i;
logic       IDLE;


icachef_t iaddr;
assign iaddr.tag = dcif.imemaddr[31:6];
assign iaddr.idx = dcif.imemaddr[5:2];
assign iaddr.bytoff = dcif.imemaddr[1:0];
assign dcif.imemload = frame[iaddr.idx].data;
assign icf.iaddr =  dcif.imemaddr;
assign dcif.ihit = hit;

Icache_t frame [15:0];
Icache_t next_frame;
Istate_t state, next_state;

always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state <= IDLE_I;
		for (i = 0; i < 16; i++) begin
			 frame[i].tag <= 0;
			 frame[i].data <= 0;
			 frame[i].valid <= 0;
		end
	end else begin
		state <= next_state;
		if (hit) begin
			frame[iaddr.idx].tag 	<= frame[iaddr.idx].tag;
			frame[iaddr.idx].data   <= frame[iaddr.idx].data;
			frame[iaddr.idx].valid  <= frame[iaddr.idx].valid;
		end else begin
			frame[iaddr.idx].tag 	<= next_frame.tag;
			frame[iaddr.idx].data   <= next_frame.data;
			frame[iaddr.idx].valid  <= next_frame.valid;
		end		
	end
end

always_comb begin
	hit = 0;
	if (frame[iaddr.idx].tag == iaddr.tag) begin
		if (frame[iaddr.idx].valid)  begin
			hit = 1;
		end 
	end
end // always_comb

always_comb begin
	IDLE = 1;
	icf.iREN = 0;
	if (dcif.imemREN == 0) begin
		next_frame.tag	= frame[iaddr.idx].tag;
		next_frame.data   = frame[iaddr.idx].data;
		next_frame.valid  = frame[iaddr.idx].valid;
	end else begin
		casez (state) 
		IDLE_I:
		begin
		IDLE = 1;	
		if (!hit)
			next_state = LD;
		end
		LD:
		begin
			IDLE = 0;
			icf.iREN = 1;
			next_frame.tag = iaddr.tag;
			next_frame.data = icf.iload;
			next_frame.valid = 1;
			if (!icf.iwait)
				next_state = IDLE_I;
		end
		endcase
	end
end



endmodule // icache
