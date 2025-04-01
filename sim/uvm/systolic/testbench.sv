`timescale 1ns/1ps

module testbench;


    //---------------------------------
    // Импорт паккейджа тестирования
    //---------------------------------

    import systolic_pkg::*;
    import systolic_config_pkg::*;


    //---------------------------------
    // Сигналы
    //---------------------------------

    logic        clk;
    logic        rst_n;


    //---------------------------------
    // Интерфейс
    //---------------------------------

    wb_intf wb_if(.clk_i(clk), .rst_i(rst_n));


    //---------------------------------
    // Модуль для тестирования
    //---------------------------------

    localparam systolic_config_t CONF = '{
        ADDR_WIDTH: 32,
        DATA_WIDTH: 32,
        ARRAY_W:    10,
        ARRAY_L:    10,
        ARRAY_W_W:   4,
        ARRAY_W_L:   4,
        ARRAY_A_W:   4,
        ARRAY_A_L:   4
    };

    wb_systolic_array #(.CONF(CONF)) DUT(wb_if);


    //---------------------------------
    // Переменные тестирования
    //---------------------------------

    // Период тактового сигнала

    parameter CLK_PERIOD = 10;


    //---------------------------------
    // Общие методы
    //---------------------------------

    // Генерация сигнала сброса
    task reset();
        rst_n <= 0;
        #(100*CLK_PERIOD);
        rst_n <= 1;
    endtask


    //---------------------------------
    // Выполнение
    //---------------------------------

    // Генерация тактового сигнала
    initial begin
        clk <= 0;
        forever begin
            #(CLK_PERIOD/2) clk <= ~clk;
        end
    end

    initial begin
        systolic_test_base test;
        test = new(wb_if);
        fork
            reset();
            test.run();
        join_none
        repeat(1000) @(posedge clk);
        // Сброс в ходе выполнения теста
        reset();
    end


endmodule
