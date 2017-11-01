/*
  Yutao Hu
  CEO@purdue.com

  all types used to make life easier.
*/
`ifndef DIAOSI_TYPES_PKG_VH
`define DIAOSI_TYPES_PKG_VH
package diaosi_types_pkg;

	typedef enum logic [1:0] {
	ADD4_DIAOSI,JUMP_DIAOSI,JR_DIAOSI,BRANCH_DIAOSI
	} PCSrc_t;

	typedef enum logic [1:0] {
	ALUOUT_DIAOSI, R31_DIAOSI, LUI_DIAOSI, DATA_DIAOSI
	} W_mux_t;

	typedef enum logic [1:0] {
	RDAT2_DIAOSI, SHAMT_DIAOSI, EXT_DIAOSI
	} ALUSrc_t;

	typedef enum logic {
	ZEROEXT_DIAOSI, SIGNEXT_DIAOSI
	} ExtOP_t;

	typedef enum logic {
	BNE_DIAOSI, BEQ_DIAOSI
	} ZERO_SEL_t;

	typedef enum logic [1:0] {
	OUT4_DIAOSI, OUT3_DIAOSI, RDAT_DS
	} Forward_t;

	typedef enum logic [1:0]{
	RDAT2_STORE_O2_DIAOSI, DMEMADDR_STORE_O3_DIAOSI, DMEMADDR_STORE_O4_DIAOSI
	} Store_t;

	typedef enum logic [1:0]{
	DMEMLOAD_OUT4_DIAOSI, DMEMADDR_OUT4_DIAOSI, LUI_OUT4_DIAOSI
	} OUT4_t;

	typedef enum logic {
	DMEMADDR_OUT3_DIAOSI, LUI_OUT3_DIAOSI
	} OUT3_t;

	typedef enum logic {
	IDLE_I, LD  
	} Istate_t;

	typedef enum logic [3:0] {
	IDLE_D, LD1, LD2, WB1, WB2, CLEAN, FLUSH1, FLUSH2, HLT_CNT, HALT_D, SNOOP_DIAOSI, CCWB1, CCWB2
	} Dstate_t;

  	typedef struct packed {
    	logic [25:0]  tag;
    	logic		  valid;
    	logic [31:0]  data;
  	} Icache_t;

  	typedef struct packed {
    	logic [25:0]  tag;
    	logic 		  valid, dirty;    
    	logic [31:0]  data1;
    	logic [31:0]  data2;
  	} Dcache_t;

  	typedef enum logic [3:0] {
	IDLE_B_DIAOSI, ICACHE_DIAOSI, BUSWB1, BUSWB2, SNOOPING1_DIAOSI, C1LD1_DIAOSI, C1LD2_DIAOSI, C1CACHE1_DIAOSI, C1CACHE2_DIAOSI, SNOOPING2_DIAOSI, C2LD1_DIAOSI, C2LD2_DIAOSI, C2CACHE1_DIAOSI, C2CACHE2_DIAOSI
	} Bus_control_state_t;


endpackage
`endif