`timescale 1ns/1ps

module systolic_array #(
    parameter DATA_WIDTH = 32, // Разрядность шины входных данных
    parameter ARRAY_W = 10,    // Количество строк в массиве
    parameter ARRAY_L = 10,    // Количество столбцов в массиве
    parameter ARRAY_W_W = 4,   // Количество строк в массиве весов
    parameter ARRAY_W_L = 4,   // Количество столбцов в массиве весов
    parameter ARRAY_A_W = 4,   // Количество строк в массиве данных
    parameter ARRAY_A_L = 4    // Количество столбцов в массиве данных
) (
    input clk,
    input rst_n,

    // Signal
    input weights_load,

    // Data
    input  logic   [DATA_WIDTH-1:0]  input_data [0:ARRAY_A_L-1],
    input  logic   [DATA_WIDTH-1:0] weight_data [0:ARRAY_W_W-1][0 :ARRAY_W_L-1],
    output logic [2*DATA_WIDTH-1:0] output_data [0:ARRAY_W_L-1]
);
    wire [2*DATA_WIDTH-1:0] temp_output_data [0:ARRAY_W_L-1][0 :ARRAY_W_W-1];
    wire   [DATA_WIDTH-1:0] propagate_module [0:ARRAY_W_L-1][0 :ARRAY_W_W-1];
    wire [2*DATA_WIDTH-1:0] prop_data;
    wire [2*DATA_WIDTH-1:0] pe_input_data;

    genvar i, j;
    for (i = 0; i < ARRAY_W_L; i++) begin
        for (j = 0; j < ARRAY_W_W; j++) begin
            assign pe_input_data = (i == 0) 
                ? input_data[j] 
                : propagate_module[i-1][j];
            assign prop_data = (j == 0) 
                ? {2 * DATA_WIDTH{1'b0}} 
                : temp_output_data[i][j-1];

            systolic_pe #(
                .DATA_WIDTH(DATA_WIDTH)
            ) cell_inst (
                .clk,
                .rst_n,
                .weight_load(weights_load),
                .input_data(pe_input_data),
                .prop_data,
                .weights(weight_data[j][i]),
                .out_data(temp_output_data[i][j]),
                .prop_output(propagate_module[i][j])
            );
        end
    end

    genvar t;
    for (t = 0; t < ARRAY_W_L; t = t + 1) begin
        assign output_data[t] = temp_output_data[t][ARRAY_A_L-1];
    end

endmodule
