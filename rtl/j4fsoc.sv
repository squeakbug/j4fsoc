`begin_keywords "1800-2023"

module j4fsoc
  import config_pkg::*;

#(
    parameter config_t CONF
) (
    input logic clk,
    input logic rst_n,
    // BROM
    input logic [CONF.XLEN - 1:0] mem_data,
    output logic [CONF.XLEN - 1:0] mem_addr
);

  // Program counter
  wire [CONF.XLEN - 1:0] pc;
  wire [CONF.XLEN - 1:0] pc_branch = pc + imm_b;
  wire [CONF.XLEN - 1:0] pc_plus_xlen = pc + $clog2(CONF.XLEN);
  wire [CONF.XLEN - 1:0] pc_next = pc_src ? pc_branch : pc_next;
  flopr #(
      .WIDTH(CONF.XLEN - 1)
  ) r_pc (
      .clk,
      .reset(~rst_n),
      .d(pc_next),
      .q(pc)
  );

  // Fetch unit
  assign mem_addr = pc >> 2;
  wire [CONF.XLEN - 1:0] inst = mem_data;

  // Instruction decode unit
  wire [4:0] rd, rs1, rs2;
  wire [19:0] imm_i, imm_s, imm_b, imm_j;
  wire [11:0] imm_u;
  wire funct3;
  wire funct7;
  wire op;
  core_decoder #(
      .CONF
  ) decoder (
      .inst,
      .rd,
      .rs1,
      .rs2,
      .imm_i,
      .imm_s,
      .imm_b,
      .imm_u,
      .imm_j,
      .funct3,
      .funct7,
      .op
  );

  // Register file
  wire [CONF.XLEN - 1:0] rd0, rd1;
  wire [CONF.XLEN - 1:0] wd2 = wd_src ? imm_u : alu_res;
  core_regfile #(
      .CONF
  ) regfile (
      .clk,
      .rst_n,
      .a0 (rs1),
      .a1 (rs2),
      .a2 (rd),
      .wd2,
      .we2(reg_write),
      .rd0,
      .rd1
  );

  // Control unit
  wire pc_src, wd_src, alu_src, reg_write;
  core_controller #(
      .CONF
  ) controller (
      .op,
      .funct3,
      .funct7,
      .alu_zero,
      .pc_src,
      .reg_write,
      .alu_src,
      .wd_src,
      .alu_op
  );

  // Execute unit / ALU
  wire [CONF.XLEN - 1:0] src_b = alu_src ? imm_i : rd1;
  wire [CONF.XLEN - 1:0] alu_res;
  wire alu_zero, alu_op;
  core_alu #(
      .CONF
  ) alu (
      .src_a(rd1),
      .src_b,
      .alu_op,
      .alu_zero,
      .alu_res
  );

endmodule

`end_keywords
