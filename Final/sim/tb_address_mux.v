`timescale 1ns/1ps

module tb_address_mux;

parameter ADDR_WIDTH = 5;

reg sel;
reg [ADDR_WIDTH-1:0] pc_addr;
reg [ADDR_WIDTH-1:0] ir_addr;

wire [ADDR_WIDTH-1:0] addr_out;

address_mux #(
    .ADDR_WIDTH(ADDR_WIDTH)
) uut (
    .sel(sel),
    .pc_addr(pc_addr),
    .ir_addr(ir_addr),
    .addr_out(addr_out)
);

initial begin

    $display("===== ADDRESS MUX TEST =====");

    pc_addr = 5'b00101;
    ir_addr = 5'b11100;

    sel = 1'b1;
    #10;
    $display("sel=%b addr_out=%b", sel, addr_out);

    sel = 1'b0;
    #10;
    $display("sel=%b addr_out=%b", sel, addr_out);

    pc_addr = 5'b10101;
    ir_addr = 5'b01010;

    sel = 1'b1;
    #10;
    $display("sel=%b addr_out=%b", sel, addr_out);

    sel = 1'b0;
    #10;
    $display("sel=%b addr_out=%b", sel, addr_out);

    $finish;
end

endmodule