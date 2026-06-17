//////////////////////////////////////////////////////////////////////////////////
// Company: HCMUT
// Engineer: Bùi Trần Quyền
// 
// Create Date: 05/22/2026 07:21:46 AM
// Design Name: Program Counter
// Module Name: Program Counter module
// Project Name: HDL assigment
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
    input wire clk, // input of clock
    input wire rst, // input of reset
    input wire inc_pc, // input of controller signal, 1 bit, decise PC + 1
    input wire ld_pc, // input of controller signal, 1 bit, decise load in_addr for jump fuction
    input wire [4:0] in_addr, // address of PC of jump fuction 
    output reg [4:0] pc_out // address of PC
    );
    
    always @(posedge clk) begin
        if (rst) begin
            pc_out <= 5'b00000;
        end 
        else if (ld_pc) begin
            pc_out <= in_addr;
        end 
        else if (inc_pc) begin
            pc_out <= pc_out + 1'b1;
        end
    end
    
endmodule
