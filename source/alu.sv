
`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module alu (
	alu_if.af aluif
	/*
	  input   aluop, a, b,
      output  out, zero_flag, negative_flag, overflow_flag


	    ALU_SLL     = 4'b0000, shift left logic 
	    ALU_SRL     = 4'b0001,   shift right logic
	    ALU_ADD     = 4'b0010,
	    ALU_SUB     = 4'b0011,
	    ALU_AND     = 4'b0100,
	    ALU_OR      = 4'b0101,
	    ALU_XOR     = 4'b0110,
	    ALU_NOR     = 4'b0111,
	    ALU_SLT     = 4'b1010,    set less than
	    ALU_SLTU    = 4'b1011     set less than unsigned
	  */
);

import cpu_types_pkg::*;

assign aluif.zero_flag = (aluif.out == 0)?1:0;
assign aluif.negative_flag = (aluif.out[31] == 1)?1:0;

always_comb 
begin
	aluif.overflow_flag = '0;
	casez(aluif.op)
		ALU_SLL: aluif.out = aluif.a << aluif.b;
	    ALU_SRL: aluif.out = aluif.a >> aluif.b;
	    ALU_ADD: 
	    begin
	    	aluif.out = aluif.a + aluif.b;
	    	aluif.overflow_flag = (aluif.a[31] == aluif.b[31])?((aluif.a[31] == aluif.out[31])?0:1):0;
	    end
	    ALU_SUB:
	    begin
	    	aluif.out = aluif.a - aluif.b;
	    	aluif.overflow_flag = (aluif.a[31] == aluif.b[31])?((aluif.a[31] == aluif.out[31])?0:1):0;
	    end
	    ALU_AND: aluif.out = aluif.a & aluif.b;
	    ALU_OR: aluif.out = aluif.a | aluif.b;
	    ALU_XOR: aluif.out = aluif.a ^ aluif.b;
	    ALU_NOR: aluif.out = ~(aluif.a | aluif.b);
	    ALU_SLT: aluif.out = $signed(aluif.a) < $signed(aluif.b);
	    ALU_SLTU: aluif.out = $unsigned(aluif.a) < $unsigned(aluif.b);
	    default: 
	    	aluif.out = '0;
	 endcase
end

endmodule