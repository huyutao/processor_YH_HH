
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module register_file (
	input CLK,    // Clock
	input nRST,  // Asynchronous reset active low
	register_file_if.rf rfif
	/*
	  logic     WEN;
	  regbits_t wsel, rsel1, rsel2;
	  word_t    wdat, rdat1, rdat2;

	  input   WEN, wsel, rsel1, rsel2, wdat,
      output  rdat1, rdat2
	  */
);

import cpu_types_pkg::*;

word_t [31:0] data;

assign rfif.rdat1 = data[rfif.rsel1];
assign rfif.rdat2 = data[rfif.rsel2];

always @(negedge CLK, negedge nRST)
begin
	if (1'b0 == nRST)
	begin
		data <= '{default:0};
	end
	else
	begin
		if (rfif.WEN)
			data[rfif.wsel] <= rfif.wdat;
		data[0] <= 32'b0;
	end
end


endmodule