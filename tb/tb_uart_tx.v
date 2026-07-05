`timescale 1ns/1ps

module tb_uart_tx;

reg clk;
reg reset;
reg baud_tick;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire busy;

// Instantiate UART Transmitter
uart_tx uut (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .busy(busy)
);

// Clock Generation (10 ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Baud Tick Generation (every 50 ns)
initial begin
    baud_tick = 0;
    forever begin
        #45 baud_tick = 1;
        #10 baud_tick = 0;
    end
end

// VCD Dump
initial begin
    $dumpfile("uart_tx.vcd");
    $dumpvars(0, tb_uart_tx);
end

// Test Sequence
initial begin

    reset = 1;
    tx_start = 0;
    data_in = 8'hA6;

    #20;
    reset = 0;

    #20;
    tx_start = 1;

    #10;
    tx_start = 0;

    #700;

    $finish;

end

endmodule