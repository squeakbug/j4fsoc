// metastability input debouncer module

module sm_debouncer #(
    parameter SIZE = 1
) (
    input                     clk,
    input      [SIZE - 1 : 0] d,
    output reg [SIZE - 1 : 0] q
);
  reg [SIZE - 1 : 0] data;

  always @(posedge clk) begin
    data <= d;
    q    <= data;
  end

endmodule
