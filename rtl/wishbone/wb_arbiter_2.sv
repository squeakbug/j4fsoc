module wb_arbiter_2
#(
    parameter DATA_WIDTH = 32,                    // width of data bus in bits (8, 16, 32, or 64)
    parameter ADDR_WIDTH = 32,                    // width of address bus in bits
    parameter SELECT_WIDTH = (DATA_WIDTH/8),      // width of word select bus (1, 2, 4, or 8)
    parameter ARB_TYPE_ROUND_ROBIN = 0,           // select round robin arbitration
    parameter ARB_LSB_HIGH_PRIORITY = 1           // LSB priority selection
)
(
    input  wire                    clk,
    input  wire                    rst_n,

    wb_intf.master wbm0,
    wb_intf.master wbm1,

    wb_intf.slave wbs0
);

    wire [1:0] request;
    wire [1:0] grant;

    assign request[0] = wbm0_cyc_i;
    assign request[1] = wbm1_cyc_i;

    wire wbm0_sel = grant[0] & grant_valid;
    wire wbm1_sel = grant[1] & grant_valid;

    // master 0
    assign wbm0_dat_o = wbs_dat_i;
    assign wbm0_ack_o = wbs_ack_i & wbm0_sel;
    assign wbm0_err_o = wbs_err_i & wbm0_sel;
    assign wbm0_rty_o = wbs_rty_i & wbm0_sel;

    // master 1
    assign wbm1_dat_o = wbs_dat_i;
    assign wbm1_ack_o = wbs_ack_i & wbm1_sel;
    assign wbm1_err_o = wbs_err_i & wbm1_sel;
    assign wbm1_rty_o = wbs_rty_i & wbm1_sel;

    // slave
    assign wbs_adr_o = wbm0_sel ? wbm0_adr_i :
                    wbm1_sel ? wbm1_adr_i :
                    {ADDR_WIDTH{1'b0}};

    assign wbs_dat_o = wbm0_sel ? wbm0_dat_i :
                    wbm1_sel ? wbm1_dat_i :
                    {DATA_WIDTH{1'b0}};

    assign wbs_we_o = wbm0_sel ? wbm0_we_i :
                    wbm1_sel ? wbm1_we_i :
                    1'b0;

    assign wbs_sel_o = wbm0_sel ? wbm0_sel_i :
                    wbm1_sel ? wbm1_sel_i :
                    {SELECT_WIDTH{1'b0}};

    assign wbs_stb_o = wbm0_sel ? wbm0_stb_i :
                    wbm1_sel ? wbm1_stb_i :
                    1'b0;

    assign wbs_cyc_o = wbm0_sel ? 1'b1 :
                    wbm1_sel ? 1'b1 :
                    1'b0;

    // arbiter instance
    wb_arbiter #(
        .PORTS(2),
        .ARB_TYPE_ROUND_ROBIN(ARB_TYPE_ROUND_ROBIN),
        .ARB_BLOCK(1),
        .ARB_BLOCK_ACK(0),
        .ARB_LSB_HIGH_PRIORITY(ARB_LSB_HIGH_PRIORITY)
    ) arb_inst (
        .clk,
        .rst_n,
        .request,
        .acknowledge(0),
        .grant,
        .grant_valid,
        .grant_encoded(0)
    );

endmodule
