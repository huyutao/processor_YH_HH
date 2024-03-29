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
`include "register_file_if.vh"
`include "alu_if.vh"
`include "stage_if.vh"
`include "forwarding_unit_if.vh"
`include "hazard_unit_if.vh"
// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
`include "diaosi_types_pkg.vh"//add later


module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dcif
);
  // import types
  import cpu_types_pkg::*;
  import diaosi_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  //interface
  control_unit_if cuif();
  register_file_if rfif();
  alu_if aluif ();
  stage_if stif ();
  hazard_unit_if huif();
  forwarding_unit_if fuif();
  //DUT
  control_unit        CU(cuif);
  register_file       RF(CLK, nRST,rfif);
  alu                 ALU (aluif);
  if_dc               ID (CLK, nRST, stif);
  dc_ex               DE (CLK, nRST, stif);
  ex_mem              EM (CLK, nRST, stif);
  mem_wb              MW (CLK, nRST, stif);
  hazard_unit         HU (huif);
  forwarding_unit     FU (fuif);
  //pipeline regs

  logic   branch_sel;
  word_t pc_out, pc_input, npc;
  logic pc_en;


  always_ff@(posedge CLK, negedge nRST) begin
  if (!nRST) 
      pc_out <= PC_INIT;
  else begin
      if (pc_en == 1)
          pc_out <= pc_input;
      else                    //?
          pc_out <= pc_out;

  end
end

