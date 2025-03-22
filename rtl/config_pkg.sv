`begin_keywords "1800-2012"

package config_pkg;

  typedef struct packed {
    int XLEN;

    // Peripheral Addresses
    // Peripheral memory space extends from BASE to BASE+RANGE
    logic        BOOTROM_SUPPORTED;
    logic [31:0] BOOTROM_BASE;
    logic [31:0] BOOTROM_RANGE;
    logic        BOOTROM_PRELOAD;
    logic        UART_SUPPORTED;
    logic [31:0] UART_BASE;
    logic [31:0] UART_RANGE;
    logic        PLIC_SUPPORTED;
    logic [31:0] PLIC_BASE;
    logic [31:0] PLIC_RANGE;
  } config_t;

endpackage : config_pkg

`end_keywords
