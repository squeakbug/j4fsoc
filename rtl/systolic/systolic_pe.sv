`timescale 1ns/1ps

module systolic_pe
#(
  parameter DATA_WIDTH = 8
)
( 
    input logic clk,
    input logic rst_n,

    // Signal
    input logic weight_load,

    // Data
    input  logic [DATA_WIDTH - 1:0] input_data,
    input  logic [2*DATA_WIDTH-1:0] prop_data,
    input  logic   [DATA_WIDTH-1:0] weights, 
    output logic [2*DATA_WIDTH-1:0] out_data,
    output logic   [DATA_WIDTH-1:0] prop_output
);
    logic [DATA_WIDTH-1:0 ] weight;

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            out_data <= {2 * DATA_WIDTH{1'b0}};
            weight <= {DATA_WIDTH{1'b0}};
        end else if (weight_load) begin
            weight <= weights;
        end else begin
            out_data <= prop_data + input_data * weight;
            prop_output <= input_data;
        end
    end

endmodule
