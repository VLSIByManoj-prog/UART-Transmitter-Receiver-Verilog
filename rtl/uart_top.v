module uart_top(
    input clk,
    input reset,
    input tx_start,
    input [7:0] data_in,

    output [7:0] data_out,
    output data_valid,
    output parity_error,
    output framing_error
);

wire baud_tick;
wire tx_wire;

baud_generator baud_gen(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

uart_tx transmitter(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx_wire),
    .busy()
);

uart_rx receiver(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .rx(tx_wire),
    .data_out(data_out),
    .data_valid(data_valid),
    .parity_error(parity_error),
    .framing_error(framing_error)
);

endmodule