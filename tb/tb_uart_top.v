`timescale 1ns/1ps

module tb_uart_top;

reg clk;
reg reset;
reg tx_start;
reg [7:0] data_in;

wire [7:0] data_out;
wire data_valid;
wire parity_error;
wire framing_error;

// Instantiate UART Top
uart_top uut (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .data_in(data_in),
    .data_out(data_out),
    .data_valid(data_valid),
    .parity_error(parity_error),
    .framing_error(framing_error)
);

// Clock Generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Generate VCD
initial begin
    $dumpfile("uart_top.vcd");
    $dumpvars(0, tb_uart_top);
end

// Test Sequence
initial begin

    reset = 1;
    tx_start = 0;
    data_in = 8'hA6;

    #20;
    reset = 0;

    #30;
    tx_start = 1;

    #10;
    tx_start = 0;

    // Wait for complete transmission and reception
    #1600;

    $finish;

end

endmodule