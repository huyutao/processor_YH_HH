
`include "request_unit_if.vh"

module request_unit(
	input CLK,    // Clock
	input nRST,  // Asynchronous reset active low
	request_unit_if.ru ruif
	/*
    input   i_hit,d_hit,cu_dren_out,cu_dwen_out,
    output  d_ren,d_wen
	  */
);


logic next_d_ren,next_d_wen;

assign next_d_ren = (ruif.cu_dren_out && ~ruif.d_hit);
assign next_d_wen = (ruif.cu_dwen_out && ~ruif.d_hit);

always @(posedge CLK, negedge nRST)
begin
	if (1'b0 == nRST)
	begin
		ruif.d_ren <= 0;
		ruif.d_wen <= 0;
	end
	else
	begin
		ruif.d_ren <= next_d_ren;
		ruif.d_wen <= next_d_wen;
	end
end

endmodule