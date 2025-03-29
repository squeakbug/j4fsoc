`begin_keywords "1800-2023"

interface wb_intf #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input logic clk_i,
    input logic rst_i
);

    logic [    ADDR_WIDTH-1:0]   adr;  // Address bus
    logic [    DATA_WIDTH-1:0] dat_i;  // Data input (to master)
    logic [    DATA_WIDTH-1:0] dat_o;  // Data output (from master)
    logic                         we;  // Write enable
    logic   [DATA_WIDTH/8-1:0]   sel;  // Select signal
    logic                        stb;  // Strobe signal
    logic                        ack;  // Acknowledge signal
    logic                        cyc;  // Cycle signal
    logic                      stall;  // Stall signal
    logic                     tagn_o;  // Error signal
    logic                     tagn_i;  // Retry signal

    modport master(
        output adr, dat_o, we, sel, stb, cyc, tagn_o,
        input dat_i, ack, tagn_i, stall,
        input rst_i, clk_i
    );

    modport slave(
        output dat_i, ack, tagn_o, stall,
        input adr, dat_o, we, stb, cyc, sel,
        input rst_i, clk_i
    );

    /*
    property stall_low_after_transition_start;
        @(posedge clk_i) (cyc) && (stb) |-> ##0 stall; 
    endproperty
    assert property(stall_high_after_transition_start);

    property ack_low_after_transition_start;
        @(posedge clk_i) $raise(cyc) |=> ##0 $fall(ack); 
    endproperty
    assert property(ack_low_after_transition_start);

    property cyc_low_after_transition_acknowledge;
        @(posedge clk_i) $raise(ack) |=> ##0 ~cyc; 
    endproperty
    assert property(cyc_low_after_transition_acknowledge);

    property transition_complete_stb_low_by_master;
        @(posedge clk_i) (stb) && (!stall) |=> ##0 ~stb; 
    endproperty
    assert property(transition_complete_stb_low_by_master);
    */

endinterface

`end_keywords
