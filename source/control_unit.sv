`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"

module control_unit (
	input CLK,    // Clock
	input nRST,  // Asynchronous reset active low
	control_unit_if.cu cuif
	/*
		instr, zero_f,overflow_f, ru_dhit_in, ru_ihit_in,

    	pc_next, alu_op, ru_iren_out, ru_dren_out, ru_dwen_out,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCsrc, 
    W_mux, Wsel_mux, ALUSrc, ExtOP
	  */
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

assign cuif.opcode = cuif.instr[31:26];
assign cuif.rs = cuif.instr[25:21];
assign cuif.rt = cuif.instr[20:16];
assign cuif.rd = cuif.instr[15:11];
assign cuif.funct = cuif.instr[5:0];

assign cuif.shamt = cuif.instr[10:6];
assign cuif.imm16 = cuif.instr[15:0];
assign cuif.j_addr26 = cuif.instr[25:0];
assign cuif.lui = {16'b0,cuif.imm16};


always_comb 
begin
	cuif.ru_iren_out = 0;
	cuif.ru_dren_out = 0;
	cuif.ru_dwen_out = 0;

	cuif.pc_next = 0;
	cuif.alu_op = 0;

    cuif.wsel = cuif.rt;
	cuif.rsel1 = cuif.rs;
	cuif.rsel2 = 0;
	cuif.wen = 1;

    cuif.PCsrc = ADD4_DIAOSI;      // ADD4_DIAOSI,JUMP_DIAOSI,JR_DIAOSI,BRANCH_DIAOSI
    cuif.W_mux = ALUOUT_DIAOSI;    // R31_DIAOSI, LUI_DIAOSI, DATA_DIAOSI, ALUOUT_DIAOSI, NEGF_DIAOSI
    cuif.ALUSrc = RDAT2_DIAOSI;    // RDAT2_DIAOSI, SHAMT_DIAOSI, EXT_DIAOSI
    cuif.ExtOP = ZEROEXT_DIAOSI;   // ZEROEXT_DIAOSI, SIGNEXT_DIAOSI


	casez(cuif.opcode)
		RTYPE:
		begin
			cuif.wsel = cuif.rd;
			cuif.rsel2 = cuif.rt;
			casez(cuif.funct)
			    SLL:begin
			    	cuif.alu_op = ALU_SLL;
				    cuif.ALUSrc = SHAMT_DIAOSI;
			    end
			    SRL:begin
			    	cuif.alu_op = ALU_SLL;
				    cuif.ALUSrc = SHAMT_DIAOSI;
			    end
			    JR:begin
			    	cuif.wen = 0;
    				cuif.PCsrc = JR_DIAOSI;
			    end
			    ADD,ADDU:begin
					cuif.alu_op = ALU_ADD;
			    end
			    SUB,SUBU:begin
			    	cuif.alu_op = ALU_SUB;
			    end
			    AND:begin
			 		cuif.alu_op = ALU_AND;
				end
			    OR:begin
			    	cuif.alu_op = ALU_OR;
			    end
			    XOR:begin
			    	cuif.alu_op = ALU_XOR;
			    end
			    NOR:begin
			    	cuif.alu_op = ALU_NOR;
			    end
			    SLT,SLTU:begin
			    	cuif.alu_op = ALU_SUB;
			    	cuif.W_mux = NEGF_DIAOSI;
			    end
	 		endcase
		end
	    // jtype
	    J:begin
			cuif.wen = 0;
			cuif.PCSrc = JUMP_DIAOSI
		end
	    JAL:begin
			cuif.PCSrc = JUMP_DIAOSI
			cuif.W_mux = R31_DIAOSI
		end

	    // itype
	    BEQ:
		begin
			cuif.rsel2 = cuif.rt;
			if (cuif.zero_f): cuif.PCSrc = BRANCH_DIAOSI
		end
	    BNE:
		begin
			cuif.rsel2 = cuif.rt;
			if (!cuif.zero_f): cuif.PCSrc = BRANCH_DIAOSI
		end
	    ADDI:
		begin

		end
	    ADDIU:
		begin

		end
	    SLTI:
		begin

		end
	    SLTIU:
		begin

		end
	    ANDI:
		begin

		end
	    ORI:
		begin

		end
	    XORI:
		begin

		end
	    LUI:
		begin

		end
	    LW:
		begin

		end
	    LBU:
		begin

		end
	    LHU:
		begin

		end
	    SB:
		begin

		end
	    SH:
		begin

		end
	    SW:
		begin

		end
	    HALT:
		begin

		end
	 endcase
end


endmodule