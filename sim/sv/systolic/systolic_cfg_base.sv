class systolic_cfg_base;

    // Random Wishbone config
    rand wb_cfg_base wb_cfg;

    // Test timeout
    int unsigned test_timeout_cycles = 10000;

    // Create nested configs
    function new();
        wb_cfg = new();
    endfunction

    function void post_randomize();
        string str;
        str = {str, $sformatf("test_timeout_cycles: %0d\n", test_timeout_cycles)};
        $display(str);
    endfunction

endclass
