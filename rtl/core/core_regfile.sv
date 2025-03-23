`begin_keywords "1800-2012"

module core_regfile 
  import config_pkg::*;

#(
    parameter config_t CONF
) (
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic [            4:0] a0,
    input  logic [            4:0] a1,
    input  logic [            4:0] a2,
    output logic [CONF.XLEN - 1:0] rd0,
    output logic [CONF.XLEN - 1:0] rd1,
    input  logic [CONF.XLEN - 1:0] wd2,
    input  logic                   we2
);

  localparam NUMREGS = CONF.E_SUPPORTED ? 16 : 32; // only 16 registers in E mode

  logic [CONF.XLEN - 1:0] regs [NUMREGS -1:0];

  assign rd0 = (a0 != 5'b0) ? regs[a0] : 'b0;  // x0 register is always 0
  assign rd1 = (a1 != 5'b0) ? regs[a1] : 'b0;  // x0 register is always 0

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) for (integer i = 0; i < NUMREGS; i++) regs[i] <= 'b0;
    else if (we2) regs[a2] <= wd2; // TODO: resolve potensial read/write races
  end

endmodule

`end_keywords
