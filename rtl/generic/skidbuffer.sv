module skidbuffer
#(
    parameter WORD_WIDTH = 32,
    parameter FIFO_DEPTH =  1
)
(
    // If PIPE_DEPTH is zero, these are unused
    // verilator lint_off UNUSED
    input   logic                       clock,
    input   logic                       rst_n,
    // verilator lint_on  UNUSED
    input   logic                       input_valid,
    output  logic                       input_ready,
    input   logic   [WORD_WIDTH-1:0]    input_data,

    output  logic                       output_valid,
    input   logic                       output_ready,
    output  logic   [WORD_WIDTH-1:0]    output_data
);

    assert(FIFO_DEPTH >= 0);

    // No buffer between pipeline stages
    // Sender will wait at least 2*N - 1 cycles for `ready` signal
    if (FIFO_DEPTH == 0) begin
        assign input_ready  = output_ready;
        always @(*) begin
            output_valid = input_valid;
            output_data  = input_data;
        end
    // Between pipeline stages there are muxer and FIFO
    // If FIFO is not full, then sender doesn't wait `output_ready` from next pipeline stage
    // else if FIFO is empty and `output_valid` isn't set, then data will not be placed to FIFO and `input_valid` will be set immediately
    // else if FIFO is empty, then data will be placed to FIFO
    end else begin
        wire                  valid_pipe [PIPE_DEPTH-1:0];
        wire                  ready_pipe [PIPE_DEPTH-1:0];
        wire [WORD_WIDTH-1:0] data_pipe  [PIPE_DEPTH-1:0];

        skidbuffer
        #(
            .WORD_WIDTH      (WORD_WIDTH{1'b0}),
            .CIRCULAR_BUFFER (0)
        )
        input_stage
        (
            .clock          (clock),
            .clear          (clear),

            .input_valid    (input_valid),
            .input_ready    (input_ready),
            .input_data     (input_data),

            .output_valid   (valid_pipe[0]),
            .output_ready   (ready_pipe[0]),
            .output_data    (data_pipe [0])
        );
        for (i=1; i < PIPE_DEPTH; i=i+1) begin: pipe_stages
            skidbuffer
            #(
                .WORD_WIDTH      (WORD_WIDTH),
                .CIRCULAR_BUFFER (0)            // Not meaningful here
            )
            pipe_stage
            (
                .clock          (clock),
                .clear          (clear),

                .input_valid    (valid_pipe[i-1]),
                .input_ready    (ready_pipe[i-1]),
                .input_data     (data_pipe [i-1]),

                .output_valid   (valid_pipe[i]),
                .output_ready   (ready_pipe[i]),
                .output_data    (data_pipe [i])
            );
        end
        assign ready_pipe [PIPE_DEPTH-1] = output_ready;
        always @(*) begin
            output_valid = valid_pipe[PIPE_DEPTH-1];
            output_data  = data_pipe [PIPE_DEPTH-1];
        end
    end

    initial begin
        output_valid = 1'b0;
        output_data  = WORD_ZERO;
    end

    genvar i;
    generate
        if (PIPE_DEPTH == 0) begin
            
        end
        
    endgenerate

endmodule