`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2026 12:49:38 PM
// Design Name: 
// Module Name: tb_risc_processor
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


module tb_risc_processor;
    // Khai báo các tín hiệu nạp vào CPU tổng
    reg clk;
    reg rst;
    wire sel, rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, data_e, halt;
    wire [4:0] pc_addr;
    wire [4:0] ir_addr;
    wire [4:0] mux_out;
    wire [2:0] opcode;
    wire [7:0] alu_out;
    wire [7:0] ac_out;
    wire is_zero;
    
    // Bus dữ liệu song hướng kết nối Memory, IR và ALU
    wire [7:0] data_bus; 

    // Gọi module Top-level CPU của bạn vào để test
    risc_processor uut (
        clk, rst, sel, rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, data_e, halt,
        pc_addr, ir_addr, mux_out, opcode, alu_out, ac_out, is_zero, data_bus
    );

    // Bộ tạo xung Clock đơn giản (Cứ sau 5ns đảo chiều clk một lần)
    always begin
        #5 clk = ~clk;
    end

    // Kịch bản chạy mô phỏng
    initial begin
        // Khởi tạo ban đầu
        clk = 0;
        rst = 1; 
        #20;     

        // NẠP CHƯƠNG TRÌNH: Cần test file nào, bạn chỉ cần sửa tên file ở đây!
        $readmemb("input4.txt", uut.u_mem.mem);

        rst = 0; // Nhả Reset để CPU bắt đầu chạy
//        $display("==========================================================");
//        $display("   BAT DAU THEO DOI QUA TRINH THUC THI LENH CUA CPU       ");
//        $display("==========================================================");
    end

    // KHỐI DISPLAY: Cứ mỗi khi FSM quay về trạng thái bắt đầu nạp lệnh mới (PC đổi),
    // Testbench sẽ check xem Opcode hiện tại là gì để in ra màn hình.
//    always @(uut.pc_addr) begin
//        // Tránh in log vô ích khi mạch đang bị Reset
//        if (!rst) begin
//            #1; // Đợi 1ns để thanh ghi Opcode kịp cập nhật ổn định từ Bus
//            case (uut.opcode)
//                3'b000: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b000 -> Lenh: HLT (Dung may)", uut.pc_addr);
//                3'b001: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b001 -> Lenh: SKZ (Nhay neu AC=0)", uut.pc_addr);
//                3'b010: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b010 -> Lenh: ADD (Cong bo nho vao AC)", uut.pc_addr);
//                3'b011: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b011 -> Lenh: AND (Va logic)", uut.pc_addr);
//                3'b100: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b100 -> Lenh: XOR (Xor logic)", uut.pc_addr);
//                3'b101: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b101 -> Lenh: LDA (Nap memory vao AC)", uut.pc_addr);
//                3'b110: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b110 -> Lenh: STO (Cat AC vao memory)", uut.pc_addr);
//                3'b111: $display("[CHUKY LENTH] PC = %0d | Opcode = 3'b111 -> Lenh: JMP (Nhay dia chi)", uut.pc_addr);
//                default: $display("[CHUKY LENTH] PC = %0d | Opcode khong hop le!", uut.pc_addr);
//            endcase
            
//            // In thêm giá trị hiện tại của thanh ghi AC để bạn dễ theo dõi kết quả tính toán đổi thay thế nào
//            $display("              -> Gia tri hien tai trong Accumulator (AC) = %d", uut.ac_out);
//            $display("----------------------------------------------------------");
//        end
//    end

//    // Log thông báo khi chân halt kích hoạt thành công
//    always @(posedge clk) begin
//        if (halt == 1'b1) begin
//            $display(">>> [THONG BAO] Chan HALT = 1. CPU da dung hoan toan! <<<");
//            $display("==========================================================");
//            $finish;
//        end
//    end
endmodule
