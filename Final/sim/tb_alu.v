`timescale 1ns / 1ps

module tb_alu;

    // ── DUT ports ────────────────────────────────────────────
    reg  [2:0] opcode;
    reg  [7:0] inA;
    reg  [7:0] inB;
    wire [7:0] alu_out;
    wire       is_zero;

    // ── Instantiate DUT ──────────────────────────────────────
    alu uut (
        .opcode  (opcode),
        .inA     (inA),
        .inB     (inB),
        .alu_out (alu_out),
        .is_zero (is_zero)
    );

    // ── Pass / Fail counters ─────────────────────────────────
    integer pass_count;
    integer fail_count;

    // ── Self-checking task ───────────────────────────────────
    // NOTE: is_zero checks inA == 0, NOT alu_out == 0.
    task check;
        input [63:0]  test_id;
        input [7:0]   exp_out;
        input         exp_zero;
        begin
            #1; // Allow combinational logic to settle (ALU is async)
            if ((alu_out === exp_out) && (is_zero === exp_zero)) begin
                $display("[PASS] Test %02d | op=%b inA=%02h inB=%02h => alu_out=%02h is_zero=%b",
                          test_id, opcode, inA, inB, alu_out, is_zero);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Test %02d | op=%b inA=%02h inB=%02h => alu_out=%02h(exp %02h) is_zero=%b(exp %b)",
                          test_id, opcode, inA, inB, alu_out, exp_out, is_zero, exp_zero);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // ── Stimulus ─────────────────────────────────────────────
    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("============================================");
        $display("         ALU TESTBENCH START");
        $display("============================================");

        // ── HLT (000): alu_out = inA ─────────────────────────
        $display("--- HLT (000) ---");
        opcode=3'b000; inA=8'hAB; inB=8'h12; check(1,  8'hAB, 1'b0);
        opcode=3'b000; inA=8'h00; inB=8'hFF; check(2,  8'h00, 1'b1); // inA=0 => is_zero=1
        opcode=3'b000; inA=8'hFF; inB=8'h00; check(3,  8'hFF, 1'b0);

        // ── SKZ (001): alu_out = inA ─────────────────────────
        $display("--- SKZ (001) ---");
        opcode=3'b001; inA=8'h55; inB=8'hAA; check(4,  8'h55, 1'b0);
        opcode=3'b001; inA=8'h00; inB=8'hFF; check(5,  8'h00, 1'b1); // inA=0 => is_zero=1
        opcode=3'b001; inA=8'h01; inB=8'h00; check(6,  8'h01, 1'b0);

        // ── ADD (010): alu_out = inA + inB ───────────────────
        $display("--- ADD (010) ---");
        opcode=3'b010; inA=8'h05; inB=8'h03; check(7,  8'h08, 1'b0);
        opcode=3'b010; inA=8'h00; inB=8'h00; check(8,  8'h00, 1'b1); // inA=0 => is_zero=1
        opcode=3'b010; inA=8'hFF; inB=8'h01; check(9,  8'h00, 1'b0); // overflow, but inA!=0 => is_zero=0
        opcode=3'b010; inA=8'h0F; inB=8'hF0; check(10, 8'hFF, 1'b0);
        opcode=3'b010; inA=8'h00; inB=8'hFF; check(11, 8'hFF, 1'b1); // inA=0 => is_zero=1 even if result!=0

        // ── AND (011): alu_out = inA & inB ───────────────────
        $display("--- AND (011) ---");
        opcode=3'b011; inA=8'hF0; inB=8'hFF; check(12, 8'hF0, 1'b0);
        opcode=3'b011; inA=8'hAA; inB=8'h55; check(13, 8'h00, 1'b0); // result=0 but inA!=0 => is_zero=0
        opcode=3'b011; inA=8'h00; inB=8'hFF; check(14, 8'h00, 1'b1); // inA=0 => is_zero=1
        opcode=3'b011; inA=8'hFF; inB=8'hFF; check(15, 8'hFF, 1'b0);

        // ── XOR (100): alu_out = inA ^ inB ───────────────────
        $display("--- XOR (100) ---");
        opcode=3'b100; inA=8'hFF; inB=8'hFF; check(16, 8'h00, 1'b0); // result=0, inA!=0 => is_zero=0
        opcode=3'b100; inA=8'hAA; inB=8'h55; check(17, 8'hFF, 1'b0);
        opcode=3'b100; inA=8'h00; inB=8'h00; check(18, 8'h00, 1'b1); // inA=0 => is_zero=1
        opcode=3'b100; inA=8'h5A; inB=8'hA5; check(19, 8'hFF, 1'b0);

        // ── LDA (101): alu_out = inB ─────────────────────────
        $display("--- LDA (101) ---");
        opcode=3'b101; inA=8'hDE; inB=8'h42; check(20, 8'h42, 1'b0); // output=inB, is_zero checks inA(!=0)
        opcode=3'b101; inA=8'h00; inB=8'h7F; check(21, 8'h7F, 1'b1); // inA=0 => is_zero=1 (output still inB)
        opcode=3'b101; inA=8'h01; inB=8'h00; check(22, 8'h00, 1'b0); // output=0 but inA!=0 => is_zero=0
        opcode=3'b101; inA=8'h00; inB=8'h00; check(23, 8'h00, 1'b1); // both 0, is_zero=1

        // ── STO (110): alu_out = inA ─────────────────────────
        $display("--- STO (110) ---");
        opcode=3'b110; inA=8'hBE; inB=8'hEF; check(24, 8'hBE, 1'b0);
        opcode=3'b110; inA=8'h00; inB=8'hFF; check(25, 8'h00, 1'b1); // inA=0 => is_zero=1
        opcode=3'b110; inA=8'hC3; inB=8'h00; check(26, 8'hC3, 1'b0);

        // ── JMP (111): alu_out = inA ─────────────────────────
        $display("--- JMP (111) ---");
        opcode=3'b111; inA=8'h1F; inB=8'h00; check(27, 8'h1F, 1'b0);
        opcode=3'b111; inA=8'h00; inB=8'hFF; check(28, 8'h00, 1'b1); // inA=0 => is_zero=1
        opcode=3'b111; inA=8'hAB; inB=8'hCD; check(29, 8'hAB, 1'b0);

        // ── is_zero edge cases ────────────────────────────────
        $display("--- is_zero edge cases ---");
        // Verify is_zero is purely based on inA, not alu_out
        opcode=3'b010; inA=8'h01; inB=8'hFF; check(30, 8'h00, 1'b0); // inA!=0 => is_zero=0 even though result=0
        opcode=3'b100; inA=8'hA5; inB=8'hA5; check(31, 8'h00, 1'b0); // XOR result=0, but inA!=0 => is_zero=0

        $display("============================================");
        $display("  RESULTS: %0d PASSED | %0d FAILED", pass_count, fail_count);
        $display("============================================");
        $finish;
    end

endmodule