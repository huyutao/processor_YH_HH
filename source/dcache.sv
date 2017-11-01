// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"


module dcache (

	datapath_cache_if dcif,
	caches_if.dcache dcf,
	input logic CLK, nRST
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;
logic hit, miss;

integer i;

dcachef_t daddr, snoop_addr;
assign daddr.tag = dcif.dmemaddr[31:6];
assign daddr.idx = dcif.dmemaddr[5:3];
assign daddr.blkoff = dcif.dmemaddr[2];
assign daddr.bytoff =  dcif.dmemaddr[1:0];
assign snoop_addr.tag = dcf.ccsnoopaddr[31:6];
assign snoop_addr.idx = dcf.ccsnoopaddr[5:3];
assign snoop_addr.blkoff = dcf.ccsnoopaddr[2];
assign snoop_addr.bytoff = dcf.ccsnoopaddr[1:0];
assign dcif.dhit = hit;

Dcache_t l_frame[7:0], r_frame[7:0],next_l_frame,next_r_frame;
Dstate_t state,next_state;
logic lru[7:0], next_lru[7:0];
logic [4:0] flush_i, next_flush_i;
word_t hit_cnt, next_hit_cnt;
logic clean_l_dirty, clean_r_dirty, next_l_valid, next_r_valid;



always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state <= IDLE_D;
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
	end else if (state == FLUSH2) begin
		state <= next_state;
		l_frame[flush_i].dirty <= clean_l_dirty;
		r_frame[flush_i].dirty <= clean_r_dirty;
	end else if (state == SNOOP_DIAOSI) begin
		state <= next_state;
		l_frame[snoop_addr.idx].valid <= next_l_valid;
		r_frame[snoop_addr.idx].valid <= next_r_valid;
	end else if (state == CCWB2) begin
		state <= next_state;
		r_frame[snoop_addr.idx].valid <= next_r_frame.valid;
		r_frame[snoop_addr.idx].dirty <= next_r_frame.dirty;
		r_frame[snoop_addr.idx].tag <= next_r_frame.tag;
		r_frame[snoop_addr.idx].data1 <= next_r_frame.data1;
		r_frame[snoop_addr.idx].data2 <= next_r_frame.data2;
		l_frame[snoop_addr.idx].valid <= next_l_frame.valid;
		l_frame[snoop_addr.idx].dirty <= next_l_frame.dirty;
		l_frame[snoop_addr.idx].tag <= next_l_frame.tag;
		l_frame[snoop_addr.idx].data1 <= next_l_frame.data1;
		l_frame[snoop_addr.idx].data2 <= next_l_frame.data2;
		lru[snoop_addr.idx] <= next_lru[snoop_addr.idx];
	end else begin
		state <= next_state;
		flush_i <= next_flush_i;
		hit_cnt <= next_hit_cnt;
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
	end
end



always_comb begin : NEXT_LOGIC
	next_state = state;
	next_flush_i = flush_i;
	clean_l_dirty = 0;
	clean_r_dirty = 0;
	casez (state) 
		IDLE_D:
		begin
			if (dcf.ccwait)
			begin
				next_state = SNOOP_DIAOSI;
			end
			if (dcif.halt) next_state = CLEAN;
			if (miss == 1)
			begin
				if((lru[daddr.idx] && r_frame[daddr.idx].dirty) || (!lru[daddr.idx] && l_frame[daddr.idx].dirty))
					next_state = WB1;
				else
					next_state = LD1;
				if ((!dcif.dmemREN) & (!dcif.dmemWEN))
					next_state = IDLE_D;
			end
		end
		SNOOP_DIAOSI:
		begin
			next_state = IDLE_D;
			if (snoop_addr.tag==l_frame[snoop_addr.idx].tag && l_frame[snoop_addr.idx].valid)
			begin
				next_l_valid = ~dcf.ccinv;
				if (l_frame[snoop_addr.idx].dirty)
				begin
					next_state = CCWB1;
				end
			end
			else if (snoop_addr.tag==r_frame[snoop_addr.idx].tag && r_frame[snoop_addr.idx].valid)
			begin
				next_r_valid = ~dcf.ccinv;
				if (r_frame[snoop_addr.idx].dirty)
				begin
					next_state = CCWB1;
				end
			end
		end
		CCWB1:
		begin
			if (dcf.dwait == 0) next_state = CCWB2;
		end
		CCWB2:
		begin
			if (dcf.dwait == 0) next_state = IDLE_D;
		end
		LD1:
		begin 
			if (dcf.dwait == 0) next_state = LD2;
		end
		LD2: 
		begin 
			if (dcf.dwait == 0) next_state = IDLE_D;
		end
		WB1: 
		begin 
			if (dcf.dwait == 0) next_state = WB2;
		end
		WB2: 
		begin 
			if (dcf.dwait == 0) next_state = LD1;
		end
		CLEAN: 
		begin
			if (flush_i < 8)
			begin 
				if (l_frame[flush_i].dirty || r_frame[flush_i].dirty)
				begin
					next_state = FLUSH1;
				end
				else 
				begin
					next_flush_i = flush_i + 1; 
				end
			end else begin
				next_state = HLT_CNT;
			end
		end
		FLUSH1: 
		begin
			if (dcf.dwait == 0) next_state = FLUSH2;
		end
		FLUSH2:  
		begin
			clean_r_dirty = r_frame[flush_i].dirty;
			clean_l_dirty = l_frame[flush_i].dirty;

			if (dcf.dwait == 0)
			begin
				next_state = CLEAN;
				if (l_frame[flush_i].dirty)
				begin
					clean_l_dirty = 0;
				end
				else if (r_frame[flush_i].dirty)
				begin
					clean_r_dirty = 0;
				end
			end
		end
		HLT_CNT: 
		begin
			if (dcf.dwait == 0) next_state = HALT_D;
		end
	endcase
end


integer j;
always_comb begin : OUTPUT_LOGIC
	hit = 0;
	miss = 0;
	dcif.dmemload = 0;
	dcf.dREN = 0;
	dcf.dWEN = 0;
	dcf.daddr = 0;
	dcf.dstore = 0;
	dcif.flushed = 0;
	dcf.cctrans = 0;
	dcf.ccwrite = 0;

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

	for (j = 0; j < 8; j++) begin
		next_lru[j] = lru[j];
	end

	casez (state) 
		IDLE_D:
		begin
			if (dcif.dmemREN)
			begin
				if (daddr.tag==l_frame[daddr.idx].tag && l_frame[daddr.idx].valid)
				begin
					hit = 1;
					dcif.dmemload = daddr.blkoff?l_frame[daddr.idx].data2:l_frame[daddr.idx].data1; 
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 1;
				end
				else if (daddr.tag==r_frame[daddr.idx].tag && r_frame[daddr.idx].valid)
				begin
					hit = 1;
					dcif.dmemload = daddr.blkoff?r_frame[daddr.idx].data2:r_frame[daddr.idx].data1; 
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 0;
				end
				else
				begin
					miss = 1;
					hit = 0;
					next_hit_cnt = hit_cnt - 1;
				end
			end
			else if (dcif.dmemWEN)
			begin
				if (daddr.tag==l_frame[daddr.idx].tag)
				begin
					hit = 1;
					next_l_frame.dirty = 1;
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 1;
					if (daddr.blkoff)
						next_l_frame.data2 = dcif.dmemstore;
					else
						next_l_frame.data1 = dcif.dmemstore;
					if(l_frame[daddr.idx].dirty == 0)
					begin
						dcf.cctrans = 1;
						dcf.ccwrite = 1;
						dcf.daddr = dcif.dmemaddr;
					end

				end
				else if (daddr.tag==r_frame[daddr.idx].tag)
				begin
					hit = 1;
					next_r_frame.dirty = 1;
					next_hit_cnt = hit_cnt + 1;
					next_lru[daddr.idx] = 0;
					if (daddr.blkoff)
						next_r_frame.data2 = dcif.dmemstore;
					else
						next_r_frame.data1 = dcif.dmemstore;
					if(r_frame[daddr.idx].dirty == 0)
					begin
						dcf.cctrans = 1;
						dcf.ccwrite = 1;
						dcf.daddr = dcif.dmemaddr;
					end
				end
				else
				begin
					miss = 1;
					hit = 0;
					next_hit_cnt = hit_cnt - 1;
				end
			end
			if (dcif.halt)
				next_hit_cnt = hit_cnt;
		end
		SNOOP_DIAOSI:
		begin 
			dcf.cctrans = 1;
			if (snoop_addr.tag==l_frame[snoop_addr.idx].tag && l_frame[snoop_addr.idx].valid && l_frame[snoop_addr.idx].dirty)
			begin
				dcf.ccwrite = 1;
			end
			else if (snoop_addr.tag==r_frame[snoop_addr.idx].tag && r_frame[snoop_addr.idx].valid && r_frame[snoop_addr.idx].dirty)
			begin
				dcf.ccwrite = 1;
			end
		end
		CCWB1:
		begin
			dcf.dWEN = 1;
			if (snoop_addr.tag==l_frame[snoop_addr.idx].tag)
			begin
				dcf.dstore = l_frame[snoop_addr.idx].data1;
				dcf.daddr = {l_frame[snoop_addr.idx].tag,snoop_addr.idx,3'b000};
			end
			else
			begin
				dcf.dstore = r_frame[snoop_addr.idx].data1;
				dcf.daddr = {r_frame[snoop_addr.idx].tag,snoop_addr.idx,3'b000};
			end
		end
		CCWB2:
		begin
			dcf.dWEN = 1;
			if (snoop_addr.tag==l_frame[snoop_addr.idx].tag)
			begin
				dcf.dstore = l_frame[snoop_addr.idx].data1;
				dcf.daddr = {l_frame[snoop_addr.idx].tag,snoop_addr.idx,3'b100};
				next_lru[snoop_addr.idx] = 1;

				next_l_frame.valid = 0;
				next_l_frame.dirty = 0;
				next_l_frame.tag = l_frame[snoop_addr.idx].tag;
				next_l_frame.data1 = l_frame[snoop_addr.idx].data1;
				next_l_frame.data2 = l_frame[snoop_addr.idx].data2;

				next_r_frame.valid = r_frame[snoop_addr.idx].valid;
				next_r_frame.dirty = r_frame[snoop_addr.idx].dirty;
				next_r_frame.tag = r_frame[snoop_addr.idx].tag;
				next_r_frame.data1 = r_frame[snoop_addr.idx].data1;
				next_r_frame.data2 = r_frame[snoop_addr.idx].data2;
			end
			else
			begin
				dcf.dstore = r_frame[snoop_addr.idx].data1;
				dcf.daddr = {r_frame[snoop_addr.idx].tag,snoop_addr.idx,3'b100};
				next_lru[snoop_addr.idx] = 0;
				
				next_l_frame.valid = l_frame[snoop_addr.idx].valid;
				next_l_frame.dirty = l_frame[snoop_addr.idx].dirty;
				next_l_frame.tag = l_frame[snoop_addr.idx].tag;
				next_l_frame.data1 = l_frame[snoop_addr.idx].data1;
				next_l_frame.data2 = l_frame[snoop_addr.idx].data2;

				next_r_frame.valid = 0;
				next_r_frame.dirty = 0;
				next_r_frame.tag = r_frame[snoop_addr.idx].tag;
				next_r_frame.data1 = r_frame[snoop_addr.idx].data1;
				next_r_frame.data2 = r_frame[snoop_addr.idx].data2;
			end
		end
		LD1:
		begin 
			dcf.cctrans = 1;
			dcf.dREN = 1;
			dcf.daddr = {daddr.tag,daddr.idx,3'b000};
			if (lru[daddr.idx] == 0) begin
				next_l_frame.data1 = dcf.dload;
				next_l_frame.tag   = daddr.tag;
				next_l_frame.valid   = 1;
			end
			else begin
				next_r_frame.data1 = dcf.dload;
				next_r_frame.tag   = daddr.tag;
				next_r_frame.valid   = 1;
			end
		end
		LD2: 
		begin 
			dcf.dREN = 1;
			dcf.daddr = {daddr.tag,daddr.idx,3'b100};
			if (lru[daddr.idx] == 0) begin
				next_l_frame.data2 = dcf.dload;
				next_l_frame.tag   = daddr.tag;
				next_l_frame.valid = 1; 
			end
			else begin
				next_r_frame.data2 = dcf.dload;
				next_r_frame.tag   = daddr.tag;
				next_r_frame.valid = 1;
			end
		end
		WB1: 
		begin 
			dcf.dWEN = 1;
			if (lru[daddr.idx] == 0)
			begin
				dcf.dstore = l_frame[daddr.idx].data1;
				dcf.daddr = {l_frame[daddr.idx].tag,daddr.idx,3'b000};
			end
			else
			begin
				dcf.dstore = r_frame[daddr.idx].data1;
				dcf.daddr = {r_frame[daddr.idx].tag,daddr.idx,3'b000};
			end
		end
		WB2: 
		begin 
			dcf.dWEN = 1;
			if (lru[daddr.idx] == 0)
			begin
				dcf.dstore = l_frame[daddr.idx].data2;
				dcf.daddr = {l_frame[daddr.idx].tag,daddr.idx,3'b100};
			end
			else
			begin
				dcf.dstore = r_frame[daddr.idx].data2;
				dcf.daddr = {r_frame[daddr.idx].tag,daddr.idx,3'b100};
			end
		end
		FLUSH1: 
		begin
			dcf.dWEN = 1;
			if (l_frame[flush_i].dirty)
			begin
				dcf.daddr = {l_frame[flush_i].tag,flush_i[2:0],3'b000};
				dcf.dstore = l_frame[flush_i].data1;
			end
			else if (r_frame[flush_i].dirty)
			begin
				dcf.daddr = {r_frame[flush_i].tag,flush_i[2:0],3'b000};
				dcf.dstore = r_frame[flush_i].data1;
			end
		end
		FLUSH2:  
		begin
			dcf.dWEN = 1;
			if (l_frame[flush_i].dirty)
			begin
				dcf.daddr = {l_frame[flush_i].tag,flush_i[2:0],3'b100};
				dcf.dstore = l_frame[flush_i].data2;
			end
			else if (r_frame[flush_i].dirty)
			begin
				dcf.daddr = {r_frame[flush_i].tag,flush_i[2:0],3'b100};
				dcf.dstore = r_frame[flush_i].data2;
			end
		end
		HLT_CNT: 
		begin
			dcf.dWEN = 1;
			dcf.daddr = 32'h00003100;
			dcf.dstore = hit_cnt;
		end
		HALT_D:
		begin
			dcif.flushed = 1;
		end
	endcase

end


endmodule