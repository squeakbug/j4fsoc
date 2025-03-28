`begin_keywords "1800-2012"

module core_alu
  import config_pkg::*;
  import opcodes_pkg::*;

#(
    parameter config_t CONF
) (
    input  logic    [CONF.XLEN - 1:0] src_a,
    input  logic    [CONF.XLEN - 1:0] src_b,
    input  alu_op_t                   alu_op,
    output logic                      alu_zero,
    output logic    [CONF.XLEN - 1:0] alu_res
);
  always_comb begin
    unique case (alu_op)
      ALU_OP_ADD:  alu_res = src_a + src_b;
      ALU_OP_AND:  alu_res = src_a & src_b;
      ALU_OP_OR:   alu_res = src_a | src_b;
      ALU_OP_SRL:  alu_res = src_a >> src_b[4:0];
      ALU_OP_SLTU: alu_res = (src_a < src_b) ? 1 : 0;
      ALU_OP_SUB:  alu_res = src_a - src_b;
    endcase
  end

  assign alu_zero = (alu_res == 0);
endmodule

`end_keywords
