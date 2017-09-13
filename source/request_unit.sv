
`include "request_unit_if.vh"

module request_unit (
	input CLK,    // Clock
	input nRST,  // Asynchronous reset active low
	request_unit_if.ru ruif
	/*
    input   i_hit,d_hit,cu_dren_out,cu_dwen_out,
    output  d_ren,d_wen
	  */
);



always @(posedge CLK, negedge nRST)
begin
	if (1'b0 == nRST || ruif.d_hit == 1)
	begin
		ruif.d_ren <= 0;
		ruif.d_wen <= 0;
	end
	else
	begin
		if (ruif.i_hit)
		begin
			ruif.d_ren <= ruif.cu_dren_out;
			ruif.d_wen <= ruif.cu_dwen_out;
		end
	end
end


endmodule