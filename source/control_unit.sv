`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"

module control_unit (
	input CLK,    // Clock
	input nRST,  // Asynchronous reset active low
	control_unit_if.cu cuif
	/*
		instr, zero_f,overflow_f, d_hit, i_hit,

    	pc_next, alu_op, ru_iren_out, ru_dren_out, ru_dwen_out,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCSrc, 
    W_mux, Wsel_mux, ALUSrc, ExtOP, halt
	  */
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

funct_t funct;
opcode_t opcode;
regbits_t rs,rt,rd;
logic next_halt;

assign opcode = opcode_t'(cuif.instr[31:26]);
assign rs = cuif.instr[25:21];
assign rt = cuif.instr[20:16];
assign rd = cuif.instr[15:11];
assign funct = funct_t'(cuif.instr[5:0]);

assign cuif.shamt = cuif.instr[10:6];
assign cuif.imm16 = cuif.instr[15:0];
assign cuif.j_addr26 = cuif.instr[25:0];
assign cuif.lui = {16'b0,cuif.imm16};


always @(posedge CLK, negedge nRST)
begin
	if (1'b0 == nRST)
	begin
		cuif.halt <= 0;
	end
	else
	begin
		cuif.halt <= next_halt;
	end
end


always_comb 
begin
	cuif.i_ren = (cuif.i_hit || cuif.d_hit);
	cuif.ru_dren_out = (cuif.i_hit && opcode == LW);
	cuif.ru_dwen_out = (cuif.i_hit && opcode == SW);

	cuif.pc_next = cuif.i_hit || cuif.d_hit;
	cuif.alu_op = ALU_SLL;

    cuif.wsel = (opcode==RTYPE)?rd:rt;
	cuif.rsel1 = rs;
	cuif.rsel2 = (opcode==RTYPE || opcode==BEQ || opcode==BNE)?rt:0;
	cuif.wen = 1;
	next_halt = 0;

    cuif.PCSrc = ADD4_DIAOSI;      // ADD4_DIAOSI,JUMP_DIAOSI,JR_DIAOSI,BRANCH_DIAOSI
    cuif.W_mux = ALUOUT_DIAOSI;    // R31_DIAOSI, LUI_DIAOSI, DATA_DIAOSI, ALUOUT_DIAOSI, NEGF_DIAOSI
    //cuif.ALUSrc = RDAT2_DIAOSI;    // RDAT2_DIAOSI, SHAMT_DIAOSI, EXT_DIAOSI
    cuif.ExtOP = (opcode==ANDI||opcode==ORI||opcode==XORI)?ZEROEXT_DIAOSI:SIGNEXT_DIAOSI;   // ZEROEXT_DIAOSI, SIGNEXT_DIAOSI

    // RDAT2_DIAOSI, SHAMT_DIAOSI, EXT_DIAOSI
    if(opcode==RTYPE || opcode==BNE || opcode==BEQ) 
    begin
    	if(funct==SLL || funct==SLL)
    	begin
    		cuif.ALUSrc = SHAMT_DIAOSI;
    	end
    	else
    	begin
    		cuif.ALUSrc = RDAT2_DIAOSI;
    	end
    end
    else
    begin	
    	cuif.ALUSrc = EXT_DIAOSI;
    end

    if(cuif.instr==32'hFFFFFFFF)         // HALT
    begin
    	next_halt = 1;
    end
    else
    begin
    	if(cuif.overflow_f)
    	begin
	    	if(opcode==RTYPE && (funct==SUB || funct==ADD))
	    	begin
	    		next_halt = 1;
	    	end
	    	if(opcode==ADDI)
	    	begin
	    		next_halt = 1;
	    	end
	    end
    end


	casez(opcode)
		RTYPE:
		begin
			casez(funct)
			    SLL:
			    begin
			    	cuif.alu_op = ALU_SLL;
			    end
			    SRL:
			    begin
			    	cuif.alu_op = ALU_SRL;
			    end
			    JR:
			    begin
			    	cuif.wen = 0;
    				cuif.PCSrc = JR_DIAOSI;
			    end
			    ADD,ADDU:
			    begin
					cuif.alu_op = ALU_ADD;
			    end
			    SUB,SUBU:
			    begin
			    	cuif.alu_op = ALU_SUB;
			    end
			    AND:
			    begin
			 		cuif.alu_op = ALU_AND;
				end
			    OR:
			    begin
			    	cuif.alu_op = ALU_OR;
			    end
			    XOR:
			    begin
			    	cuif.alu_op = ALU_XOR;
			    end
			    NOR:
			    begin
			    	cuif.alu_op = ALU_NOR;
			    end
			    SLT:
			    begin
			    	cuif.alu_op = ALU_SLT;
			    end
			    SLTU:
			    begin
			    	cuif.alu_op = ALU_SLTU;
			    end
	 		endcase
		end
	    // jtype
	    J:
	    begin
			cuif.wen = 0;
			cuif.PCSrc = JUMP_DIAOSI;
		end
	    JAL:
	    begin
			cuif.PCSrc = JUMP_DIAOSI;
			cuif.W_mux = R31_DIAOSI;
		end

	    // itype
	    BEQ:
		begin
			cuif.alu_op = ALU_SUB;
			if (cuif.zero_f==1) cuif.PCSrc = BRANCH_DIAOSI;
		end
	    BNE:
		begin
			cuif.alu_op = ALU_SUB;
			if (cuif.zero_f==0) cuif.PCSrc = BRANCH_DIAOSI;
		end
	    ADDI,ADDIU:
		begin
			cuif.alu_op = ALU_ADD;
		end
		LW:
		begin
			cuif.alu_op = ALU_ADD;
		end
		SW:
		begin
			cuif.W_mux = DATA_DIAOSI;
			cuif.alu_op = ALU_ADD;
		end
	    SLTI:
		begin
			cuif.alu_op = ALU_SLT;
		end
		SLTIU:
		begin
			cuif.alu_op = ALU_SLTU;
		end
	    ANDI:
		begin
			cuif.alu_op = ALU_AND;
		end
	    ORI:
		begin
			cuif.alu_op = ALU_OR;
		end
	    XORI:
		begin
			cuif.alu_op = ALU_XOR;
		end
	    LUI:
		begin
			cuif.W_mux = LUI_DIAOSI;
		end
	 endcase
end

endmodule