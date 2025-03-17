`begin_keywords "1800-2017"

module core_regfile #(
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

  logic [31:0] regs[CONF.XLEN - 1:0];

  assign rd0 = (a0 != 0) ? regs[a0] : 32'b0;  // x0 register is always 0
  assign rd1 = (a1 != 0) ? regs[a1] : 32'b0;  // x0 register is always 0

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      for (x = 0; x < 32; x = x + 1) begin
        regs[x] = 1'b0;
      end
    end  // TODO: resolve potensial read/write races
    else if (we2) regs[a2] <= wd2;
  end

endmodule

`end_keywords
