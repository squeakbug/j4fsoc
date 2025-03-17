`begin_keywords "1800-2017"

package opcodes;

  typedef enum logic [6:0] {
    // J-type
    OP_LUI   = 7'b0110111,
    OP_AUIPC = 7'b0010111,
    OP_JAL   = 7'b1101111,
    // B-type
    OP_JALR  = 7'b1100111,
    OP_BEQ   = 7'b1100011,
    OP_BNE   = 7'b1100011,
    OP_BLT   = 7'b1100011,
    OP_BGE   = 7'b1100011,
    OP_BLTU  = 7'b1100011,
    // S-type
    OP_SB    = 7'b0100011,
    OP_SH    = 7'b0100011,
    OP_SW    = 7'b0100011,
    // I-type
    OP_LB    = 7'b0000011,
    OP_LH    = 7'b0000011,
    OP_LW    = 7'b0000011,
    OP_LBU   = 7'b0000011,
    OP_LHU   = 7'b0000011,
    OP_ADDI  = 7'b0010011,
    OP_SLTI  = 7'b0010011,
    OP_SLTIU = 7'b0010011,
    OP_XORI  = 7'b0010011,
    OP_ORI   = 7'b0010011,
    OP_ANDI  = 7'b0010011,
    OP_SLLI  = 7'b0010011,
    OP_SRLI  = 7'b0010011,
    OP_SRAI  = 7'b0010011,
    OP_ADD   = 7'b0110011,
    OP_SUB   = 7'b0110011,
    OP_SLL   = 7'b0110011,
    OP_SLT   = 7'b0110011,
    OP_SLTU  = 7'b0110011,
    OP_XOR   = 7'b0110011,
    OP_SRL   = 7'b0110011,
    OP_SRA   = 7'b0110011,
    OP_OR    = 7'b0110011,
    OP_AND   = 7'b0110011,
    // RV32M
    OP_MUL    = 7'b0110011,
    OP_MULH   = 7'b0110011,
    OP_MULHSU = 7'b0110011,
    OP_MULHU  = 7'b0110011,
    OP_DIV    = 7'b0110011,
    OP_DIVU   = 7'b0110011,
    OP_REM    = 7'b0110011,
    OP_REMU   = 7'b0110011
  } opcode_t;

  typedef enum logic [6:0] {
    FUNCT3_ADDI = 3'b000,
    FUNCT3_BEQ  = 3'b000,
    FUNCT3_BNE  = 3'b001,
    FUNCT3_ADD  = 3'b000,
    FUNCT3_OR   = 3'b110,
    FUNCT3_SRL  = 3'b101,
    FUNCT3_SLTU = 3'b011,
    FUNCT3_SUB  = 3'b000
  } funct3_t;

  typedef enum logic [6:0] {
    FUNCT7_ADD  = 7'b0000000,
    FUNCT7_OR   = 7'b0000000,
    FUNCT7_SRL  = 7'b0000000,
    FUNCT7_SLTU = 7'b0000000,
    FUNCT7_SUB  = 7'b0100000,
    FUNCT7_ANY  = 7'b???????
  } funct7_t;

  localparam ALU_OP_ADD_SH = 0;
  localparam ALU_OP_OR_SH = 1;
  localparam ALU_OP_SRL_SH = 2;
  localparam ALU_OP_SLTU_SH = 3;
  localparam ALU_OP_SUB_SH = 4;

  typedef enum logic [4:0] {
    ALU_OP_ADD  = 5'b1 << ALU_OP_ADD_SH,
    ALU_OP_OR   = 5'b1 << ALU_OP_OR_SH,
    ALU_OP_SRL  = 5'b1 << ALU_OP_SRL_SH,
    ALU_OP_SLTU = 5'b1 << ALU_OP_SLTU_SH,
    ALU_OP_SUB  = 5'b1 << ALU_OP_SUB_SH
  } alu_op_t;

endpackage : opcodes

module core_decoder
  import opcodes::*;

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
  assign funct3 = (inst >> 12) & ((32'b1 << 3) - 1);
  assign funct7 = (inst >> 25) & ((32'b1 << 7) - 1);
  assign op = inst & ((32'b1 << 7) - 1);

endmodule

`end_keywords
