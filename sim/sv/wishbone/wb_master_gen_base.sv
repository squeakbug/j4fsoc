class wb_master_gen_base;

    wb_cfg_base cfg;

    mailbox #(wb_packet_base) gen2drv;

    virtual task run();
        repeat(cfg.master_pkt_amount) begin
            gen_master();
        end
    endtask

    virtual task gen_master();
        wb_packet_base p;
        p = create_packet();
        if( !p.randomize() ) begin
            $error("Can't randomize packet!");
            $finish();
        end
        gen2drv.put(p);
    endtask

    virtual function wb_packet_base create_packet();
        wb_packet_base p;
        p = new();
        return p;
    endfunction

endclass
