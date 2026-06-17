`timescale 1ns/1ps

module tb_accumulator_register;

reg clk;
reg rst;
reg ld_ac;
reg [7:0] alu_out;

wire [7:0] ac_out;

accumulator_register uut (
    .clk(clk),
    .rst(rst),
    .ld_ac(ld_ac),
    .alu_out(alu_out),
    .ac_out(ac_out)
);

always #5 clk = ~clk;

initial begin

    $display("===== ACCUMULATOR REGISTER TEST =====");

    clk = 0;
    rst = 1;
    ld_ac = 0;
    alu_out = 8'b00000000;

    #10;
    rst = 0;

    // Load value 1
    ld_ac = 1;
    alu_out = 8'h12;
    #10;

    $display("AC OUT = %h", ac_out);

    // Load value 2
    alu_out = 8'hA5;
    #10;

    $display("AC OUT = %h", ac_out);

    // Hold value
    ld_ac = 0;
    alu_out = 8'hFF;
    #10;

    $display("AC HOLD = %h", ac_out);

    // Reset
    rst = 1;
    #10;

    $display("AFTER RESET AC OUT = %h", ac_out);

    $finish;
end

endmodule