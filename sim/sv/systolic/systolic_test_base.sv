class systolic_test_base;

    // Interfaces

    virtual wb_intf  wb_vif;

    // Main configuration

    systolic_cfg_base cfg;

    // Environment

    systolic_env_base env;

    // Mailboxes for connection

    mailbox#(wb_packet_base ) wb_gen2drv;
    mailbox#(wb_packet_base)  wb_mon2scb;


    function new (
        virtual wb_intf  wb_vif
    );
        // Получение интерфейсов
        this.wb_vif  = wb_vif;
        // Создание
        cfg           = new();
        env           = new();
        wb_gen2drv   = new();
        wb_mon2scb   = new();
        // Конфигурация
        if( !cfg.randomize() ) begin
            $error("Can't randomize test configuration!");
            $finish();
        end
        env.wb_env.master.master_gen.cfg         = cfg.wb_cfg;
        env.wb_env.master.master_driver.cfg      = cfg.wb_cfg;
        // Подключение
        env.wb_env.master.master_gen.gen2drv     = wb_gen2drv;
        env.wb_env.master.master_driver.gen2drv  = wb_gen2drv;
        env.wb_env.master.master_monitor.mbx     = wb_mon2scb;
        env.wb_env.check.mbx                     = wb_mon2scb;
        // Проброс интерфейса
        env.wb_env.master.master_driver.vif      = this.wb_vif;
        env.wb_env.master.master_monitor.vif     = this.wb_vif;
    endfunction

    virtual task run();
        fork
            fork
                env.run();
                // Запуск генераторов совместно
                env.wb_env.master.master_gen.run();
            join
            timeout();
        join_any
        $display("Test was finished!");
        $finish();
    endtask

    // Таймаут теста
    task timeout();
        $error("Test timeout!");
    endtask

endclass
