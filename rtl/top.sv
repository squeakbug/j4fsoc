`begin_keywords "1800-2017"

package config_pkg

typedef struct packed {
  int           XLEN;

  // Peripheral Addresses
  // Peripheral memory space extends from BASE to BASE+RANGE
  logic         BOOTROM_SUPPORTED;
  logic [32:0]  BOOTROM_BASE;
  logic [32:0]  BOOTROM_RANGE;
  logic         BOOTROM_PRELOAD;
  logic         UART_SUPPORTED;
  logic [32:0]  UART_BASE;
  logic [32:0]  UART_RANGE;
  logic         PLIC_SUPPORTED;
  logic [32:0]  PLIC_BASE;
  logic [32:0]  PLIC_RANGE;
} config_t;

endpackage

module top
  import config_pkg::*;

  ( input logic clk
  , input logic rst_n
  );

  localparam config_t CONF = '{
    XLEN:            32,
    BOOTROM_SUPPORTED: 1,
    BOOTROM_BASE:    32'h8000_0000,
    BOOTROM_RANGE:   32'h0000_1000,
    BOOTROM_PRELOAD:  1,
    UART_SUPPORTED:   1,
    UART_BASE:       32'h1000_0000,
    UART_RANGE:      32'h0000_1000,
    PLIC_SUPPORTED:   1,
    PLIC_BASE:       32'h0C00_0000,
    PLIC_RANGE:      32'h0000_1000
  };

  // Program counter
  wire [CONF.XLEN - 1:0] pc;
  wire [CONF.XLEN - 1:0] pc_branch = pc + imm_b;
  wire [CONF.XLEN - 1:0] pc_plus_xlen  = pc + $clog2(CONF.XLEN);
  wire [CONF.XLEN - 1:0] pc_next  = pc_src ? pc_branch : pc_next;
  flopr #(.WIDTH(CONF.XLEN - 1)) r_pc (
    .clk, .rst_n, .pc_next, .pc
  );

  // Fetch unit
  assign mem_addr = pc >> 2;
  wire [CONF.XLEN - 1:0] inst = mem_data;

  // Instruction decode unit
  wire logic [4:0] rd, rs1, rs2;
  wire logic [19:0] imm_i, imm_s, imm_b, imm_j;
  wire logic [11:0] imm_u;
  wire funct3_t [2:0] funct3;
  wire funct7_t [6:0] funct7;
  core_decoder #(.CONF) decoder (
    .inst, 
    .rd, .rs1, .rs2, .imm_i, .imm_s, .imm_b, .imm_u, .imm_j, .funct3, .funct7
  );

  // Register file
  wire [CONF.XLEN - 1:0] rd0;
  wire [CONF.XLEN - 1:0] rd1;
  wire [CONF.XLEN - 1:0] wd2 = wd_src ? imm_u : alu_res;
  core_regfile #(.CONF) regfile (
    .clk, .rst_n,
    .a0(rs1), .a1(rs2), .a2(rd), .wd2, .we2(reg_write),
    .rd0, .rd1,
  );

  // Control unit
  core_controller #(.CONF) controller (
    .op, .funct3, .funct7, alu_zero,
    .pc_src, .reg_write, .alu_src, .wd_src, .alu_op
  );

  // Execute unit / ALU
  wire [CONF.XLEN - 1:0] src_b = alu_src ? imm_i : rd2;
  wire [CONF.XLEN - 1:0] alu_res;
  core_alu #(.CONF) alu (
    .src_a(rd1), .src_b, .alu_op, 
    .alu_zero, .alu_res
  );

  // ROM
  wire [CONF.XLEN - 1:0] mem_addr, mem_data;
  core_brom #(.CONF) brom (.mem_addr, .mem_data);

endmodule

`end_keywords
