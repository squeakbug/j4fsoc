`begin_keywords "1800-2017"

module core_brom #(
    parameter config_t CONF
) (
    input  [31:0] mem_addr,
    output [31:0] mem_data
);

  localparam ROM_SIZE = 1024;

  logic [CONF.XLEN - 1:0] rom[ROM_SIZE - 1:0];
  assign rd = rom[a];

  initial begin
    $readmemh("program.hex", rom);
  end

endmodule

`end_keywords
