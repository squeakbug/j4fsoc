`begin_keywords "1800-2023"

interface wb #(
    parameter ADDR_WIDTH = 32
    , DATA_WIDTH = 32
) (
    input rst_i,
    input clk_i
);

  logic [    ADDR_WIDTH-1:0] adr;  // Address bus
  logic [    DATA_WIDTH-1:0] dat_i;  // Data input (to master)
  logic [    DATA_WIDTH-1:0] dat_o;  // Data output (from master)
  logic                      we;  // Write enable
  logic [$clog2(DATA_WIDTH)] sel;  // Select signal
  logic                      stb;  // Strobe signal
  logic                      ack;  // Acknowledge signal
  logic                      cyc;  // Cycle signal
  logic                      tagn_o;  // Error signal
  logic                      tagn_i;  // Retry signal

  modport master(
      output adr, dat_o, we, sel, stb, cyc, tagn_o,
      input dat_i, ack, tagn_i,
      input rst_i, clk_i
  );

  modport slave(output dat_o, ack, tagn_o, input addr, data_out, we, stb, cyc, input rst_i, clk_i);

endinterface

`end_keywords
