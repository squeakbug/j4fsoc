// Purpose: Storage and read/write access to data cache data, tag valid, dirty, and replacement.
//          Basic sram with 1 read write port.
//          When clk rises Addr and LineWriteData are sampled.
//          Following the clk edge read data is output from the sampled Addr.

module ram1p1rwbe
    
  #(parameter USE_SRAM=0, DEPTH=64, WIDTH=32, PRELOAD_ENABLED=0) (
    input logic                     clk,
    input logic                     ce,
    input logic [$clog2(DEPTH)-1:0] addr,
    input logic [WIDTH-1:0]         din,
    input logic                     we,
    input logic [(WIDTH-1)/8:0]     bwe,
    output logic [WIDTH-1:0]        dout
  );

  ///////////////////////////////////////////////////////////////////////////////
  // TRUE SRAM macro
  ///////////////////////////////////////////////////////////////////////////////

  if ((USE_SRAM == 1) & (WIDTH == 128) & (DEPTH == 64)) begin: cache_data_subarray
    genvar index;
    // 64 x 128-bit SRAM
    logic [WIDTH-1:0] BitWriteMask;
    for (index=0; index < WIDTH; index++) 
      assign BitWriteMask[index] = bwe[index/8];
    ram1p1rwbe_64x128 sram1A (.CLK(clk), .CEB(~ce), .WEB(~we),
      .A(addr), .D(din), 
      .BWEB(~BitWriteMask), .Q(dout));

  end else if ((USE_SRAM == 1) & (WIDTH == 44)  & (DEPTH == 64)) begin: rv64_cache
    genvar index;
    // 64 x 44-bit SRAM
    logic [WIDTH-1:0] BitWriteMask;
    for (index=0; index < WIDTH; index++) 
      assign BitWriteMask[index] = bwe[index/8];
    ram1p1rwbe_64x44 sram1B (.CLK(clk), .CEB(~ce), .WEB(~we),
      .A(addr), .D(din), 
      .BWEB(~BitWriteMask), .Q(dout));

  end else if ((USE_SRAM == 1) & (WIDTH == 22)  & (DEPTH == 64)) begin: rv32_cache
    genvar index;
    // 64 x 22-bit SRAM
    logic [WIDTH-1:0] BitWriteMask;
    for (index=0; index < WIDTH; index++) 
      assign BitWriteMask[index] = bwe[index/8];
    ram1p1rwbe_64x22 sram1B (.CLK(clk), .CEB(~ce), .WEB(~we),
      .A(addr), .D(din), 
      .BWEB(~BitWriteMask), .Q(dout));     
    
    ///////////////////////////////////////////////////////////////////////////////
    // READ first SRAM model
    ///////////////////////////////////////////////////////////////////////////////
  end else begin: ram
    bit [WIDTH-1:0] RAM[DEPTH-1:0];

    `ifdef VERILATOR
      import "DPI-C" function string getenvval(input string env_name);
    `endif

    initial 
      if (PRELOAD_ENABLED) begin
        if (WIDTH == 64) begin
          `ifdef VERILATOR
            // because Verilator doesn't automatically accept $WALLY from shell
            string       WALLY_DIR = getenvval("WALLY"); 
            $readmemh({WALLY_DIR,"/fpga/src/data.mem"}, RAM, 0);  // load boot RAM for FPGA
          `else
            $readmemh({"$WALLY/fpga/src/data.mem"}, RAM, 0);  // load boot RAM for FPGA
          `endif
        end else begin // put something in the RAM so it is not optimized away
          RAM[0] = 'hdeadbeaf;
        end
      end
    
    // Combinational read: register address and read after clock edge
    logic [$clog2(DEPTH)-1:0] addrd;
    flopen #($clog2(DEPTH)) adrreg(clk, ce, addr, addrd);
    assign dout = RAM[addrd];

    always @(posedge clk) begin
      if (ce & we) 
        for (integer i = 0; i < WIDTH / 8; i++) 
          if (bwe[i]) RAM[addr][i*8 +: 8] <= din[i*8 +: 8];
    end

  end

endmodule
