`begin_keywords "1800-2023"

module crc16_parallel (
  input  logic clk, 
  input  logic rst_n,
  input  logic load,
  input  logic d_finish,
  input  logic [7:0] crc_in,
  output logic [7:0] crc_out
);

  logic [ 7:0] crc_out;
  logic [15:0] crc_reg;
  logic [ 1:0] count;
  logic [ 1:0] state;
  wire [15:0] next_crc_reg;

  localparam idle = 2'b00;
  localparam compute = 2'b01;
  localparam finish = 2'b10;

  assign next_crc_reg[0] = (^crc_in[7:0]) ^ (^crc_reg[15:8]);
  assign next_crc_reg[1] = (^crc_in[6:0]) ^ (^crc_reg[15:9]);
  assign next_crc_reg[2] = crc_in[7] ^ crc_in[6] ^ crc_reg[9] ^ crc_reg[8];
  assign next_crc_reg[3] = crc_in[6] ^ crc_in[5] ^ crc_reg[10] ^ crc_reg[9];
  assign next_crc_reg[4] = crc_in[5] ^ crc_in[4] ^ crc_reg[11] ^ crc_reg[10];
  assign next_crc_reg[5] = crc_in[4] ^ crc_in[3] ^ crc_reg[12] ^ crc_reg[11];
  assign next_crc_reg[6] = crc_in[3] ^ crc_in[2] ^ crc_reg[13] ^ crc_reg[12];
  assign next_crc_reg[7] = crc_in[2] ^ crc_in[1] ^ crc_reg[14] ^ crc_reg[13];
  assign next_crc_reg[8] = crc_in[1] ^ crc_in[0] ^ crc_reg[15] ^ crc_reg[14] ^ crc_reg[0];
  assign next_crc_reg[9] = crc_in[0] ^ crc_reg[15] ^ crc_reg[1];
  assign next_crc_reg[14:10] = crc_reg[6:2];
  assign next_crc_reg[15] = (^crc_in[7:0]) ^ (^crc_reg[15:7]);

  always_ff @(posedge clk) begin
    case (state)
      idle: begin
        if (load) state <= compute;
        else state <= idle;
      end

      compute: begin
        if (d_finish) state <= finish;
        else state <= compute;
      end

      finish: begin
        if (count === 2) state <= idle;
        else state <= finish;
      end
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      crc_reg[15:0] <= 16'b0000_0000_0000_0000;
      state <= idle;
      count <= 2'b00;
    end else
      case (state)
        idle: begin
          crc_reg[15:0] <= 16'b0000_0000_0000_0000;
        end

        compute: begin
          crc_reg[15:0] <= next_crc_reg[15:0];
          crc_out[7:0]  <= crc_in[7:0];
        end

        finish: begin
          crc_reg[15:0] <= {crc_reg[7:0], 8'b0000_0000};
          crc_out[7:0]  <= crc_reg[15:8];
        end
      endcase
  end

endmodule

`end_keywords
