class systolic_wb_driver extends wb_master_driver_base;

    virtual task drive_master(wb_packet_base p);
        super.drive_master(p);
        // If we read done register - put response
        gen2drv.put(p);
    endtask

endclass
