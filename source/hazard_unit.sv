`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"
`include "hazard_unit_if.vh"
module hazard_unit (
	hazard_unit_if.hu huif
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;


assign huif.pipe3_en = huif.ihit;
assign huif.pipe4_en = huif.ihit | huif.dhit;
assign huif.flushed3 = huif.dhit;

always_comb
begin
	if (((huif.pc_src == JUMP_DIAOSI) | (huif.pc_src == JR_DIAOSI) | (huif.pc_src == BRANCH_DIAOSI & huif.branch_sel == 1)) & (huif.ihit == 1)) begin
	   	huif.flushed1 = 1;
	   	huif.pipe1_en = 1;
	   	huif.flushed2 = 1;//1
	   	huif.pipe2_en = 1;
	   	huif.pc_en = 1;
	// LW add bubble
	end else if (((huif.opcode == LW || huif.opcode == SW) & ((huif.wsel == huif.rsel1)|(huif.wsel == huif.rsel2))) & (huif.ihit == 1)) begin
		huif.flushed1 = 0;//0
	   	huif.pipe1_en = 1;//1
	   	huif.flushed2 = 0;//1
	   	huif.pipe2_en = 1;
	   	huif.pc_en = 0;
	end else begin
	   	huif.flushed1 = 0;
	   	huif.pipe1_en = 1;
	   	huif.flushed2 = 0;
	   	huif.pipe2_en = 1;
	   	huif.pc_en = 1;
	end

end
/*else if (((huif.d_ren == 1) & ((huif.wsel == huif.rsel1)|(huif.wsel == huif.rsel2))) & (huif.ihit == 1)) begin
   		huif.flushed1 = 0;
	   	huif.id_en1 = 1;
	   	huif.flushed2 = 0;
	   	huif.id_en2 = 1;
	   	huif.pc_en = 0;
	end*/
endmodule // hazard_unit
/*
logic flushed, pc_en, id_en;
always_ff@(posedge CLK, negedge nRST) begin

	if (!nRST) begin
		huif.flushed <= 0;
		huif.pc_en  <= 1;
		huif.id_en  <= 1;
	end else begin
 		huif.flushed <= flushed;
		huif.pc_en  <= pc_en;
		huif.id_en  <= id_en;       
	end
end
always_comb 
begin
	
	if ((huif.opcode == J) | (huif.opcode == JAL) | (huif.opcode == BEQ) | (huif.opcode == BNE)) begin
	   	flushed = 1;
	   	pc_en = 0;
	   	id_en = 0;
	end else if ((huif.opcode == RTYPE) & (huif.func == JR))begin
	   	flushed = 1;
	   	pc_en = 0;
	   	id_en = 0;
	end else if ((huif.opcode == LW) & (huif.func == SW)) begin
	   	flushed = 1;
	   	pc_en = 0;
	   	id_en = 0;
	end else begin
	   	flushed = 0;
	   	pc_en = 1;
	   	id_en = 1;
	end
end*/

