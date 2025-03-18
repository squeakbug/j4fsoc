`begin_keywords "1800-2023"

package opcodes_pkg;

  typedef enum logic [6:0] {
    // J-type
    OP_LUI   = 7'b0110111,
    OP_AUIPC = 7'b0010111,
    OP_JAL   = 7'b1101111,
    // B-type
    OP_JALR  = 7'b1100111,
    OP_B     = 7'b1100011,
    // S-type
    OP_S     = 7'b0100011,
    // I-type
    OP_L     = 7'b0000011,
    OP_I     = 7'b0010011,
    OP_R     = 7'b0110011
  } opcode_t;

  typedef enum logic [2:0] {
    FUNCT3_ADD  = 3'b000,
    FUNCT3_AND  = 3'b111,
    FUNCT3_BNE  = 3'b001,
    FUNCT3_OR   = 3'b110,
    FUNCT3_SRL  = 3'b101,
    FUNCT3_SLTU = 3'b011,
    FUNCT3_ANY  = 3'b???
  } funct3_t;

  typedef enum logic [6:0] {
    FUNCT7_ADD  = 7'b0000000,
    FUNCT7_SUB  = 7'b0100000,
    FUNCT7_ANY  = 7'b???????
  } funct7_t;

  typedef enum logic [5:0] {
    ALU_OP_ADD,
    ALU_OP_AND,
    ALU_OP_OR,
    ALU_OP_SRL,
    ALU_OP_SLTU,
    ALU_OP_SUB
  } alu_op_t;

endpackage : opcodes_pkg

`end_keywords
