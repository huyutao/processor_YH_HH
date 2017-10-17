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



Dcache_t l_frame[7:0], r_frame[7:0],l_frame_next,r_frame_next;
Dstate_t state,next_state;
logic lru[7:0];

logic w_en_table;
logic index [2:0];

integer i;


always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state <= IDLE;
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
		end
	end else begin
		state <= next_state;
		if (w_en_table) begin
			if (lru) begin
				l_frame[index].valid <= l_frame_next.valid;
				l_frame[index].dirty <= l_frame_next.dirty;
				l_frame[index].tag <= l_frame_next.tag;
				l_frame[index].data1 <= l_frame_next.data1;
				l_frame[index].data2 <= l_frame_next.data2;
				r_frame[index].valid <= r_frame[index].valid;
				r_frame[index].dirty <= r_frame[index].dirty;
				r_frame[index].tag <= r_frame[index].tag;
				r_frame[index].data1 <= r_frame[index].data1;
				r_frame[index].data2 <= r_frame[index].data2;
			end
			else begin
				l_frame[index].valid <= l_frame[index].valid;
				l_frame[index].dirty <= l_frame[index].dirty;
				l_frame[index].tag <= l_frame[index].tag;
				l_frame[index].data1 <= l_frame[index].data1;
				l_frame[index].data2 <= l_frame[index].data2;
				r_frame[index].valid <= r_frame_next.valid;
				r_frame[index].dirty <= r_frame_next.dirty;
				r_frame[index].tag <= r_frame_next.tag;
				r_frame[index].data1 <= r_frame_next.data1;
				r_frame[index].data2 <= r_frame_next.data2;
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
		end		
	end
end




