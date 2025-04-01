class wb_env_base;

    wb_master_agent_base master;
    wb_checker_base      check;

    function new();
        master = new();
        check  = new();
    endfunction

    virtual task run();
        fork
            master.run();
            check .run();
        join
    endtask

endclass
