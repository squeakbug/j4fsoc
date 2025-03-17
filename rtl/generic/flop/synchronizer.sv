// Purpose: Two-stage flip-flop synchronizer

module synchronizer (
    input  logic clk,
    input  logic d,
    output logic q
);

  logic mid;

  always_ff @(posedge clk) begin
    mid <= d;
    q   <= mid;
  end
endmodule
