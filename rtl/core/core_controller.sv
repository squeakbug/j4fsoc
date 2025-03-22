`begin_keywords "1800-2012"

module core_controller
  import config_pkg::*;
  import opcodes_pkg::*;

#(
    parameter config_t CONF
) (
    input  opcode_t op,
    input  funct3_t funct3,
    input  funct7_t funct7,
    input  logic    alu_zero,   // High, when need equality check in ALU
    output logic    pc_src,     // High, when result PC will set from branch
    output logic    reg_write,  // High, when result will written to register
    output logic    alu_src,    // High, when source are immediate, otherwise from read from reg
    output logic    wd_src,     // High, when source is read from register
    output alu_op_t alu_op
);

  logic branch;
  logic cond_zero;
  assign pc_src = branch & (alu_zero == cond_zero);

  always_ff @(*) begin
    branch      = 1'b0;
    cond_zero   = 1'b0;
    reg_write   = 1'b0;
    alu_src     = 1'b0;
    wd_src      = 1'b0;
    alu_op = ALU_OP_ADD;

    unique case ({
      funct7, funct3, op
    }) inside
      {
        FUNCT7_ANY, FUNCT3_ANY, OP_LUI
      } : begin
        reg_write = 1'b1;
        wd_src = 1'b1;
      end
      {
        FUNCT7_ANY, FUNCT3_ADD, OP_B
      } : begin
        branch = 1'b1;
        cond_zero = 1'b1;
        alu_op = ALU_OP_SUB;
      end
      {
        FUNCT7_ANY, FUNCT3_BNE, OP_B
      } : begin
        branch = 1'b1;
        alu_op = ALU_OP_SUB;
      end

      {
        FUNCT7_ANY, FUNCT3_ADD, OP_I
      } : begin
        reg_write = 1'b1;
        alu_src = 1'b1;
        alu_op = ALU_OP_ADD;
      end
      {
        FUNCT7_ANY, FUNCT3_AND, OP_I
      } : begin
        reg_write = 1'b1;
        alu_src = 1'b1;
        alu_op = ALU_OP_AND;
      end
      {
        FUNCT7_ADD, FUNCT3_ADD, OP_R
      } : begin
        reg_write   = 1'b1;
        alu_op = ALU_OP_ADD;
      end
      {
        FUNCT7_ADD, FUNCT3_AND, OP_R
      } : begin
        reg_write   = 1'b1;
        alu_op = ALU_OP_AND;
      end
      {
        FUNCT7_SUB, FUNCT3_ADD, OP_R
      } : begin
        reg_write   = 1'b1;
        alu_op = ALU_OP_SUB;
      end
      {
        FUNCT7_ADD, FUNCT3_OR, OP_R
      } : begin
        reg_write   = 1'b1;
        alu_op = ALU_OP_OR;
      end
      {
        FUNCT7_ADD, FUNCT3_SRL, OP_R
      } : begin
        reg_write   = 1'b1;
        alu_op = ALU_OP_SRL;
      end
      {
        FUNCT7_ADD, FUNCT3_SLTU, OP_R
      } : begin
        reg_write   = 1'b1;
        alu_op = ALU_OP_SLTU;
      end

    endcase
  end
endmodule

`end_keywords
