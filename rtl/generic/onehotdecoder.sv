// Purpose: Bin to one hot decoder. Power of 2 only.

module onehotdecoder #(
    parameter WIDTH = 2
) (
    input  logic [WIDTH-1:0]    bin,
    output logic [2**WIDTH-1:0] decoded
);

  always_comb begin
    decoded = '0;
    decoded[bin] = 1'b1;
  end

endmodule
