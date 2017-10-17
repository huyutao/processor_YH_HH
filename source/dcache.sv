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



Dcache_t l_frame[7:0], r_frame[7:0],next_l_frame,next_r_frame;
Dstate_t state,next_state;
logic lru[7:0];
logic [4:0] flush_i, next_flush_i;
word_t hit_cnt, next_hit_cnt;

logic w_en_table;
logic index [2:0];

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
		if (w_en_table) begin
			if (lru[index]) begin
				l_frame[index].valid <= next_l_frame.valid;
				l_frame[index].dirty <= next_l_frame.dirty;
				l_frame[index].tag <= next_l_frame.tag;
				l_frame[index].data1 <= next_l_frame.data1;
				l_frame[index].data2 <= next_l_frame.data2;
				r_frame[index].valid <= r_frame[index].valid;
				r_frame[index].dirty <= r_frame[index].dirty;
				r_frame[index].tag <= r_frame[index].tag;
				r_frame[index].data1 <= r_frame[index].data1;
				r_frame[index].data2 <= r_frame[index].data2;
				lru[index] <= 0;
			end
			else begin
				l_frame[index].valid <= l_frame[index].valid;
				l_frame[index].dirty <= l_frame[index].dirty;
				l_frame[index].tag <= l_frame[index].tag;
				l_frame[index].data1 <= l_frame[index].data1;
				l_frame[index].data2 <= l_frame[index].data2;
				r_frame[index].valid <= next_r_frame.valid;
				r_frame[index].dirty <= next_r_frame.dirty;
				r_frame[index].tag <= next_r_frame.tag;
				r_frame[index].data1 <= next_r_frame.data1;
				r_frame[index].data2 <= next_r_frame.data2;
				lru[index] <= 1;
			end
		end else begin
			l_frame[index].valid <= l_frame[index].valid;
			l_frame[index].dirty <= l_frame[index].dirty;
			l_frame[index].tag <= l_frame[index].tag;
			l_frame[index].data1 <= l_frame[index].data1;
			l_frame[index].data2 <= l_frame[index].data2;
			r_frame[index].valid <= r_frame[index].valid;
			r_frame[index].dirty <= r_frame[index].dirty;
			r_frame[index].tag <= r_frame[index].tag;
			r_frame[index].data1 <= r_frame[index].data1;
			r_frame[index].data2 <= r_frame[index].data2;
			lru[index] <= lru[index];
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
			if (hit) next_state = IDLE_CNT;
			else if (!hit)
			begin
				if(lru[index])

			end

		end
		IDLE_CNT: 
		LD1:
		LD2: 
		WB1: 
		WB2: 
		CLEAN: 
		FLUSH1: 
		FLUSH2:  
		HLT_CNT: 
		HALT:

		IDLE_I:
		begin

		if (!hit)
			next_state = LD;
		end
		LD:
		begin
			icf.iREN = 1;
			next_frame.tag = iaddr.tag;
			next_frame.data = icf.iload;
			next_frame.valid = 1;
			if (!icf.iwait)
				next_state = IDLE_I;
		end
	endcase

end

