`timescale 1ns/1ps

module tb_uart_rx;

reg clk;
reg reset;
reg baud_tick;
reg rx;

wire [7:0] data_out;
wire data_valid;

uart_rx uut (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .rx(rx),
    .data_out(data_out),
    .data_valid(data_valid)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

task baud_pulse;
begin
    #20;
    baud_tick = 1;
    #10;
    baud_tick = 0;
    #30;
end
endtask

initial begin
    $dumpfile("uart_rx.vcd");
    $dumpvars(0, tb_uart_rx);
end

initial begin
    reset = 1;
    baud_tick = 0;
    rx = 1;

    #20;
    reset = 0;

    #40;

    rx = 0; baud_pulse(); // start bit

    rx = 0; baud_pulse(); // bit0
    rx = 1; baud_pulse(); // bit1
    rx = 1; baud_pulse(); // bit2
    rx = 0; baud_pulse(); // bit3
    rx = 0; baud_pulse(); // bit4
    rx = 1; baud_pulse(); // bit5
    rx = 0; baud_pulse(); // bit6
    rx = 1; baud_pulse(); // bit7

    rx = 1; baud_pulse(); // stop bit

    #100;
    $finish;
end

endmodule