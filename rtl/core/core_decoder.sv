`begin_keywords "1800-2012"

module core_decoder
  import config_pkg::*;
  import opcodes_pkg::*;

#(
    parameter config_t CONF
) (
    input  wire     [CONF.XLEN - 1:0] inst,
    output wire     [            4:0] rd,
    output wire     [            4:0] rs1,
    output wire     [            4:0] rs2,
    output wire     [           11:0] imm_i,
    output wire     [           11:0] imm_s,
    output wire     [           11:0] imm_b,
    output wire     [           19:0] imm_u,
    output wire     [           11:0] imm_j,
    output funct3_t                   funct3,
    output funct7_t                   funct7,
    output opcode_t                   op
);

  assign rd = (inst >> 7) & 'h1f;
  assign rs1 = (inst >> 15) & 'h1f;
  assign rs2 = (inst >> 20) & 'h1f;
  assign imm_i = inst[31:20] | ((inst[19] == 1) & 'hffff);
  assign imm_s = inst[31:25] | ((inst[20] == 1) & 'hffff);
  assign imm_b = inst[31:25] | ((inst[30] == 1) & 'hffff) | ((inst[21] == 1) & 'h1f);
  assign imm_u = inst[31:12] | ((inst[30] == 1) & 'hffff);
  assign imm_j = inst[31:21] 
    | ((inst[20] == 1) & 'hffff) 
    | ((inst[21] == 1) & 'h1f) 
    | ((inst[30] == 1) & 'h1f);
  assign funct3 = funct3_t'((inst >> 12) & ((32'b1 << 3) - 1));
  assign funct7 = funct7_t'((inst >> 25) & ((32'b1 << 7) - 1));
  assign op = opcode_t'(inst & ((32'b1 << 7) - 1));

endmodule

`end_keywords
