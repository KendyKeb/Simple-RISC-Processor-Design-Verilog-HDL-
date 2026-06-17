`timescale 1ns / 1ps

module memory (
    input  wire clk, // System clock (posedge active)
    input  wire rd, // Read  enable from Controller
    input  wire wr, // Write enable from Controller
    input  wire [4:0]  addr, // Address 5-bit
    inout  wire [7:0]  data // Bus data 8-bit
);

    // Internal storage array 
    reg [7:0] mem [0:31];

    // Simulation initialize (all zeros at power-on) 
    reg [5:0] i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            mem[i] = 8'h00;
    end

    // READ path: combinational / asynchronous 
    // Drive bus only if rd=1 and wr=0.
    assign data = (rd && !wr) ? mem[addr] : 8'bz;

    // WRITE path: synchronous, posedge clk 
    // Latch data from bus only if wr=1 VÀ rd=0.
    always @(posedge clk) begin
        if (wr && !rd) begin
            mem[addr] <= data;
        end
    end

endmodule