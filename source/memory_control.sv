// interfaces
`include "cache_control_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"


module memory_control (
  input logic CLK, nRST,
	cache_control_if ccif

	/*
	icaches
	in iwait, iload
	out iren, iaddr

	dcaches
	in dwait, dload, 
	incc ccinv, ccsnoper
	out dren, dwen, dstore, daddr
	outcc ccwrite, cctrans

	ram 
	in ramstore, ramaddr, ramWEN, ramREN
	out ramload, ramstate
	*/
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;
// number of cpus for cc
parameter CPUS = 2;
Bus_control_state_t state, next_state;

always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state <= IDLE_B_DIAOSI;
	end else begin
		state <= next_state;
	end
end


always_comb begin : NEXT_LOGIC
	next_state = state;
	casez (state) 
		IDLE_B_DIAOSI:
		begin
			if (ccif.dWEN[0] | ccif.dWEN[1])
			begin
				next_state = BUSWB1;
			end 
			else if (ccif.cctrans[0])
			begin
				next_state = SNOOPING1_DIAOSI;
			end 
			else if (ccif.cctrans[1])
			begin 
				next_state = SNOOPING2_DIAOSI;
			end
			else if (ccif.iREN[0] || ccif.iREN[1])
			begin 
				next_state = ICACHE_DIAOSI;
			end
		end
		BUSWB1:
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = BUSWB2;
			end
		end
		BUSWB2:
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end 
		end
		ICACHE_DIAOSI:
		begin
			if (ccif.dWEN[0] | ccif.dWEN[1])
			begin
				next_state = BUSWB1;
			end 
			else if (ccif.cctrans[0])
			begin
				next_state = SNOOPING1_DIAOSI;
			end 
			else if (ccif.cctrans[1])
			begin 
				next_state = SNOOPING2_DIAOSI;
			end  // in icache might need go back to data acquire

			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end
		end
		SNOOPING1_DIAOSI:
		begin 
			if (ccif.cctrans[1])
			begin 
				if (ccif.dREN[0] == 0)
				begin
					next_state = IDLE_B_DIAOSI;
				end
				else if (ccif.ccwrite[1])
				begin 
					next_state = C1CACHE1_DIAOSI;
				end
				else
				begin 
					next_state = C1LD1_DIAOSI;
				end
			end
		end
		C1LD1_DIAOSI: 
		begin 
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C1LD2_DIAOSI;
			end
		end
		C1LD2_DIAOSI: 
		begin 
			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end
		end
		C1CACHE1_DIAOSI: 
		begin 
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C1CACHE2_DIAOSI;
			end
		end
		C1CACHE2_DIAOSI: 
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end
		end
		SNOOPING2_DIAOSI: 
		begin
			if (ccif.cctrans[0])
			begin 
				if (ccif.dREN[1] == 0)
				begin
					next_state = IDLE_B_DIAOSI;
				end
				else if (ccif.ccwrite[0])
				begin 
					next_state = C2CACHE1_DIAOSI;
				end
				else
				begin 
					next_state = C2LD1_DIAOSI;
				end
			end
		end
		C2LD1_DIAOSI:  
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C2LD2_DIAOSI;
			end
		end
		C2LD2_DIAOSI: 
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end
		end
		C2CACHE1_DIAOSI: 
		begin 
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C2CACHE2_DIAOSI;
			end
		end
		C2CACHE2_DIAOSI: 
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end
		end
	endcase
end

always_comb begin : OUTPUT_LOGIC
	ccif.iload[0] = 0;
	ccif.iwait[0] = 1;
	ccif.dwait[0] = 1;
	ccif.dload[0] = 0;
	ccif.ccwait[0] = 0;
	ccif.ccinv[0] = ccif.ccwrite[1];
	ccif.ccsnoopaddr[0] = 0;

	ccif.iload[1] = 0;
	ccif.iwait[1] = 1;
	ccif.dwait[1] = 1;
	ccif.dload[1] = 0;
	ccif.ccwait[1] = 0;
	ccif.ccinv[1] = ccif.ccwrite[0];
	ccif.ccsnoopaddr[1] = 0;

	ccif.ramstore = 0;
	ccif.ramaddr = 0;
	ccif.ramWEN = 0;
	ccif.ramREN = 0;

	casez (state) 
		IDLE_B_DIAOSI:
		begin
			//
		end
		BUSWB1:
		begin
			if (ccif.dWEN[0])
			begin
				ccif.ccsnoopaddr[1] = ccif.daddr[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramWEN = 1;
				ccif.ramstore = ccif.dstore[0];
				ccif.dwait[0] = (ccif.ramstate != ACCESS);
				//ccif.ccwait[1] = 1;
			end
			else if (ccif.dWEN[1])
			begin
				ccif.ccsnoopaddr[0] = ccif.daddr[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramWEN = 1;
				ccif.ramstore = ccif.dstore[1];
				ccif.dwait[1] = (ccif.ramstate != ACCESS);
				//ccif.ccwait[0] = 1;
			end
		end
		BUSWB2:
		begin
			if (ccif.dWEN[0])
			begin
				ccif.ccsnoopaddr[1] = ccif.daddr[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramWEN = 1;
				ccif.ramstore = ccif.dstore[0];
				ccif.dwait[0] = (ccif.ramstate != ACCESS);
				//ccif.ccwait[1] = 1;
			end
			else if (ccif.dWEN[1])
			begin
				ccif.ccsnoopaddr[0] = ccif.daddr[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramWEN = 1;
				ccif.ramstore = ccif.dstore[1];
				ccif.dwait[1] = (ccif.ramstate != ACCESS);
				//ccif.ccwait[0] = 1;
			end
		end
		ICACHE_DIAOSI:
		begin
			if(ccif.iREN[0])
			begin
				ccif.ramREN = 1;
				ccif.ramaddr = ccif.iaddr[0];
				ccif.iwait[0] = (ccif.ramstate != ACCESS);
				ccif.iload[0] = ccif.ramload;
			end
			else if (ccif.iREN[1])
			begin
				ccif.ramREN = 1;
				ccif.ramaddr = ccif.iaddr[1];
				ccif.iwait[1] = (ccif.ramstate != ACCESS);
				ccif.iload[1] = ccif.ramload;
			end
		end
		SNOOPING1_DIAOSI:
		begin 
			if (ccif.cctrans[1])
			begin 
				ccif.ccwait[0] = 0;
				ccif.ccinv[0] = 1;
			end
			ccif.ccwait[1] = 1;
			ccif.ccsnoopaddr[1] = ccif.daddr[0];
		end
		C1LD1_DIAOSI: 
		begin 
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramREN = 1;
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			ccif.dload[0] = ccif.ramload;
			//ccif.ccwait[1] = 1;
		end
		C1LD2_DIAOSI: 
		begin 
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramREN = 1;
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			ccif.dload[0] = ccif.ramload;
			//ccif.ccwait[1] = 1;
		end
		C1CACHE1_DIAOSI: 
		begin
			ccif.ccsnoopaddr[1] = ccif.daddr[0];
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[1];
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			ccif.dload[0] = ccif.dstore[1];
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
		end
		C1CACHE2_DIAOSI: 
		begin
			ccif.ccsnoopaddr[1] = ccif.daddr[0];
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[1];
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			ccif.dload[0] = ccif.dstore[1];
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
		end
		SNOOPING2_DIAOSI: 
		begin
			if (ccif.cctrans[0])
			begin 
				ccif.ccwait[1] = 0;
				ccif.ccinv[1] = 1;
			end
			ccif.ccwait[0] = 1;
			ccif.ccsnoopaddr[0] = ccif.daddr[1];
		end
		C2LD1_DIAOSI:  
		begin
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramREN = 1;
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			ccif.dload[1] = ccif.ramload;
			//ccif.ccwait[0] = 1;
		end
		C2LD2_DIAOSI: 
		begin
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramREN = 1;
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			ccif.dload[1] = ccif.ramload;
			//ccif.ccwait[0] = 1;
		end
		C2CACHE1_DIAOSI: 
		begin 
			ccif.ccsnoopaddr[0] = ccif.daddr[1];
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[0];
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			ccif.dload[1] = ccif.dstore[0];
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
		end
		C2CACHE2_DIAOSI: 
		begin
			ccif.ccsnoopaddr[0] = ccif.daddr[1];
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[0];
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			ccif.dload[1] = ccif.dstore[0];
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
		end
	endcase
end



endmodule