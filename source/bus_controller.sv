// interfaces
`include "cache_control_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"


module bus_controller (
	cache_control_if ccif,
	input logic CLK, nRST
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

Bus_control_state_t state, next_state;

always_ff @(posedge CLK, negedge nRST) begin
	if(!nRST) begin
		state <= IDLE_D;
	end else begin
		state <= next_state;
	end
end


always_comb begin : NEXT_LOGIC
	next_state = state;
	casez (state) 
		IDLE_B_DIAOSI:
		begin
			if (ccif.dWEN[0])
			begin
				next_state = C1WB1_DIAOSI;
			end 
			else if (ccif.dWEN[1])
			begin
				next_state = C2WB1_DIAOSI;
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
		ICACHE_DIAOSI:
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end
		end
		SNOOPING1_DIAOSI:
		begin 
			if (ccif.cctrans[1])
			begin 
				if (ccif.ccwrite[1])
				begin 
					next_state = C2WB1_DIAOSI;
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
		C2WB1_DIAOSI: 
		begin 
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C2WB2_DIAOSI;
			end
		end
		C2WB2_DIAOSI: 
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
				if (ccif.ccwrite[0])
				begin 
					next_state = C1WB1_DIAOSI;
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
		end
		C2LD2_DIAOSI: 
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = IDLE_B_DIAOSI;
			end
		end
		C1WB1_DIAOSI: 
		begin 
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C1WB2_DIAOSI;
			end
		end
		end
		C1WB2_DIAOSI: 
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
		ICACHE_DIAOSI:
		begin
			if(ccif.iREN[0])
			begin
				ccif.ramREN = 1;
				ccif.ramaddr = ccif.iaddr[0];
				ccif.iwait[0] = (ccif.ramstate != ACCESS);
				ccif.iload[0] = ramload;
			end
			else if (ccif.iREN[1])
			begin
				ccif.ramREN = 1;
				ccif.ramaddr = ccif.iaddr[1];
				ccif.iwait[1] = (ccif.ramstate != ACCESS);
				ccif.iload[1] = ramload;
			end
		end
		SNOOPING1_DIAOSI:
		begin 
			ccif.ccwait[1] = 1;
			ccif.ccsnoopaddr[1] = ccif.daddr[0];
		end
		C1LD1_DIAOSI: 
		begin 
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramREN = 1;
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			ccif.dload[0] = ccif.ramload;
			ccif.ccwait[1] = 1;
		end
		C1LD2_DIAOSI: 
		begin 
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramREN = 1;
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			ccif.dload[0] = ccif.ramload;
			ccif.ccwait[1] = 1;
		end
		C2WB1_DIAOSI: 
		begin
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[1];
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			if(ccif.daddr[0] == ccif.daddr[1])
			begin
				ccif.dload[0] = dstore[1];
				ccif.dwait = (ccif.ramstate != ACCESS);
			end
			else
			begin
				ccif.ccwait[0] = 1;
			end
		end
		C2WB2_DIAOSI: 
		begin
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[1];
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			if(ccif.daddr[0] == ccif.daddr[1])
			begin
				ccif.dload[0] = dstore[1];
				ccif.dwait = (ccif.ramstate != ACCESS);
			end
			else
			begin
				ccif.ccwait[0] = 1;
			end
		end
		SNOOPING2_DIAOSI: 
		begin
			ccif.ccwait[0] = 1;
			ccif.ccsnoopaddr[0] = ccif.daddr[1];
		end
		C2LD1_DIAOSI:  
		begin
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramREN = 1;
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			ccif.dload[1] = ccif.ramload;
			ccif.ccwait[0] = 1;
		end
		C2LD2_DIAOSI: 
		begin
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramREN = 1;
			ccif.dwait[1] = (ccif.ramstate != ACCESS);
			ccif.dload[1] = ccif.ramload;
			ccif.ccwait[0] = 1;
		end
		C1WB1_DIAOSI: 
		begin 
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[0];
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			if(ccif.daddr[1] == ccif.daddr[0])
			begin
				ccif.dload[1] = dstore[0];
				ccif.dwait = (ccif.ramstate != ACCESS);
			end
			else
			begin
				ccif.ccwait[1] = 1;
			end
		end
		C1WB2_DIAOSI: 
		begin
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramWEN = 1;
			ccif.ramstore = ccif.dstore[0];
			ccif.dwait[0] = (ccif.ramstate != ACCESS);
			if(ccif.daddr[1] == ccif.daddr[0])
			begin
				ccif.dload[1] = dstore[0];
				ccif.dwait = (ccif.ramstate != ACCESS);
			end
			else
			begin
				ccif.ccwait[1] = 1;
			end
		end
	endcase
end



endmodule