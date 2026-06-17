//////////////////////////////////////////////////////////////////////////////////
// Company: HCMUT
// Engineer: Bùi Trần Quyền
// 
// Create Date: 05/22/2026 08:35:23 AM
// Design Name: Program Counter
// Module Name: Program Counter module
// Project Name: HDL assigment
// Description: 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module controller (
    input wire clk,
    input wire rst,
    input wire [2:0] opcode,
    input wire zero,   // for SKZ opcode
    
    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg halt,
    output reg inc_pc,
    output reg ld_ac,
    output reg ld_pc,
    output reg wr,
    output reg data_e
);

    parameter INST_ADDR  = 3'b000,
              INST_FETCH = 3'b001,
              INST_LOAD  = 3'b010,
              IDLE       = 3'b011,
              OP_ADDR    = 3'b100,
              OP_FETCH   = 3'b101,
              ALU_OP     = 3'b110,
              STORE      = 3'b111;

    parameter HLT = 3'b000,
              SKZ = 3'b001,
              ADD = 3'b010,
              AND = 3'b011,
              XOR = 3'b100,
              LDA = 3'b101,
              STO = 3'b110,
              JMP = 3'b111;

    reg [2:0] current_state, next_state;

    // Chuyển giữa các states
    always @(posedge clk) begin
        if (rst) begin
            current_state <= INST_ADDR;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            INST_ADDR  : next_state = INST_FETCH; 
            INST_FETCH : next_state = INST_LOAD;
            INST_LOAD  : next_state = IDLE;
            IDLE       : next_state = OP_ADDR;
            OP_ADDR    : begin
                if (opcode == HLT) 
                    next_state = OP_ADDR; // Đứng im tại đây nếu là lệnh HLT
                else 
                    next_state = OP_FETCH;
                end
            OP_FETCH   : next_state = ALU_OP;
            ALU_OP     : next_state = STORE;
            STORE      : next_state = INST_ADDR;
            default    : next_state = INST_ADDR;
        endcase
    end

    always @(*) begin
        sel    = 0;
        rd     = 0;
        ld_ir  = 0;
        halt   = 0;
        inc_pc = 0;
        ld_ac  = 0;
        ld_pc  = 0;
        wr     = 0;
        data_e = 0;

        case (current_state)
            INST_ADDR: begin
                sel = 1;
            end

            INST_FETCH: begin
                sel = 1;
                rd  = 1;
            end

            INST_LOAD: begin
                sel   = 1;
                rd    = 1;
                ld_ir = 1;
            end

            IDLE: begin
                sel   = 1;
                rd    = 1;
                ld_ir = 1;
            end

            OP_ADDR: begin
                sel = 0;
                inc_pc = 1;
                if (opcode == HLT) halt = 1;
            end

            OP_FETCH: begin
                sel = 0;
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd = 1;
                end
            end

            ALU_OP: begin
                sel = 0;
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd = 1;
                end
                if (opcode == SKZ && zero == 1) begin
                    inc_pc = 1;
                end
                if (opcode == JMP) begin
                    ld_pc = 1;
                end
                if (opcode == STO) begin
                    data_e = 1;
                    // wr = 1; // phòng hờ
                end
            end

            STORE: begin
                sel = 0;
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd    = 1;
                    ld_ac = 1;
                end
                if (opcode == JMP) begin
                    ld_pc = 1;
                end
                if (opcode == STO) begin
                    wr     = 1;
                    data_e = 1;
                end
            end
        endcase
    end

endmodule