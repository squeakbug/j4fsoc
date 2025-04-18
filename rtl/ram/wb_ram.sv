/*
 * Wishbone RAM
 */
module wb_ram #
(
    parameter DATA_WIDTH = 32,              // width of data bus in bits (8, 16, 32, or 64)
    parameter ADDR_WIDTH = 16,              // width of address bus in bits
    parameter SELECT_WIDTH = (DATA_WIDTH/8) // width of word select bus (1, 2, 4, or 8)
)
(
    wb_intf.slave wb
);

    // for interfaces that are more than one word wide, disable address lines
    parameter VALID_ADDR_WIDTH = ADDR_WIDTH - $clog2(SELECT_WIDTH);
    // width of data port in words (1, 2, 4, or 8)
    parameter WORD_WIDTH = SELECT_WIDTH;
    // size of words (8, 16, 32, or 64 bits)
    parameter WORD_SIZE = DATA_WIDTH/WORD_WIDTH;

    reg [DATA_WIDTH-1:0] dat_o_reg = {DATA_WIDTH{1'b0}};
    reg ack_o_reg = 1'b0;

    // (* RAM_STYLE="BLOCK" *)
    reg [DATA_WIDTH-1:0] mem[(2**VALID_ADDR_WIDTH)-1:0];

    wire [VALID_ADDR_WIDTH-1:0] adr_i_valid = adr_i >> (ADDR_WIDTH - VALID_ADDR_WIDTH);

    assign dat_o = dat_o_reg;
    assign ack_o = ack_o_reg;

    integer i, j;

    initial begin
        // two nested loops for smaller number of iterations per loop
        // workaround for synthesizer complaints about large loop counts
        for (i = 0; i < 2**VALID_ADDR_WIDTH; i = i + 2**(VALID_ADDR_WIDTH/2)) begin
            for (j = i; j < i + 2**(VALID_ADDR_WIDTH/2); j = j + 1) begin
                mem[j] = 0;
            end
        end
    end

    always @(posedge clk) begin
        ack_o_reg <= 1'b0;
        for (i = 0; i < WORD_WIDTH; i = i + 1) begin
            if (cyc_i & stb_i & ~ack_o) begin
                if (we_i & sel_i[i]) begin
                    mem[adr_i_valid][WORD_SIZE*i +: WORD_SIZE] <= dat_i[WORD_SIZE*i +: WORD_SIZE];
                end
                dat_o_reg[WORD_SIZE*i +: WORD_SIZE] <= mem[adr_i_valid][WORD_SIZE*i +: WORD_SIZE];
                ack_o_reg <= 1'b1;
            end
        end
    end

endmodule