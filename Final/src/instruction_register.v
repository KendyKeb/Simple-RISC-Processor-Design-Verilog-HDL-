`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2026 10:23:50
// Design Name: 
// Module Name: instruction_register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_register (
    input wire clk, // System clock (posedge active)
    input wire rst, // input of reset
    input wire ld_ir, // Load data enable from the bus data to IR from Controller
    input wire [7:0] data_in, // Data from memory

    output reg [2:0] opcode,
    output reg [4:0] operand
);

    always @(posedge clk) begin
        if (rst) begin
            opcode  <= 3'b000;
            operand <= 5'b00000;
        end
        else if (ld_ir) begin
            opcode  <= data_in[7:5];
            operand <= data_in[4:0];
        end
    end

endmodule