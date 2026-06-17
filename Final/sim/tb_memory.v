`timescale 1ns / 1ps

module tb_memory;

    // ── DUT ports ────────────────────────────────────────────
    reg        clk;
    reg        rd;
    reg        wr;
    reg [4:0]  addr;

    // ── Bidirectional bus handling ────────────────────────────
    // Testbench drive data_drive on bus only if (wr=1, rd=0).
    reg  [7:0] data_drive;
    wire [7:0] data;

    assign data = (wr && !rd) ? data_drive : 8'bz;

    // ── Instantiate DUT ──────────────────────────────────────
    memory uut (
        .clk  (clk),
        .rd   (rd),
        .wr   (wr),
        .addr (addr),
        .data (data)
    );

    // ── Clock generation: 10 ns period ───────────────────────
    localparam CLK_PERIOD = 10;
    initial clk = 0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    // ── Pass / Fail counters ─────────────────────────────────
    integer pass_count;
    integer fail_count;

    // ── Helper: WRITE one byte to memory ─────────────────────
    task mem_write;
        input [4:0] w_addr;
        input [7:0] w_data;
        begin
            @(negedge clk);
            addr       = w_addr;
            data_drive = w_data;
            wr = 1; rd = 0;
            @(posedge clk);
            #1;
            wr = 0;
            $display("       WRITE: addr=%02d data=%02h", w_addr, w_data);
        end
    endtask

    // ── Helper: READ and CHECK one byte ──────────────────────
    task mem_read_check;
        input [4:0]   r_addr;
        input [7:0]   exp_data;
        input integer test_id;
        begin
            @(negedge clk);
            addr = r_addr;
            rd = 1; wr = 0;
            #1;
            if (data === exp_data) begin
                $display("[PASS] Test %02d | READ  addr=%02d => data=%02h (expected %02h)",
                          test_id, r_addr, data, exp_data);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Test %02d | READ  addr=%02d => data=%02h (expected %02h)",
                          test_id, r_addr, data, exp_data);
                fail_count = fail_count + 1;
            end
            rd = 0;
        end
    endtask

    // ── Helper: CHECK bus state ───────────────────────────────
    task check_bus;
        input [7:0]   exp_val;
        input integer test_id;
        input [127:0] label;
        begin
            #1;
            if (data === exp_val) begin
                $display("[PASS] Test %02d | %s => data=%02h", test_id, label, data);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Test %02d | %s => data=%02h (expected %02h)",
                          test_id, label, data, exp_val);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // ── Stimulus ─────────────────────────────────────────────
    initial begin
        rd = 0; wr = 0; addr = 5'd0; data_drive = 8'h00;
        pass_count = 0; fail_count = 0;

        $display("============================================");
        $display("       MEMORY TESTBENCH START");
        $display("============================================");

        // ── BLOCK 1: Write then Read-Back ────────────────────
        $display("--- Block 1: Write then Read-back ---");
        mem_write(5'd0,  8'hAA);
        mem_write(5'd1,  8'hBB);
        mem_write(5'd2,  8'hCC);
        mem_write(5'd15, 8'h55);
        mem_write(5'd31, 8'hFF);

        mem_read_check(5'd0,  8'hAA, 1);
        mem_read_check(5'd1,  8'hBB, 2);
        mem_read_check(5'd2,  8'hCC, 3);
        mem_read_check(5'd15, 8'h55, 4);
        mem_read_check(5'd31, 8'hFF, 5);

        // ── BLOCK 2: Overwrite ───────────────────────────────
        $display("--- Block 2: Overwrite same address ---");
        mem_write(5'd0, 8'h12);
        mem_read_check(5'd0, 8'h12, 6);
        mem_write(5'd0, 8'hDE);
        mem_read_check(5'd0, 8'hDE, 7);

        // ── BLOCK 3: Bus idle = 8'bz khi rd=0, wr=0 ──────────
        $display("--- Block 3: Bus idle (rd=0, wr=0) ---");
        @(negedge clk);
        addr = 5'd0; rd = 0; wr = 0;
        check_bus(8'bz, 8, "rd=0 wr=0 (bus phai la high-Z)");

        // ── BLOCK 4: Simultaneous rd=wr=1 bị CHẶN ────────────
        $display("--- Block 4: Simultaneous rd=wr=1 bi chan ---");
        mem_write(5'd5, 8'hAB);
        @(negedge clk);
        addr = 5'd5; rd = 1; wr = 1; data_drive = 8'hFF;
        check_bus(8'bz, 9, "rd=1 wr=1 => bus phai la high-Z");
        rd = 0; wr = 0;
        mem_read_check(5'd5, 8'hAB, 10); // Giá trị phải vẫn là 0xAB

        // ── BLOCK 5: Fill all 32 addresses ───────────────────
        $display("--- Block 5: Fill all 32 addresses ---");
        begin : fill_loop
            integer k;
            for (k = 0; k < 32; k = k + 1)
                mem_write(k[4:0], k[7:0]);
        end

        mem_read_check(5'd0,  8'h00, 11);
        mem_read_check(5'd10, 8'h0A, 12);
        mem_read_check(5'd20, 8'h14, 13);
        mem_read_check(5'd31, 8'h1F, 14);

        $display("============================================");
        $display("  RESULTS: %0d PASSED | %0d FAILED", pass_count, fail_count);
        $display("============================================");
        $finish;
    end

endmodule