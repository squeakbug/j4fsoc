// Purpose: D flip-flop with enable and synchronous load

module flopenl #(
    parameter WIDTH = 8,
    parameter type TYPE = logic [WIDTH-1:0]
) (
    input  logic clk,
    load,
    en,
    input  TYPE  d,
    input  TYPE  val,
    output TYPE  q
);

  always_ff @(posedge clk) begin
    if (load) q <= val;
    else if (en) q <= d;
  end

endmodule
