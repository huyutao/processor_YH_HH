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
			if (ccif.cctrans[0])
			begin
				next_state = SNOOPING1_DIAOSI;
			end
			else if (ccif.cctrans[1])
			begin 
				next_state = SNOOPING2_DIAOSI;
			end
		end
		SNOOPING1_DIAOSI:
		begin 
			if (ccif.cctrans[1])
			begin 
				if (ccif.ccwrite[1])
				begin 
					next_state = C1CACHE1_DIAOSI;
				end
				else
				begin 
					next_state = C1MEM1_DIAOSI;
				end
			end
		end
		C1MEM1_DIAOSI: 
		begin 
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C1MEM2_DIAOSI;
			end
		end
		C1MEM2_DIAOSI: 
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
				if (ccif.ccwrite[0])
				begin 
					next_state = C2CACHE1_DIAOSI;
				end
				else
				begin 
					next_state = C2MEM1_DIAOSI;
				end
			end
		end
		C2MEM1_DIAOSI:  
		begin
			if (ccif.ramstate == ACCESS)
			begin
				next_state = C2MEM2_DIAOSI;
			end
		end
		end
		C2MEM2_DIAOSI: 
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
	ccif.ccinv[0] = 0;
	ccif.ccsnoopaddr[0] = 0;

	ccif.iload[1] = 0;
	ccif.iwait[1] = 1;
	ccif.dwait[1] = 1;
	ccif.dload[1] = 0;
	ccif.ccwait[1] = 0;
	ccif.ccinv[1] = 0;
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
		SNOOPING1_DIAOSI:
		begin 
			//
		end
		C1MEM1_DIAOSI: 
		begin 
			//
		end
		C1MEM2_DIAOSI: 
		begin 
			//
		end
		C1CACHE1_DIAOSI: 
		begin 
			//
		end
		C1CACHE2_DIAOSI: 
		begin
			//
		end
		SNOOPING2_DIAOSI: 
		begin
			//
		end
		C2MEM1_DIAOSI:  
		begin
			//
		end
		end
		C2MEM2_DIAOSI: 
		begin
			//
		end
		C2CACHE1_DIAOSI: 
		begin 
			//
		end
		end
		C2CACHE2_DIAOSI: 
		begin
			//
		end
	endcase
end






endmodule