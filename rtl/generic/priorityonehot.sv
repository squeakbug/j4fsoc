// Purpose: Priority circuit producing a 1 in the output in the column where
//          the least significant 1 appears in the input.
//
//  Example:  msb           lsb
//        in  01011101010100000
//        out 00000000000100000

module priorityonehot #(
    parameter N = 8
) (
    input  logic [N-1:0] a,
    output logic [N-1:0] y
);

  genvar i;

  assign y[0] = a[0];
  for (i = 1; i < N; i++) begin : poh
    assign y[i] = a[i] & ~|a[i-1:0];
  end

endmodule
