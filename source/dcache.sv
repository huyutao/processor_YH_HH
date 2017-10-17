// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"


module dcache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if.dcache dcf
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;


dcachef_t daddr;
assign daddr.tag = dcif.dmemaddr[31:6];
assign daddr.idx = dcif.dmemaddr[5:3];
assign daddr.blkoff = dcif.dmemaddr[2];
assign daddr.bytoff =  dcif.dmemaddr[1:0];

Dcache_t l_frame[7:0], r_frame[7:0],next_l_frame,next_r_frame;
Dstate_t state,next_state;
logic lru[7:0] next_lru[7:0];
logic [4:0] flush_i, next_flush_i;
word_t hit_cnt, next_hit_cnt;

logic w_en_table;
logic hit;

integer i;


always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state <= IDLE;
		flush_i <= 0;
		hit_cnt <= 0;
		for (i = 0; i < 8; i++) begin
			 l_frame[i].valid <= 0;
			 l_frame[i].dirty <= 0;
			 l_frame[i].tag <= 0;
			 l_frame[i].data1 <= 0;
			 l_frame[i].data2 <= 0;
			 r_frame[i].valid <= 0;
			 r_frame[i].dirty <= 0;
			 r_frame[i].tag <= 0;
			 r_frame[i].data1 <= 0;
			 r_frame[i].data2 <= 0;
			 lru[i] <= 0;
		end
	end else begin
		state <= next_state;
		flush_i <= next_flush_i;
		hit_cnt <= next_hit_cnt;
		if (w_en_table) 
		begin
			r_frame[daddr.idx].valid <= next_r_frame.valid;
			r_frame[daddr.idx].dirty <= next_r_frame.dirty;
			r_frame[daddr.idx].tag <= next_r_frame.tag;
			r_frame[daddr.idx].data1 <= next_r_frame.data1;
			r_frame[daddr.idx].data2 <= next_r_frame.data2;
			l_frame[daddr.idx].valid <= next_l_frame.valid;
			l_frame[daddr.idx].dirty <= next_l_frame.dirty;
			l_frame[daddr.idx].tag <= next_l_frame.tag;
			l_frame[daddr.idx].data1 <= next_l_frame.data1;
			l_frame[daddr.idx].data2 <= next_l_frame.data2;
			lru[daddr.idx] <= next_lru[daddr.idx];
		end else begin
			l_frame[daddr.idx].valid <= l_frame[daddr.idx].valid;
			l_frame[daddr.idx].dirty <= l_frame[daddr.idx].dirty;
			l_frame[daddr.idx].tag <= l_frame[daddr.idx].tag;
			l_frame[daddr.idx].data1 <= l_frame[daddr.idx].data1;
			l_frame[daddr.idx].data2 <= l_frame[daddr.idx].data2;
			r_frame[daddr.idx].valid <= r_frame[daddr.idx].valid;
			r_frame[daddr.idx].dirty <= r_frame[daddr.idx].dirty;
			r_frame[daddr.idx].tag <= r_frame[daddr.idx].tag;
			r_frame[daddr.idx].data1 <= r_frame[daddr.idx].data1;
			r_frame[daddr.idx].data2 <= r_frame[daddr.idx].data2;
			lru[daddr.idx] <= lru[daddr.idx];
		end		
	end
end



