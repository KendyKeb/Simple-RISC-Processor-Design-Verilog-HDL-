`timescale 1ns / 1ps
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



module tb_program_counter;

    reg clk;
    reg rst;
    reg inc_pc;
    reg ld_pc;
    reg [4:0] in_addr;
    wire [4:0] pc_out;

    program_counter uut (
        .clk(clk),
        .rst(rst),
        .inc_pc(inc_pc),
        .ld_pc(ld_pc),
        .in_addr(in_addr),
        .pc_out(pc_out)
    );

    //(10ns, 100MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        inc_pc = 0;
        ld_pc = 0;
        in_addr = 5'b00000;

        $monitor("At time %3dt: rst=%b, ld_pc=%b, inc_pc=%b, in_addr=%d | PC_OUT = %d", 
                 $time, rst, ld_pc, inc_pc, in_addr, pc_out);

        // --- Case 1: reset signal (Active-HIGH) ---
        $display("\n=== Simulation of Program Counter module ===");
        $display("\n--- Case 1: Testing Reset ---");
        rst = 1; 
        #10;
        rst = 0;
        #10;

        // --- Case 2: PC counter (Increment) ---
        $display("\n--- Case 2: Testing Increment ---");
        inc_pc = 1;
        #40;
        inc_pc = 0;
        #10;

        // --- Case 3: Kiểm tra Nạp địa chỉ bất kỳ (Load PC) ---
        $display("\n--- Case 3: Load Address ---");
        in_addr = 5'd25;
        ld_pc = 1;
        #10;
        ld_pc = 0;
        #10;

        // --- Case 4: PC count countinue ---
        $display("\n--- Case 4: Testing Increment from new address ---");
        inc_pc = 1;
        #20;
        inc_pc = 0;

        $finish;
    end

endmodule
