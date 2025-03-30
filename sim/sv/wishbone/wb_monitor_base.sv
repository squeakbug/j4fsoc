class wb_monitor_base;

    virtual wb_intf vif;

    mailbox #(wb_packet_base) mbx;

    // Main run

    virtual task run();
        forever begin
            wait(vif.rst_i);
            fork
                forever begin
                    monitor_master();
                end
            join_none
            wait(~vif.rst_i);
            disable fork;
        end
    endtask

    virtual task monitor_master();
        wb_packet_base p;
        // Wait for transition start
        do begin
            @(posedge vif.clk_i);
        end
        while( ~vif.cyc );
        // Check for acknowledgement
        @(posedge vif.clk_i);
        while( vif.cyc && vif.stb ) begin
            // If got PREADY - save transaction
            p = new();
            mbx.put(p);
            break;
            @(posedge vif.clk_i);
        end
    endtask

endclass
