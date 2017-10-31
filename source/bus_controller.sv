// interfaces
`include "cache_control_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"


module bus_controller (
	cache_control_if ccif,
	input logic CLK, nRST
	/*
	icaches
	in iwait, iload
	out iren, iaddr

	dcaches
	in dwait, dload, 
	incc ccinv, ccsnoper
	out dren, dwen, dstore, daddr
	outcc ccwrite, cctrans

	ram 
	in ramstore, ramaddr, ramWEN, ramREN
	out ramload, ramstate
	*/
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;




endmodule