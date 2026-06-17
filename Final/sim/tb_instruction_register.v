`timescale 1ns/1ps

module tb_instruction_register;

reg clk;
reg rst;
reg ld_ir;
reg [7:0] data_in;

wire [2:0] opcode;
wire [4:0] operand;

instruction_register uut (
    .clk(clk),
    .rst(rst),
    .ld_ir(ld_ir),
    .data_in(data_in),
    .opcode(opcode),
    .operand(operand)
);

always #5 clk = ~clk;

initial begin

    $display("===== INSTRUCTION REGISTER TEST =====");

    clk = 0;
    rst = 1;
    ld_ir = 0;
    data_in = 8'b00000000;

    #10;
    rst = 0;

    // Load instruction 1
    ld_ir = 1;
    data_in = 8'b10111010;
    #10;

    $display("Instruction=%b Opcode=%b Operand=%b",
             data_in, opcode, operand);

    // Load instruction 2
    data_in = 8'b01000111;
    #10;

    $display("Instruction=%b Opcode=%b Operand=%b",
             data_in, opcode, operand);

    // Disable loading
    ld_ir = 0;
    data_in = 8'b11111111;
    #10;

    $display("Hold Opcode=%b Operand=%b",
             opcode, operand);

    // Reset again
    rst = 1;
    #10;

    $display("After Reset Opcode=%b Operand=%b",
             opcode, operand);

    $finish;
end

endmodule