always_comb begin : NEXT_LOGIC
	next_state = state;
	next_flush_i = flush_i;
	next_hit_cnt = hit_cnt;

	casez (state) 
		IDLE_D:
		begin
			if (dcif.halt) next_state = CLEAN;
			if (~hit)
			begin
				if((lru[daddr.idx] && r_frame[daddr.idx].dirty) || (!lru[daddr.idx] && l_frame[daddr.idx].dirty))
					next_state = WB1;
				else
					next_state = LD1;
			end
		end
		LD1:
		begin 
			if (~dcf.dwait) next_state = LD2;
		end
		LD2: 
		begin 
			if (~dcf.dwait) next_state = IDLE_D;
		end
		WB1: 
		begin 
			if (~dcf.dwait) next_state = WB2;
		end
		WB2: 
		begin 
			if (~dcf.dwait) next_state = LD1;
		end
		CLEAN: 
		begin
			if (flush_i < 8)
			begin 
				if (l_frame[flush_i].dirty && r_frame[flush_i].dirty)
					next_state = FLUSH1;
				else 
				begin
					if (l_frame[flush_i].dirty || r_frame[flush_i].dirty)
						next_state = FLUSH1;
					next_flush_i = flush_i + 1        // if no flush or only one flash needed
				end
			end
		end
		FLUSH1: 
		begin
			if (~dcf.dwait) next_state = FLUSH2;
		end
		FLUSH2:  
		begin
			if (~dcf.dwait) next_state = CLEAN;
		end
		HLT_CNT: 
		begin
			if (~dcf.dwait) next_state = HALT;
		end
		//HALT:
	endcase
end



always_comb begin : OUTPUT_LOGIC
	hit = 0;
	dcif.dhit = 0;
	dcif.dmemload = 0;
	dcf.dREN = 0;
	dcf.dWEN = 0;
	dcf.daddr = 0;
	dcf.dstore = 0;

	next_l_frame.valid = l_frame[daddr.idx].valid;
	next_l_frame.dirty = l_frame[daddr.idx].dirty;
	next_l_frame.tag = l_frame[daddr.idx].tag;
	next_l_frame.data1 = l_frame[daddr.idx].data1;
	next_l_frame.data2 = l_frame[daddr.idx].data2;

	next_r_frame.valid = r_frame[daddr.idx].valid;
	next_r_frame.dirty = r_frame[daddr.idx].dirty;
	next_r_frame.tag = r_frame[daddr.idx].tag;
	next_r_frame.data1 = r_frame[daddr.idx].data1;
	next_r_frame.data2 = r_frame[daddr.idx].data2;

	next_hit_cnt = hit_cnt;

	for (i = 0; i < 8; i++) begin
		next_lru[i] = lru[i];
	end

	casez (state) 
		IDLE_D:
		begin
			if (dcif.dmemREN)
			begin
				if (daddr.tag==l_frame[daddr.idx].tag && l_frame[daddr.idx].valid)
				begin
					dcif.dhit = 1;
					dcif.dmemload = daddr.blkoff?l_frame[daddr.idx].data1:l_frame[daddr.idx].data2; 
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 1;
				end
				else if (daddr.tag==r_frame[daddr.idx].tag && r_frame[daddr.idx].valid)
				begin
					dcif.dhit = 1;
					dcif.dmemload = daddr.blkoff?r_frame[daddr.idx].data1:r_frame[daddr.idx].data2; 
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 0;
				end
				else
				begin
					hit = 0;
					next_hit_cnt = hit_cnt - 1;
				end
			end
			else if (dcif.dmemWEN)
			begin
				if (daddr.tag==l_frame[daddr.idx].tag)
				begin
					if (daddr.blkoff)
						next_l_frame.data2 = dcif.dmemstore;
					else
						next_l_frame.data1 = dcif.dmemstore;
					dcif.dhit = 1;
					next_l_frame.dirty = 1;
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 1;
				end
				else if (daddr.tag==r_frame[daddr.idx].tag)
				begin
					if (daddr.blkoff)
						next_r_frame.data2 = dcif.dmemstore;
					else
						next_r_frame.data1 = dcif.dmemstore;
					dcif.dhit = 1;
					next_r_frame.dirty = 1;
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 0;
				end
				else
				begin
					hit = 0;
					next_hit_cnt = hit_cnt - 1;
				end
			end
		end
		LD1:
		begin 
			dcf.dREN = 1;
			dcf.daddr = {daddr.tag,daddr.idx,3'b000};
			if (lru[daddr.idx])
			
		end
		LD2: 
		begin 
			
		end
		WB1: 
		begin 
			
		end
		WB2: 
		begin 
			
		end
		CLEAN: 
		begin
			
		end
		FLUSH1: 
		begin
			
		end
		FLUSH2:  
		begin
			
		end
		HLT_CNT: 
		begin
			
		end
		//HALT:
	endcase

end


endmodule