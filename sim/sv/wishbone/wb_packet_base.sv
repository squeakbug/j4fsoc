class wb_packet_base;

    rand logic [31:0]    adr;
    rand logic [31:0]  dat_o;
    rand logic [31:0]  dat_i;
    rand logic  [3:0]    sel;
    rand logic        tagn_o;
    rand logic            we;

    // Useful function for print

    virtual function string convert2string();
        string str;
        str = {str, $sformatf("adr  : %8h\n", adr  )};
        str = {str, $sformatf("dat_o: %1b\n", dat_o )};
        str = {str, $sformatf("dat_i: %8h\n", dat_i )};
        str = {str, $sformatf("sel  : %8h\n", sel )};
        str = {str, $sformatf("tagn_o  : %8h\n", tagn_o )};
        str = {str, $sformatf("we   : %1b\n", we )};
        return str;
    endfunction

endclass
