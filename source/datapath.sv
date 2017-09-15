/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

`include "control_unit_if.vh"
`include "request_unit_if.vh"
`include "program_counter_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"


module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
  import diaosi_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  //interface
  control_unit_if cuif();
  request_unit_if ruif();
  program_counter_if pcif();
  register_file_if rfif();
  alu_if aluif ();

  //DUT
  control_unit CU(CLK, nRST,cuif);
  request_unit RU(CLK, nRST,ruif);
  program_counter PC(CLK, nRST,pcif);
  register_file RF(CLK, nRST,rfif);
  alu ALU (aluif);

  /*
  modport dp (
    input   ihit, imemload, dhit, dmemload,
    output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
            dmemstore, dmemaddr
  );

  modport cu (
    input   instr, zero_f,overflow_f, i_hit, d_hit,
    output  pc_next, alu_op, i_ren, ru_dren_out, ru_dwen_out,
    wsel,rsel1,rsel2, wen, imm16, j_addr26, shamt, lui, PCSrc, 
    W_mux, ALUSrc, ExtOP, halt
  );

  modport ru (
    input   i_hit,d_hit,cu_dren_out,cu_dwen_out,
    output  d_ren,d_wen
  );

  modport pc (
    input   imm16,j_addr26,jr,PCSrc,pc_next,
    output  i_addr,jar_addr
  );

  modport rf (
    input   WEN, wsel, rsel1, rsel2, wdat,
    output  rdat1, rdat2
  );
  modport af (
    input   op, a, b,
    output  out, zero_flag, negative_flag, overflow_flag
  );

  */

  word_t wdat_mux_out, b_mux_out, extender_out;


  //control unit signal
  assign cuif.i_hit = dpif.ihit;
  assign cuif.d_hit = dpif.dhit;
  assign cuif.instr = dpif.imemload;
  assign cuif.zero_f = aluif.zero_flag;
  assign cuif.overflow_f = aluif.overflow_flag;
  assign dpif.halt = cuif.halt;
  assign dpif.imemREN = cuif.i_ren;

  //request unit signal
  assign ruif.i_hit = dpif.ihit;
  assign ruif.d_hit = dpif.dhit;
  assign ruif.cu_dren_out = cuif.ru_dren_out;
  assign ruif.cu_dwen_out = cuif.ru_dwen_out;
  assign dpif.dmemREN = ruif.d_ren;
  assign dpif.dmemWEN = ruif.d_wen;

  //program counter signal
  assign pcif.imm16 = cuif.imm16;
  assign pcif.j_addr26 = cuif.j_addr26;
  assign pcif.PCSrc = cuif.PCSrc;
  assign pcif.pc_next = cuif.pc_next;
  assign pcif.jr = rfif.rdat1;
  assign dpif.imemaddr = pcif.i_addr;

  //register file sigal
  assign rfif.wsel = cuif.wsel;
  assign rfif.rsel1 = cuif.rsel1;
  assign rfif.rsel2 = cuif.rsel2;
  assign rfif.WEN = cuif.wen&(dpif.ihit|dpif.dhit);
  assign rfif.wdat = wdat_mux_out;
  assign dpif.dmemstore = rfif.rdat2;

  //ALU signal
  assign aluif.op = cuif.alu_op;
  assign aluif.a = rfif.rdat1;
  assign aluif.b = b_mux_out;
  assign dpif.dmemaddr = aluif.out;



always_comb 
begin
  casez(cuif.W_mux)
    ALUOUT_DIAOSI: wdat_mux_out = aluif.out;
    R31_DIAOSI: wdat_mux_out = pcif.jar_addr;
    LUI_DIAOSI: wdat_mux_out = cuif.lui;
    DATA_DIAOSI: wdat_mux_out = dpif.dmemload;
    default: 
        wdat_mux_out = aluif.out;
  endcase

  casez(cuif.ExtOP)
    ZEROEXT_DIAOSI: extender_out = {16'h0000,cuif.imm16};
    SIGNEXT_DIAOSI: 
    begin
      if (cuif.imm16[15]==1) extender_out = {16'hFFFF,cuif.imm16};
      else extender_out = {16'h0000,cuif.imm16};
    end
    default: 
        extender_out = {16'h0000,cuif.imm16};
  endcase

  casez(cuif.ALUSrc)
    RDAT2_DIAOSI: b_mux_out = rfif.rdat2;
    SHAMT_DIAOSI: b_mux_out = cuif.shamt;
    EXT_DIAOSI: b_mux_out = extender_out;
    default: 
        b_mux_out = rfif.rdat2;
  endcase
end


endmodule
