`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"
`include "hazard_unit_if.vh"
module hazard_unit (
	hazard_unit_if.hu huif
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

always_comb
begin
	if (huif.pc_src == JUMP_DIAOSI) begin
	   	huif.flushed = 1;
	   	huif.pc_en = 0;
	   	huif.id_en = 1;
	end else if (huif.pc_src == JR_DIAOSI) begin
	   	huif.flushed = 1;
	   	huif.pc_en = 0;
	   	huif.id_en = 1;
	end else if (huif.pc_src == BRANCH_DIAOSI) begin
	   	huif.flushed = 1;
	   	huif.pc_en = 0;
	   	huif.id_en = 1;
	end else begin
	   	huif.flushed = 0;
	   	huif.pc_en = 1;
	   	huif.id_en = 1;
		if ((huif.wsel != 0) & (huif.d_ren == 1) & ((huif.wsel == huif.rsel1)|(huif.wsel == huif.rsel2))) begin
	   		huif.flushed = 0;
	   		huif.pc_en = 0;
	   		huif.id_en = 0;			
		end
	end
end

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

