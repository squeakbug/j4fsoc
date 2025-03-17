// Counter / Tunable clock divider

module counter #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    reset,
    en,
    output logic [WIDTH-1:0] q
);

  logic [WIDTH-1:0] qnext;

  assign qnext = q + 1;
  flopenr #(WIDTH) cntrflop (
      clk,
      reset,
      en,
      qnext,
      q
  );
endmodule
