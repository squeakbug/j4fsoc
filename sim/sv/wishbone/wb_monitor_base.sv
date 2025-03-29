class wb_monitor_base;

    virtual wb_intf vif;

    mailbox #(wb_packet_base) mbx;

    // Main run

    virtual task run();
        forever begin
            wait(vif.rst_n);
            fork
                forever begin
                    monitor_master();
                end
            join_none
            wait(~vif.rst_n);
            disable fork;
        end
    endtask

    virtual task monitor_master();
        wb_packet_base p;
        // Wait for transition start
        do begin
            @(posedge vif.clk);
        end
        while( ~vif.cyc );
        // Check for acknowledgement
        @(posedge vif.clk);
        while( vif.cyc && vif.stb ) begin
            // If got PREADY - save transaction
            if( vif.pready ) begin
                p = new();
                mbx.put(p);
                break;
            end
            @(posedge vif.clk);
        end
    endtask

endclass
