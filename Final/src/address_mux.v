`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2026 10:15:14
// Design Name: 
// Module Name: address_mux
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


module address_mux #(
    parameter ADDR_WIDTH = 5
)(
    input wire sel, // selection
    input wire [ADDR_WIDTH-1:0] pc_addr, // PC +1 address
    input wire [ADDR_WIDTH-1:0] ir_addr, // jmp address
    output wire [ADDR_WIDTH-1:0] addr_out // address output
);
    // If sel == 0, next_address = jmp address
    // sel == 1, next_address = PC + 1 adrress 
    assign addr_out = (sel) ? pc_addr : ir_addr;

endmodule