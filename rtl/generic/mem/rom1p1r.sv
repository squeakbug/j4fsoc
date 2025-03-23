// Purpose: Single-ported ROM

`begin_keywords "1800-2012"

module rom1p1r
  import config_pkg::*;

#(parameter 
  ADDR_WIDTH = 8, 
  DATA_WIDTH = 32,
  PRELOAD_ENABLED = 0
) (
    input  logic                  clk,
    input  logic                  ce,
    input  logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] dout
);

  bit [DATA_WIDTH-1:0] ROM [(2**ADDR_WIDTH)-1:0];

  `ifdef VERILATOR
    import "DPI-C" function string getenvval(input string env_name);
  `endif

  initial begin
    if (PRELOAD_ENABLED) begin
      $readmemh({"/home/workstation/Sandbox/j4f/j4fsoc/sim/firmware/counter_text.vmem"}, ROM, 0, 32);  // load boot ROM for FPGA
    end else begin // put something in the ROM so it is not optimized away
      ROM[0] = 'hdeadbeaf;
    end
  end

  always_ff @(posedge clk) 
    if (ce) dout <= ROM[addr];

endmodule

`end_keywords
