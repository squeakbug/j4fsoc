class systolic_wb_gen extends wb_master_gen_base;

    virtual task gen_master();
        wb_packet_base p;
        p = create_packet();
        gen2drv.put(p);
    endtask

endclass