assign npc = pc_out+4;

  //pc_signal control
  always_comb
    begin
      casez(stif.PCSrc_o2)  
        ADD4_DIAOSI:       pc_input = npc;
        BRANCH_DIAOSI:     pc_input = stif.branch_addr_i3;
        JUMP_DIAOSI:       pc_input = stif.jump_addr_i3;
        JR_DIAOSI:         pc_input = stif.jr_addr_i3;   
        default:           pc_input = npc;
      endcase 
  end
  assign pc_en = dcif.ihit & huif.pc_en;
  //icache control
  assign dcif.imemREN      = ~(dcif.dmemREN | dcif.dmemWEN) & !dcif.halt;
  assign dcif.imemaddr     = pc_out; 
  //if_dc 
  assign stif.npc_i1       = npc;
  assign stif.imemload_i1  = dcif.imemload;
  assign stif.flushed1     = huif.flushed1; 
  assign stif.flushed2     = huif.flushed2; 
  //assign stif.flushed3        = dcif.dhit;
  assign stif.flushed3     = huif.flushed3; 
  assign stif.pipe1_en        = huif.pipe1_en;
  assign stif.pipe2_en        = huif.pipe2_en;
  assign stif.pipe3_en        = huif.pipe3_en;
  assign stif.pipe4_en        = huif.pipe4_en;
  //control_unit  change later!! 
  //assign cuif.i_hit     = dcif.ihit;
  assign cuif.instr        = stif.imemload_o1;
  assign huif.ihit         = dcif.ihit;
  assign huif.pc_src       = stif.PCSrc_o2;
  assign huif.dhit        = dcif.dhit;
  assign huif.rsel1        = cuif.rsel1;
  assign huif.rsel2        = cuif.rsel2;
  assign huif.wsel         = stif.wsel_o2;
  assign huif.branch_sel   = branch_sel;
  assign huif.opcode       = opcode_t'(stif.imemload_o2[31:26]);
  assign huif.rfrt         = cuif.rsel2;
  assign huif.rfrs         = cuif.rsel1;
  assign huif.wsel_o3      = stif.wsel_o3;      
  //register file
  always_comb
    begin
      casez(stif.W_mux_o4)  
        LUI_DIAOSI:      rfif.wdat  = stif.LUI_o4;
        R31_DIAOSI:      rfif.wdat  = stif.npc_o4;
        DATA_DIAOSI:     rfif.wdat  = stif.dmemload_o4;
        ALUOUT_DIAOSI:   rfif.wdat  = stif.dmemaddr_o4;   
        default:         rfif.wdat  = stif.LUI_o4;
    endcase 
  end 
  assign rfif.wsel   = stif.wsel_o4;
  assign rfif.WEN    = stif.wen_o4;
  assign rfif.rsel1  = cuif.rsel1;
  assign rfif.rsel2  = cuif.rsel2;
  //dc_ex
  always_comb
    begin
      casez(cuif.ExtOP)  
        SIGNEXT_DIAOSI:   stif.ext32_i2  = {{16{cuif.imm16[15]}},cuif.imm16};
        ZEROEXT_DIAOSI:   stif.ext32_i2  = cuif.imm16;   
        default:          stif.ext32_i2  = cuif.imm16;
    endcase 
  end 
  assign stif.npc_i2        = stif.npc_o1;
  assign stif.imemload_i2   = stif.imemload_o1;
  assign stif.j_addr26_i2   = cuif.j_addr26;
  assign stif.imm16_i2      = cuif.imm16;
  assign stif.LUI_i2        = cuif.lui;
  assign stif.zero_sel_i2   = cuif.zero_sel;
  assign stif.PCSrc_i2      = cuif.PCSrc;
  assign stif.ALUSrc_i2     = cuif.ALUSrc;
  assign stif.W_mux_i2      = cuif.W_mux;
  assign stif.shamt_i2      = cuif.shamt;
  assign stif.halt_i2       = cuif.halt;
  assign stif.d_ren_i2      = cuif.d_ren;
  assign stif.d_wen_i2      = cuif.d_wen;
  assign stif.wen_i2        = cuif.wen;
  assign stif.wsel_i2       = cuif.wsel;
  assign stif.alu_op_i2     = cuif.alu_op;
  assign stif.d_atomic_i2   = cuif.d_atomic;
  assign stif.rdat1_i2      = rfif.rdat1;
  assign stif.rdat2_i2      = rfif.rdat2;
  assign stif.rsel1_i2      = rfif.rsel1;
  assign stif.rsel2_i2      = rfif.rsel2;
  //excute
  //forward_unit
  assign fuif.ALUSrc        = stif.ALUSrc_o2;
  assign fuif.wsel_o3         = stif.wsel_o3;
  assign fuif.wen_o3         = stif.wen_o3;
  assign fuif.rsel1_o2       = stif.rsel1_o2;
  assign fuif.rsel2_o2       = stif.rsel2_o2;
  assign fuif.wsel_o4         = stif.wsel_o4;
  assign fuif.wen_o4         = stif.wen_o4;
  //alu
  word_t    rdatB;
  word_t    out3_w, out4_w;
  OUT3_t    out3_sel;
  OUT4_t    out4_sel;
  opcode_t  opc3,opc4;
  assign    opc4      = opcode_t'(stif.imemload_o4[31:26]);
  assign    opc3      = opcode_t'(stif.imemload_o3[31:26]);

  always_comb
  begin
    if (~stif.d_ren_o4)
      out4_w = stif.dmemaddr_o4;
    else if (opc4 == LUI)
      out4_w = stif.LUI_o4;
    else
      out4_w = stif.dmemload_o4;

    if (opc3 == LUI)
      out3_w = stif.LUI_o3;
    else
      out3_w = stif.dmemaddr_o3;

    casez(stif.ALUSrc_o2)  
      RDAT2_DIAOSI:     rdatB        = stif.rdat2_o2;
      SHAMT_DIAOSI:     rdatB        = stif.shamt_o2;
      EXT_DIAOSI:       rdatB        = stif.ext32_o2;     
      default:          rdatB        = stif.rdat2_o2;
    endcase 
    casez(fuif.forwardA)  
      OUT3_DIAOSI:        aluif.a      = out3_w;
      OUT4_DIAOSI:        aluif.a      = out4_w;
      RDAT_DS:          aluif.a      = stif.rdat1_o2;
      default:          aluif.a      = stif.rdat1_o2;
    endcase 
    casez(fuif.forwardB)  
      OUT3_DIAOSI:        aluif.b      = out3_w;
      OUT4_DIAOSI:        aluif.b      = out4_w;
      RDAT_DS:          aluif.b      = rdatB;
      default:          aluif.b      = rdatB;
    endcase 
    casez(fuif.store)  
      RDAT2_STORE_O2_DIAOSI:        stif.dmemstore_i3  = stif.rdat2_o2;
      DMEMADDR_STORE_O3_DIAOSI:     stif.dmemstore_i3  = stif.dmemaddr_o3;
      DMEMADDR_STORE_O4_DIAOSI:     stif.dmemstore_i3  = stif.dmemaddr_o4;
      default:                      stif.dmemstore_i3  = stif.rdat2_o2;
    endcase 
  end 
  //assign aluif.a            = stif.rdat1_o2;

  assign aluif.op           = stif.alu_op_o2;
  //memory address

  word_t  pc1;
  always_comb
  begin
    casez(stif.zero_sel_o2)  
      BNE_DIAOSI:     branch_sel        = ~aluif.zero_flag;
      BEQ_DIAOSI:     branch_sel        = aluif.zero_flag;    
      default:        branch_sel        = aluif.zero_flag;
    endcase 
  end   
  assign pc1 = {{16{stif.imm16_o2[15]}}, stif.imm16_o2[15:0]}<<2;
  //ex_mem
  assign stif.jump_addr_i3   = stif.npc_o2[31:28]<<28 |  stif.j_addr26_o2<<2;
  assign stif.npc_i3         = stif.npc_o2;
  assign stif.imemload_i3    = stif.imemload_o2;
  always_comb
  begin
    casez(branch_sel)  
      1'b1:    stif.branch_addr_i3     = pc1 + stif.npc_o2;
      1'b0:    stif.branch_addr_i3     = stif.npc_i1;    
      default: stif.branch_addr_i3     = stif.npc_i1;           
    endcase 
  end    
  assign stif.jr_addr_i3     = stif.rdat1_o2;
  assign stif.PCSrc_i3       = stif.PCSrc_o2; 
  assign stif.W_mux_i3       = stif.W_mux_o2;
  assign stif.LUI_i3         = stif.LUI_o2;
  assign stif.wen_i3         = stif.wen_o2;
  assign stif.wsel_i3        = stif.wsel_o2;
  assign stif.d_wen_i3       = stif.d_wen_o2;
  assign stif.d_ren_i3       = stif.d_ren_o2;
  //assign stif.dmemstore_i3   = (fuif.store == RDAT2_DS)? stif.rdat2_o2: stif.dmemaddr_o3;
  assign stif.halt_i3        = stif.halt_o2;
  assign stif.dmemaddr_i3    = aluif.out;
  assign stif.d_atomic_i3    = stif.d_atomic_o2;
  //dcache
  assign dcif.dmemWEN        = stif.d_wen_o3;
  assign dcif.dmemREN        = stif.d_ren_o3;
  assign dcif.dmemstore      = stif.dmemstore_o3;
  assign dcif.dmemaddr       = stif.dmemaddr_o3;
  assign dcif.datomic        = stif.d_atomic_o3;
  always @(posedge CLK, negedge nRST)
  begin
    if (1'b0 == nRST)
      dcif.halt <= 0;
    else
    begin
      if (dcif.halt)
        dcif.halt <= 1;
      else
        dcif.halt <= stif.halt_o3;
    end
  end

  //mem_wb
  assign stif.imemload_i4    = stif.imemload_o3;
  assign stif.d_ren_i4       = stif.d_ren_o3;
  assign stif.jump_addr_i4   = stif.jump_addr_o3;
  assign stif.npc_i4         = stif.npc_o3;
  assign stif.branch_addr_i4 = stif.branch_addr_o3; 
  assign stif.jr_addr_i4     = stif.jr_addr_o3;
  assign stif.PCSrc_i4       = stif.PCSrc_o3;
  assign stif.W_mux_i4       = stif.W_mux_o3;
  assign stif.LUI_i4         = stif.LUI_o3;
  assign stif.wen_i4         = stif.wen_o3;
  assign stif.wsel_i4        = stif.wsel_o3;
  assign stif.dmemload_i4    = dcif.dmemload;
  assign stif.dmemaddr_i4    = stif.dmemaddr_o3;


endmodule
  //assign pc3 = (PCSrc == 1'b0)? npc_o4: ((PCSrc == 1'b1)? branc)
  /*
  modport dp (
    input   ihit, imemload, dhit, dmemload,
    output  halt, imemREN, imemaddr, dmemREN, dmwen_o3, datomic,
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
/*
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
  assign dpif.dmwen_o3 = ruif.d_wen;

  //program counter signal
  assign pcif.imm16 = cuif.imm16;
  assign pcif.j_addr26 = cuif.j_addr26;
  assign pc_outSrc = cuif.PCSrc;
  assign pc_out_next = cuif.pc_next;
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

*/

