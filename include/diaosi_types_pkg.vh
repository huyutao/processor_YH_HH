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
endpackage
`endif