class wb_checker_base;

    // From monitor

    mailbox #(wb_packet_base) mbx;

    // Reset status

    bit in_reset;

    // Main run

    virtual task run();
        wb_packet_base tmp_p;
        forever begin
            wait(~in_reset);
            fork
                do_check();
                wait(in_reset);
            join_any
            disable fork;
            while (mbx.try_get(tmp_p)) ;
        end
    endtask

    virtual task do_check();
        wb_packet_base p;
        fork
            forever begin
                mbx.get(p);
                check(p);
            end
        join
    endtask

    virtual task check(wb_packet_base p);
        if (p.tagn_o !== 0) begin
            $error("%t Slave returned SLVERR!", $time());
            // $stop();
        end
    endtask

endclass
