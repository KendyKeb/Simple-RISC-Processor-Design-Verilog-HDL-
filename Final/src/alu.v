`timescale 1ns / 1ps

module alu(
    input wire [2:0] opcode,    
    input wire [7:0] inA,       
    input wire [7:0] inB,       
    output reg [7:0] alu_out,  
    output wire is_zero         
);

    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;
    
    assign is_zero = (alu_out == 8'b0) ? 1'b1 : 1'b0;
    
    always @(*) begin
        case (opcode)
            HLT: alu_out = inA;
            SKZ: alu_out = inA;
            ADD: alu_out = inA + inB;
            AND: alu_out = inA & inB;
            XOR: alu_out = inA ^ inB;
            LDA: alu_out = inB;
            STO: alu_out = inA;
            JMP: alu_out = inA;
            default: alu_out = inA;
        endcase
    end
    
endmodule
