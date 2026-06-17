`timescale 1ns/1ps

module tb_controller;

    // Khai báo các cổng kết nối ngõ vào (reg) và ngõ ra (wire)
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg zero;

    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;

    // Gọi module Controller vào kiểm thử (UUT)
    controller uut (
        .clk(clk), .rst(rst), .opcode(opcode), .zero(zero),
        .sel(sel), .rd(rd), .ld_ir(ld_ir), .halt(halt),
        .inc_pc(inc_pc), .ld_ac(ld_ac), .ld_pc(ld_pc), .wr(wr), .data_e(data_e)
    );

    // Tạo xung nhịp clock hệ thống chu kỳ 10ns
    always #5 clk = ~clk;

    initial begin
        // 1. Khởi tạo giá trị ban đầu
        clk = 0;
        rst = 0;
        opcode = 3'b000;
        zero = 0;

        // Định dạng in màn hình Console cho gọn gàng, trực quan
        $monitor("Time:%3dt | State=%d | Op=%b | sel=%b rd=%b ld_ir=%b inc_pc=%b ld_ac=%b ld_pc=%b wr=%b halt=%b", 
                 $time, uut.current_state, opcode, sel, rd, ld_ir, inc_pc, ld_ac, ld_pc, wr, halt);

        // 2. Kích hoạt Reset hệ thống (Chu kỳ INST_ADDR) [cite: 105]
        $display("\n--- TESTCASE 1: System Reset ---");
        rst = 1;
        #10;
        rst = 0;
        #10;

        // 3. Test thử lệnh ADD (Opcode: 010) [cite: 93]
        // Xem mạch chạy đủ 8 trạng thái từ INST_ADDR (0) -> STORE (7)
        $display("\n--- TESTCASE 2: Simulating ADD Instruction (Opcode 010) ---");
        opcode = 3'b010; 
        #80; // Chờ 8 chu kỳ clock (8 * 10ns) để đi hết 1 vòng FSM 

        // 4. Test thử lệnh rẽ nhánh SKZ (Opcode: 001) khi cờ dữ liệu ZERO = 1 [cite: 93]
        // Tại trạng thái ALU_OP (State 6), tín hiệu inc_pc bắt buộc phải nhảy lên 1 thêm một lần nữa 
        $display("\n--- TESTCASE 3: Simulating SKZ Instruction (Opcode 001) with ZERO=1 ---");
        opcode = 3'b001;
        zero = 1;
        #80;

        // 5. Test thử lệnh ghi dữ liệu STO (Opcode: 110) [cite: 93]
        // Tại trạng thái ALU_OP và STORE, chân wr và data_e sẽ phải nhảy lên 1 
        $display("\n--- TESTCASE 4: Simulating STO Instruction (Opcode 110) ---");
        opcode = 3'b110;
        zero = 0;
        #80;

        // 6. Test thử lệnh dừng hệ thống HLT (Opcode: 000) [cite: 93]
        // Tại trạng thái OP_ADDR (State 4), chân halt phải bật lên 1 để dừng mạch [cite: 53, 107]
        $display("\n--- TESTCASE 5: Simulating HLT Instruction (Opcode 000) ---");
        opcode = 3'b000;
        #40; // Chỉ cần chạy tới trạng thái số 4 là thấy chân halt lên 1 

        $display("\n--- All Controller Tests Finished ---");
        $finish;
    end

endmodule