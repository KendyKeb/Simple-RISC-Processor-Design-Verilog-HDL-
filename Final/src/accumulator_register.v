`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2026 10:27:10
// Design Name: 
// Module Name: accumulator_register
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


module accumulator_register (
    input wire clk,
    input wire rst,
    input wire ld_ac,
    input wire [7:0] alu_out,

    output reg [7:0] ac_out
);

    always @(posedge clk) begin
        if (rst)
            ac_out <= 8'b00000000;
        else if (ld_ac)
            ac_out <= alu_out;
    end

endmodule