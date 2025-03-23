`timescale 1 ns / 100 ps

module j4fsoc_tb;

  `define SIMULATION_CYCLES 50

   import config_pkg::*;
   import riscv_asm::*;

    // simulation options
    parameter Tt     = 20;

    logic              clk;
    logic            rst_n;
    logic  [ 4:0] reg_addr;

    // ***** DUT start ************************

    localparam config_t CONF = '{
      XLEN: 32,
      E_SUPPORTED: 0,
      BOOTROM_SUPPORTED: 1,
      BOOTROM_BASE: 32'h8000_0000,
      BOOTROM_RANGE: 32'h0000_1000,
      BOOTROM_PRELOAD: 1,
      UART_SUPPORTED: 1,
      UART_BASE: 32'h1000_0000,
      UART_RANGE: 32'h0000_1000,
      PLIC_SUPPORTED: 1,
      PLIC_BASE: 32'h0C00_0000,
      PLIC_RANGE: 32'h0000_1000
    };
    
    // ROM
    wire [CONF.XLEN - 1:0] mem_addr, mem_data;
    brom rom (
      .clka(clk),
      .ena(1),
      .addra(mem_addr),
      .douta(mem_data)
    );
    
    j4fsoc #(
      .CONF(CONF)
    ) soc (
      .clk,
      .rst_n,
      .mem_data,
      .mem_addr
    );

    // ***** DUT  end  ************************

    //iverilog memory dump init workaround
    initial $dumpvars;
    genvar k;
    for (k = 0; k < 32; k = k + 1) begin
        initial $dumpvars(0, soc.regfile.regs[k]);
    end

    // simulation init
    initial begin
        clk = 0;
        forever clk = #(Tt/2) ~clk;
    end

    initial begin
        rst_n   = 0;
        repeat (4)  @(posedge clk);
        rst_n   = 1;
    end

    //simulation debug output
    integer cycle; initial cycle = 0;

    always @ (posedge clk)
    begin
        $write ("%5d  pc = %2h instr = %h   a0 = %1d   addr = %h",
                  cycle, soc.pc, soc.inst, soc.regfile.regs[10], mem_addr
               );

        $write("\n");

        cycle = cycle + 1;

        if (cycle > `SIMULATION_CYCLES)
        begin
            cycle = 0;
            $display ("Timeout");
            $stop;
        end
    end

endmodule