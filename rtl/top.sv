`begin_keywords "1800-2023"

module top
  import config_pkg::*;

(
    input logic clk,
    input logic rst_n
);

  localparam config_t CONF = '{
      XLEN: 32,
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

  j4fsoc #(
      .CONF
  ) soc (
      .clk,
      .rst_n
  );

endmodule

`end_keywords
