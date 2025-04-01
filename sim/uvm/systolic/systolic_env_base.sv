class systolic_env_base;

    // APB env
    wb_env_base wb_env;

    function new();
        wb_env  = new();
    endfunction

    virtual task run();
        fork
            wb_env.run();
        join
    endtask

endclass
