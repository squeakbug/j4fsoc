// Purpose: This is a top level for the fpga's implementation.
//          Instantiates j4fsoc, ddr3, pll, etc

// TODO: https://github.com/ZipCPU/wb2axip

module fpga_top

import config_pkg::*;

#(parameter logic RVVI_SYNTH_SUPPORTED = 0)
(
    input logic           default_33mhz_clk,
    input logic           rst_n,

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

  localparam config_t CONF = '{
    XLEN: 32,
    E_SUPPORTED: 0,
    BOOTROM_SUPPORTED: 1,
    BOOTROM_BASE: 32'h8000_0000,
    BOOTROM_RANGE: 32'h0000_1000,
    BOOTROM_PRELOAD: 1,
    UART_SUPPORTED: 1,
    UART_BASE: 32'h1000_0000,
    UART_RANGE: 32'h0000_1000,
    PLIC_SUPPORTED: 1,
    PLIC_BASE: 32'h0C00_0000,
    PLIC_RANGE: 32'h0000_1000
  };

  // ROM
  wire [CONF.XLEN - 1:0] mem_addr, mem_data;
  rom1p1r #(
    .DATA_WIDTH(64),
    .PRELOAD_ENABLED(1)
  ) brom (
    .clk,
    .ce(1),
    .addr(mem_addr),
    .dout(mem_data)
  );

  j4fsoc #(
    .CONF(CONF)
  ) soc (
    .clk(default_33mhz_clk),
    .rst_n,
    .mem_data,
    .mem_addr
  );

endmodule
