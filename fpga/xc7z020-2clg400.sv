// Purpose: This is a top level for the fpga's implementation.
//          Instantiates j4fsoc, ddr3, pll, etc

// TODO: https://github.com/ZipCPU/wb2axip

module fpga_top

#(parameter logic RVVI_SYNTH_SUPPORTED = 0)
(
    input logic           default_33mhz_clk,
    input logic           resetn,
    input logic           south_reset,

    inout logic [15:0]    ddr3_dq,
    inout logic [1:0]     ddr3_dqs_n,
    inout logic [1:0]     ddr3_dqs_p,
    output logic [13:0]   ddr3_addr,
    output logic [2:0]    ddr3_ba,
    output logic          ddr3_ras_n,
    output logic          ddr3_cas_n,
    output logic          ddr3_we_n,
    output logic          ddr3_reset_n,
    output logic [0:0]    ddr3_ck_p,
    output logic [0:0]    ddr3_ck_n,
    output logic [0:0]    ddr3_cke,
    output logic [0:0]    ddr3_cs_n,
    output logic [1:0]    ddr3_dm,
    output logic [0:0]    ddr3_odt
);

endmodule
