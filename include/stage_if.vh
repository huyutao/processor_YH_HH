/*
  Hanwen Huang
  huang651@purdue.edu

*/
`ifndef STAGE_IF_VH
`define STAGE_IF_VH

`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"

interface stage_if;
  // import types
  import cpu_types_pkg::*;
  import diaosi_types_pkg::*; // don't forget add ;
  logic       en, flushed, wb_en, 
              halt_i2, halt_o2, halt_i3, halt_o3,
  			      d_ren_i2, d_ren_o2, d_ren_i3, d_ren_o3,
  			      d_wen_i2, d_wen_o2, d_wen_i3, d_wen_o3,
  			      wen_i2, wen_o2, wen_i3, wen_o3, wen_i4, wen_o4;

  ZERO_SEL_t  zero_sel_i2, zero_sel_o2;

  ALUSrc_t		ALUSrc_i2, ALUSrc_o2;
  W_mux_t     W_mux_i2, W_mux_o2, W_mux_i3, W_mux_o3,
              W_mux_i4, W_mux_o4;
  PCSrc_t     PCSrc_i2, PCSrc_o2, PCSrc_i3, PCSrc_o3, PCSrc_i4, PCSrc_o4;

  regbits_t   wsel_i2, wsel_o2, wsel_i3, wsel_o3, wsel_i4,
              wsel_o4,
              shamt_i2, shamt_o2; 

  word_t      npc_i1, npc_o1, npc_i2, npc_o2, npc_i3, npc_o3, npc_i4, npc_o4,
              imemload_i1, imemload_o1, 
              LUI_i2, LUI_o2, LUI_i3, LUI_o3, LUI_i4, LUI_o4,
              ext32_i2, ext32_o2,
              rdat1_i2, rdat2_i2, rdat1_o2, rdat2_o2,
  			      jump_addr_i3, jump_addr_o3, jump_addr_i4, jump_addr_o4,
  			      branch_addr_i3, branch_addr_o3, branch_addr_i4, branch_addr_o4,
  			      jr_addr_i3, jr_addr_o3, jr_addr_i4, jr_addr_o4,
  			      dmemstore_i3, dmemstore_o3, 
  			      dmemload_i4, dmemload_o4, dmemaddr_i4, dmemaddr_o4,
              dmemaddr_i3, dmemaddr_o3;

  logic[25:0] j_addr26_i2, j_addr26_o2;
  logic[15:0] imm16_i2, imm16_o2;
  aluop_t     alu_op_i2, alu_op_o2;

  modport if_dc_6 (
  	input   npc_i1, en, imemload_i1,
  	output  npc_o1, imemload_o1
  );

  modport dc_ex_19 (
  	input  en, npc_i2, ext32_i2, j_addr26_i2, imm16_i2, LUI_i2, zero_sel_i2,PCSrc_i2,
  	ALUSrc_i2, W_mux_i2,  shamt_i2, halt_i2, d_ren_i2, d_wen_i2, wen_i2, 
  	wsel_i2, alu_op_i2, rdat1_i2, rdat2_i2,

  	output  npc_o2, ext32_o2, j_addr26_o2, imm16_o2, LUI_o2, zero_sel_o2,PCSrc_o2,
  	ALUSrc_o2, W_mux_o2,  shamt_o2, halt_o2,  d_ren_o2, d_wen_o2, wen_o2, 
  	wsel_o2, alu_op_o2, rdat1_o2, rdat2_o2
  );

  modport ex_mem_16 (
  	input  en, flushed, jump_addr_i3, npc_i3, branch_addr_i3, jr_addr_i3, PCSrc_i3, W_mux_i3, 
  	LUI_i3, wen_i3, wsel_i3, d_wen_i3, d_ren_i3, dmemstore_i3,
  	halt_i3, dmemaddr_i3,

   	output jump_addr_o3, npc_o3, branch_addr_o3, jr_addr_o3, PCSrc_o3, W_mux_o3, 
  	LUI_o3, wen_o3, wsel_o3, d_wen_o3, d_ren_o3, dmemstore_o3,
  	halt_o3, dmemaddr_o3 
  );

  modport mem_wb_13 (
  	input  wb_en, jump_addr_i4, npc_i4, branch_addr_i4, jr_addr_i4, PCSrc_i4, W_mux_i4, 
  	LUI_i4, wen_i4, wsel_i4, dmemload_i4, 
  	dmemaddr_i4,
  	output jump_addr_o4, npc_o4, branch_addr_o4, jr_addr_o4, PCSrc_o4, W_mux_o4, 
  	LUI_o4, wen_o4, wsel_o4, dmemload_o4, 
  	dmemaddr_o4
  );
endinterface

`endif