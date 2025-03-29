class wb_master_driver_base;

    // Interface

    virtual wb_intf vif;

    // Config

    wb_cfg_base cfg;

    // Mailbox for generator connection

    mailbox #(wb_packet_base) gen2drv;

    // Transactions counter

    int unsigned trans_cnt;

    // Main run

    virtual task run();
        wb_packet_base p;
        reset_master();
        wait(vif.rst_n);
        forever begin
            fork
                forever begin
                    gen2drv.get(p);
                    drive_master(p);
                    trans_cnt += 1;
                end
            join_none
            wait(~vif.rst_n);
            disable fork;
            reset_master();
            wait(vif.rst_n);
        end
    endtask

    virtual task reset_master();
        vif.stb <= 0;
        vif.cyc <= 0;
    endtask

    virtual task drive_master(wb_packet_base p);
        int delay;
        void'(std::randomize(delay) with {
            delay inside {
                [cfg.master_delay_min:cfg.master_delay_max]
            };
        });
        repeat(delay) @(posedge vif.clk);
        // Transition start
        vif.adr     <= p.adr;
        vif.dat_o   <= p.dat_o;
        vif.we      <= p.we;
        vif.sel     <= p.sel;
        vif.stb     <= p.stb;
        vif.cyc     <= p.cyc;
        vif.tagn_o  <= p.tagn_o;
        do begin
            @(posedge vif.clk);
        end
        while( vif.ack );
        // Transition acknowledged
        vif.cyc    <= 0;
        vif.stb <= 0;
    endtask

endclass
