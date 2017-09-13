`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

interface request_unit_if;
  logic d_hit,cu_dren_out,cu_dwen_out;
  logic d_ren,d_wen;

  // register file ports
  modport ru (
    input   d_hit,cu_dren_out,cu_dwen_out,
    output  d_ren,d_wen
  );
  // register file tb
  modport tb (
    input   d_ren,d_wen,
    output  d_hit,cu_dren_out,cu_dwen_out
  );
endinterface

`endif