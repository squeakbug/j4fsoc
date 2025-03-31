`begin_keywords "1800-2023"

module wb_systolic_array
    import systolic_config_pkg::*;

#(
    parameter systolic_config_t CONF
) (
    wb_intf.slave wb
);

    // ========================
    // Wishbone interface
    // ========================
    // Wishbone response
    logic ack;
    logic [31:0] read_data;
    wire clk = wb.clk_i;
    wire rst_n = ~wb.rst_i;
    
    // Address decoding
    localparam REG_BASE = 32'hFE00;
    localparam REG_END = 32'hFF00;
    localparam MEM_BASE = 32'h0000;
    localparam MEM_END = 32'h2000;
    
    wire is_reg_access = (wb.adr >= REG_BASE) && (wb.adr < REG_END);
    wire is_mem_access = (wb.adr >= MEM_BASE) && (wb.adr < MEM_END);
    
    // Register addresses
    typedef enum logic [15:0] {
        CSR = 16'hFE00,
        DMS = 16'hFE02,
        DMR = 16'hFE04,
        PMS = 16'hFE06,
        PMR = 16'hFE08
    } reg_addr_t;
    
    // ========================
    // Inner state
    // ========================
    logic [15:0] regs [5:0];  // CSR, DMS, DMR, PMS, PMR
    
    // Memory interface
    logic mem_ce;
    logic [14:0] mem_addr;  // 32KB memory (0x0000-0x2000)
    logic [31:0] mem_din;
    logic mem_we;
    logic [3:0] mem_bwe;    // Byte write enables
    logic [31:0] mem_dout;
    
    function automatic void reset_device();
        for (int i = 0; i < 5; i++) begin
            regs[i] <= 16'b0;
        end
        ack <= 1'b0;
        read_data <= 32'b0;
        
        // Reset memory interface
        mem_ce <= 1'b0;
        mem_we <= 1'b0;
        mem_bwe <= 4'b0;
    endfunction

    // Memory instance
    ram1p1rwbe ram (
        .clk(clk),
        .ce(mem_ce),
        .addr(mem_addr),
        .din(mem_din),
        .we(mem_we),
        .bwe(mem_bwe),
        .dout(mem_dout)
    );
    
    // Array interface
    logic weights_load;
    logic [CONF.DATA_WIDTH-1:0] input_data [0:CONF.ARRAY_A_L-1];
    logic [CONF.DATA_WIDTH-1:0] weight_data [0:CONF.ARRAY_W_W-1][0:CONF.ARRAY_W_L-1];
    logic [2*CONF.DATA_WIDTH-1:0] output_data [0:CONF.ARRAY_W_L-1];

    systolic_array arr (
        .clk(clk),
        .rst_n(rst_n),
        .weights_load(weights_load),
        .input_data(input_data),
        .weight_data(weight_data),
        .output_data(output_data)
    );
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reset_device();
        end else begin
            ack <= 1'b0;
            mem_ce <= 1'b0;
            mem_we <= 1'b0;
            mem_bwe <= 4'b0;
            if (wb.cyc && wb.stb && !ack) begin
                ack <= 1'b1;
                
                if (is_reg_access) begin
                    // Register access
                    case (wb.adr[15:0])
                        CSR: begin
                            if (wb.we) begin
                                // Writing to CSR
                                regs[0] <= wb.dat_o[15:0];
                                
                                // Check for reset bit (bit 1)
                                if (wb.dat_o[1]) begin
                                    // Reset the array
                                    // Additional reset logic can be added here
                                end
                                
                                // Check for start bit (bit 0)
                                if (wb.dat_o[0]) begin
                                    // Start processing
                                    // Trigger the array operation
                                end
                            end else begin
                                // Reading CSR
                                read_data <= {16'b0, regs[0]};
                            end
                        end
                        DMS: begin
                            if (wb.we) regs[1] <= wb.dat_o[15:0];
                            else read_data <= {16'b0, regs[1]};
                        end
                        DMR: begin
                            if (wb.we) regs[2] <= wb.dat_o[15:0];
                            else read_data <= {16'b0, regs[2]};
                        end
                        PMS: begin
                            if (wb.we) regs[3] <= wb.dat_o[15:0];
                            else read_data <= {16'b0, regs[3]};
                        end
                        PMR: begin
                            if (wb.we) regs[4] <= wb.dat_o[15:0];
                            else read_data <= {16'b0, regs[4]};
                        end
                        default: begin
                            // Unimplemented register
                            if (!wb.we) read_data <= 32'b0;
                        end
                    endcase
                end else if (is_mem_access) begin
                    // Memory access
                    mem_ce <= 1'b1;
                    mem_addr <= wb.adr[14:0];
                    
                    if (wb.we) begin
                        // Memory write
                        mem_we <= 1'b1;
                        mem_bwe <= wb.sel;
                        mem_din <= wb.dat_o;
                    end else begin
                        // Memory read
                        read_data <= mem_dout;
                    end
                end
            end
        end
    end
    
    assign wb.dat_i = read_data;
    assign wb.ack = ack;
    assign wb.tagn_o = 1'b0;  // No error signaling for now
    
    // assign weights_load = (regs[0][0] && (regs[1] <= mem_addr) && (mem_addr < (regs[1] + regs[2])));
    // assign input_data = (regs[0][0] && (regs[3] <= mem_addr) && (mem_addr < (regs[3] + regs[4])));

endmodule

`end_keywords
