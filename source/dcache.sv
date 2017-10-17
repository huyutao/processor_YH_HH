// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "diaosi_types_pkg.vh"
// cpu types
`include "cpu_types_pkg.vh"


module dcache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if.dcache dcf
);

import cpu_types_pkg::*;
import diaosi_types_pkg::*;

logic 		hit;

