`begin_keywords "1800-2012"

module brom
  import config_pkg::*;

#(
    parameter config_t CONF
) (
    input  logic [CONF.XLEN - 1:0] mem_addr,
    output logic [CONF.XLEN - 1:0] mem_data
);

  localparam ROM_SIZE = 1024;

  logic [CONF.XLEN - 1:0] rom[ROM_SIZE - 1:0];
  assign mem_data = rom[mem_addr];

  initial begin
    $readmemh("program.hex", rom);
  end

endmodule

`end_keywords
