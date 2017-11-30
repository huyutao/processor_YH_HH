// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"


module dcache (
	datapath_cache_if dcif,   //top to datapath
	caches_if.dcache dcf,     //bot to memory
	input logic CLK, nRST
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;
logic hit, miss;

integer i;

word_t lk_reg, next_lk_reg;
logic lk_valid, next_lk_valid;
logic sc_state, ll_state;

assign sc_state = (dcif.datomic & dcif.dmemWEN);
assign ll_state = (dcif.datomic & dcif.dmemREN);


assign next_lk_reg = ll_state?dcif.dmemaddr:lk_reg;


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

Dcache_t l_frame[7:0], r_frame[7:0],next_l_frame[7:0],next_r_frame[7:0];
Dstate_t state,next_state;
logic lru[7:0], next_lru[7:0];
logic [4:0] flush_i, next_flush_i;
logic clean_l_dirty, clean_r_dirty, next_l_valid, next_r_valid;



always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state    <= IDLE_D;
		flush_i  <= 0;
		lk_reg   <= 0;
		lk_valid <= 0;
		for (i = 0; i < 8; i++) begin
			l_frame[i].valid <= 0;
			l_frame[i].dirty <= 0;
			l_frame[i].tag   <= 0;
			l_frame[i].data1 <= 0;
			l_frame[i].data2 <= 0;
			r_frame[i].valid <= 0;
			r_frame[i].dirty <= 0;
			r_frame[i].tag   <= 0;
			r_frame[i].data1 <= 0;
			r_frame[i].data2 <= 0;
			lru[i]           <= 0;
		end
	 end else begin
		state 		<= next_state;
		flush_i 	<= next_flush_i;
		lk_reg      <= next_lk_reg;
		lk_valid    <= next_lk_valid;
		for (i = 0; i < 8; i++) begin
			l_frame[i].valid <= next_l_frame[i].valid;
			l_frame[i].dirty <= next_l_frame[i].dirty;
			l_frame[i].tag   <= next_l_frame[i].tag;
			l_frame[i].data1 <= next_l_frame[i].data1;
			l_frame[i].data2 <= next_l_frame[i].data2;
			r_frame[i].valid <= next_r_frame[i].valid;
			r_frame[i].dirty <= next_r_frame[i].dirty;
			r_frame[i].tag   <= next_r_frame[i].tag;
			r_frame[i].data1 <= next_r_frame[i].data1;
			r_frame[i].data2 <= next_r_frame[i].data2;
			lru[i] 		  	 <= next_lru[i];
		end
	end
end



always_comb begin : NEXT_LOGIC
	next_state = state;
	next_flush_i = flush_i;
	casez (state) 
		IDLE_D:
		begin
			if (dcf.ccwait)
			begin
				next_state = SNOOP_DIAOSI;
			end
			else if (dcif.halt) 
				next_state = CLEAN;
			else if (miss == 1)
			begin
				if((lru[daddr.idx] && r_frame[daddr.idx].dirty) || (!lru[daddr.idx] && l_frame[daddr.idx].dirty))
					next_state = WB1;
				else
					next_state = LDSNOOP;
				if ((!dcif.dmemREN) & (!dcif.dmemWEN))
					next_state = IDLE_D;
			end
			else if (dcif.dmemWEN & ~(sc_state & ( ((lk_reg != dcif.dmemaddr)|(lk_valid==0)) ) ))  // if real write, snoop other
			begin
				if (daddr.tag==l_frame[daddr.idx].tag && l_frame[daddr.idx].dirty == 0 && l_frame[daddr.idx].valid == 1)
				begin
					next_state = WENSNOOP;
				end
				else if (daddr.tag==r_frame[daddr.idx].tag && r_frame[daddr.idx].dirty == 0 && r_frame[daddr.idx].valid == 1)
				begin
					next_state = WENSNOOP;
				end
			end
		end
		WENSNOOP:
		begin
			if (~dcf.ccwait & dcf.ccinv)
			begin
				next_state = IDLE_D;
			end
		end
		SNOOP_DIAOSI:
		begin
			next_state = IDLE_D;
			if (snoop_addr.tag==l_frame[snoop_addr.idx].tag && l_frame[snoop_addr.idx].valid)
			begin
				if (l_frame[snoop_addr.idx].dirty)
				begin
					next_state = CCWB1;
				end
			end
			else if (snoop_addr.tag==r_frame[snoop_addr.idx].tag && r_frame[snoop_addr.idx].valid)
			begin
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
		LDSNOOP:
		begin
			if (dcf.ccwait)
			begin
				next_state = IDLE_D;
			end
			else
			begin
				if (dcf.ccinv)  // arbitration success
				begin
					if (dcf.dwait == 0)  //data valid
						next_state = LD2;
					else
						next_state = LD1;
				end

			end
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
			if (dcf.dwait == 0) next_state = LDSNOOP;
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
				next_state = HALT_D;
			end
			if (dcf.ccwait)
			begin
				next_state = SNOOP_DIAOSI;
			end
		end
		FLUSH1: 
		begin
			if (dcf.dwait == 0) next_state = FLUSH2;
			if (dcf.ccwait)
			begin
				next_state = SNOOP_DIAOSI;
			end
		end
		FLUSH2:  
		begin
			if (dcf.dwait == 0)
			begin
				next_state = CLEAN;
			end
			if (dcf.ccwait)
			begin
				next_state = SNOOP_DIAOSI;
			end
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
	next_lk_valid = ((lk_reg != next_lk_reg) | lk_valid | ll_state);

	for (j = 0;  j< 8; j++) begin
		next_l_frame[j].valid = l_frame[j].valid;
		next_l_frame[j].dirty = l_frame[j].dirty;
		next_l_frame[j].tag   = l_frame[j].tag;
		next_l_frame[j].data1 = l_frame[j].data1;
		next_l_frame[j].data2 = l_frame[j].data2;
		next_r_frame[j].valid = r_frame[j].valid;
		next_r_frame[j].dirty = r_frame[j].dirty;
		next_r_frame[j].tag   = r_frame[j].tag;
		next_r_frame[j].data1 = r_frame[j].data1;
		next_r_frame[j].data2 = r_frame[j].data2;
		next_lru[j]           = lru[j];
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
					next_lru[daddr.idx] = 1;
				end
				else if (daddr.tag==r_frame[daddr.idx].tag && r_frame[daddr.idx].valid)
				begin
					hit = 1;
					dcif.dmemload = daddr.blkoff?r_frame[daddr.idx].data2:r_frame[daddr.idx].data1; 
					next_lru[daddr.idx] = 0;
				end
				else
				begin
					miss = 1;
					hit = 0;
				end
			end
			else if (dcif.dmemWEN)
			begin
				if (sc_state && ( ((lk_reg != dcif.dmemaddr)|(lk_valid==0)) ) )  //situation that don't write 1,lk reg changed, 2, lk_valid = 0
				begin
					if (daddr.tag==l_frame[daddr.idx].tag)
					begin
						hit = 1;
					end
					else if (daddr.tag==r_frame[daddr.idx].tag)
					begin
						hit = 1;
					end
					else
					begin
						miss = 1;
						hit = 0;
					end
				end
				else
					begin
					if (daddr.tag==l_frame[daddr.idx].tag && l_frame[daddr.idx].valid == 1)
					begin
						if(l_frame[daddr.idx].dirty == 1)
						begin
							hit = 1;
							next_l_frame[daddr.idx].dirty = 1;
							next_lru[daddr.idx] = 1;
							if (daddr.blkoff)
								next_l_frame[daddr.idx].data2 = dcif.dmemstore;
							else
								next_l_frame[daddr.idx].data1 = dcif.dmemstore;
							if (lk_reg == dcif.dmemaddr)  //if write, SC or SW invalid
							begin
								next_lk_valid = 0;
							end
						end
						else
						begin   // go to snoop
							dcf.cctrans = 1;
							dcf.daddr = dcif.dmemaddr;
						end
					end
					else if (daddr.tag==r_frame[daddr.idx].tag && r_frame[daddr.idx].valid == 1)
					begin
						if(r_frame[daddr.idx].dirty == 1)
						begin
							hit = 1;
							next_r_frame[daddr.idx].dirty = 1;
							next_lru[daddr.idx] = 0;
							if (daddr.blkoff)
								next_r_frame[daddr.idx].data2 = dcif.dmemstore;
							else
								next_r_frame[daddr.idx].data1 = dcif.dmemstore;
							if (lk_reg == dcif.dmemaddr)  //if write, SC or SW invalid
							begin
								next_lk_valid = 0;
							end
						end
						else
						begin
							dcf.cctrans = 1;
							dcf.daddr = dcif.dmemaddr;
						end
					end
					else
					begin
						miss = 1;
						hit = 0;
					end
				end
			end
		end
		WENSNOOP:
		begin
			dcf.ccwrite = 1;
			dcf.cctrans = 1;
			dcf.daddr = dcif.dmemaddr;
			if (~dcf.ccwait & dcf.ccinv)
			begin
				if (daddr.tag==l_frame[daddr.idx].tag)
				begin
					hit = 1;
					next_l_frame[daddr.idx].dirty = 1;
					next_lru[daddr.idx] = 1;
					if (daddr.blkoff)
						next_l_frame[daddr.idx].data2 = dcif.dmemstore;
					else
						next_l_frame[daddr.idx].data1 = dcif.dmemstore;

				end
				else if (daddr.tag==r_frame[daddr.idx].tag)
				begin
					hit = 1;
					next_r_frame[daddr.idx].dirty = 1;
					next_lru[daddr.idx] = 0;
					if (daddr.blkoff)
						next_r_frame[daddr.idx].data2 = dcif.dmemstore;
					else
						next_r_frame[daddr.idx].data1 = dcif.dmemstore;
				end
				else
				begin
					miss = 1;
					hit = 0;
				end
				if (lk_reg == dcif.dmemaddr)  //if write, SC or SW invalid
				begin
					next_lk_valid = 0;
				end
			end
		end
		SNOOP_DIAOSI:
		begin 
			dcf.cctrans = 1;

			if (snoop_addr.tag==l_frame[snoop_addr.idx].tag && l_frame[snoop_addr.idx].valid)
			begin
				next_l_frame[snoop_addr.idx].valid = dcf.ccinv?0:next_l_frame[snoop_addr.idx].valid;
				if (l_frame[snoop_addr.idx].dirty)
				begin
					dcf.ccwrite = 1;
				end
			end
			else if (snoop_addr.tag==r_frame[snoop_addr.idx].tag && r_frame[snoop_addr.idx].valid)
			begin
				next_r_frame[snoop_addr.idx].valid = dcf.ccinv?0:next_r_frame[snoop_addr.idx].valid;
				if (r_frame[snoop_addr.idx].dirty)
				begin
					dcf.ccwrite = 1;
				end
			end

			if ((snoop_addr==lk_reg) && dcf.ccinv)
			begin
				next_lk_valid = 0;
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
				dcf.dstore = l_frame[snoop_addr.idx].data2;
				dcf.daddr = {l_frame[snoop_addr.idx].tag,snoop_addr.idx,3'b100};
				next_lru[snoop_addr.idx] = 1;
				next_l_frame[snoop_addr.idx].dirty = 0;
			end
			else
			begin
				dcf.dstore = r_frame[snoop_addr.idx].data2;
				dcf.daddr = {r_frame[snoop_addr.idx].tag,snoop_addr.idx,3'b100};
				next_lru[snoop_addr.idx] = 0;
				next_r_frame[snoop_addr.idx].dirty = 0;
			end
		end
		LDSNOOP:
		begin
			dcf.cctrans = 1;
			dcf.dREN = 1;
			dcf.daddr = {daddr.tag,daddr.idx,3'b000};
			if (lru[daddr.idx] == 0) begin
				next_l_frame[daddr.idx].data1   = dcf.dload;
				next_l_frame[daddr.idx].valid   = 0;
			end
			else begin
				next_r_frame[daddr.idx].data1   = dcf.dload;
				next_r_frame[daddr.idx].valid   = 0;
			end
		end
		LD1:
		begin 
			dcf.dREN = 1;
			dcf.daddr = {daddr.tag,daddr.idx,3'b000};
			if (lru[daddr.idx] == 0) begin
				next_l_frame[daddr.idx].data1   = dcf.dload;
				next_l_frame[daddr.idx].valid   = 0;
			end
			else begin
				next_r_frame[daddr.idx].data1   = dcf.dload;
				next_r_frame[daddr.idx].valid   = 0;
			end
			if (dcf.daddr==lk_reg)
			begin
				next_lk_valid = 1;
			end
		end
		LD2: 
		begin 
			dcf.dREN = 1;
			dcf.daddr = {daddr.tag,daddr.idx,3'b100};
			if (lru[daddr.idx] == 0) begin
				next_l_frame[daddr.idx].data2 = dcf.dload;
				next_l_frame[daddr.idx].tag   = daddr.tag;
				next_l_frame[daddr.idx].valid = 1; 
			end
			else begin
				next_r_frame[daddr.idx].data2 = dcf.dload;
				next_r_frame[daddr.idx].tag   = daddr.tag;
				next_r_frame[daddr.idx].valid = 1;
			end
			if (dcf.daddr==lk_reg)
			begin
				next_lk_valid = 1;
			end
		end
		WB1: 
		begin 
			dcf.ccwrite = 1;
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
			dcf.ccwrite = 1;
			dcf.dWEN = 1;
			if (lru[daddr.idx] == 0)
			begin
				dcf.dstore = l_frame[daddr.idx].data2;
				dcf.daddr = {l_frame[daddr.idx].tag,daddr.idx,3'b100};
				next_l_frame[daddr.idx].dirty = 0;
			end
			else
			begin
				dcf.dstore = r_frame[daddr.idx].data2;
				dcf.daddr = {r_frame[daddr.idx].tag,daddr.idx,3'b100};
				next_r_frame[daddr.idx].dirty = 0;
			end
		end
		CLEAN:
		begin
			//dcf.cctrans = 1;
		end
		FLUSH1: 
		begin
			dcf.ccwrite = 1;
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
			//if (dcf.ccwait)
				//dcf.cctrans = 1;
		end
		FLUSH2:  
		begin
			if (dcf.dwait == 0)
			begin
				if (l_frame[flush_i].dirty)
				begin
					next_l_frame[flush_i].dirty = 0;
				end
				else if (r_frame[flush_i].dirty)
				begin
					next_r_frame[flush_i].dirty = 0;
				end
			end

			dcf.ccwrite = 1;
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
			//if (dcf.ccwait)
				//dcf.cctrans = 1;
		end
		HALT_D:
		begin
			dcif.flushed = 1;
			if (dcf.ccwait)
				dcf.cctrans = 1;
		end
	endcase

	if (sc_state)
	begin
		if ((lk_reg != dcif.dmemaddr)|(lk_valid==0))  //situation that don't write 1,lk reg changed, 2, lk_valid = 0
		begin
			dcif.dmemload = 0;
		end
		else
		begin
			dcif.dmemload = 1;
		end
	end
end


endmodule