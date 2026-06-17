`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 01:34:19 PM
// Design Name: 
// Module Name: risc_processor
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


module risc_processor(
    input wire clk,
    input wire rst, 
    output wire sel, rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, data_e, halt,
    output wire [4:0] pc_addr,
    output wire [4:0] ir_addr,
    output wire [4:0] mux_out,
    output wire [2:0] opcode,
    output wire [7:0] alu_out,
    output wire [7:0] ac_out,
    output wire is_zero,
    
    // Bus dữ liệu song hướng kết nối Memory, IR và ALU
    output wire [7:0] data_bus 
    );
    
    // 1. Khai báo các đường dây nội bộ (Internal Wires) để nối các khối
//    wire sel, rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, data_e, halt;
//    wire [4:0] pc_addr;
//    wire [4:0] ir_addr;
//    wire [4:0] mux_out;
//    wire [2:0] opcode;
//    wire [7:0] alu_out;
//    wire [7:0] ac_out;
//    wire is_zero;
    
//    // Bus dữ liệu song hướng kết nối Memory, IR và ALU
//    wire [7:0] data_bus; 

    // 2. Gọi và nối dây cho từng Module con (Kịch bản hộp đen)
    
    // Khối của Thành viên C
    program_counter u_pc (
        .clk(clk), .rst(rst), .inc_pc(inc_pc), .ld_pc(ld_pc),
        .in_addr(ir_addr), .pc_out(pc_addr)
    );

    // Khối của Thành viên A
    address_mux u_mux (
        .sel(sel), .pc_addr(pc_addr), .ir_addr(ir_addr), .addr_out(mux_out)
    );

    // Khối của Thành viên B
    memory u_mem (
        .clk(clk), .rd(rd), .wr(wr), .addr(mux_out), .data(data_bus)
    );

    // Khối của Thành viên A
    instruction_register u_ir (
        .clk(clk), .rst(rst), .ld_ir(ld_ir), .data_in(data_bus),
        .opcode(opcode), .operand(ir_addr)
    );

    // Khối của Thành viên A
    accumulator_register u_ac (
        .clk(clk), .rst(rst), .ld_ac(ld_ac), .alu_out(alu_out), .ac_out(ac_out)
    );

    // Khối của Thành viên B
    alu u_alu (
        .opcode(opcode), .inA(ac_out), .inB(data_bus),
        .alu_out(alu_out), .is_zero(is_zero)
    );

    // Khối của Thành viên C
    controller u_controller (
        .clk(clk), .rst(rst), .opcode(opcode), .zero(is_zero),
        .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt),
        .inc_pc(inc_pc), .ld_ac(ld_ac), .ld_pc(ld_pc), .wr(wr), .data_e(data_e)
    );

    // 3. Xử lý logic lái Bus song hướng (Tri-state buffer cho Memory)
    // Khi ghi (wr=1 và data_e=1), ALU hoặc AC sẽ lái bus. Khi đọc, Memory lái bus (hi-Z)
    assign data_bus = (data_e) ? alu_out : 8'bz;

endmodule
