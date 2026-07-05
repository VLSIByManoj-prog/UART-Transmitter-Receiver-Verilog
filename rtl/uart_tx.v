module uart_tx(
    input clk,
    input reset,
    input baud_tick,
    input tx_start,
    input [7:0] data_in,

    output reg tx,
    output reg busy
);

reg [3:0] bit_index;
reg [7:0] data_reg;
reg parity_bit;
reg [2:0] state;

parameter IDLE   = 3'b000;
parameter START  = 3'b001;
parameter DATA   = 3'b010;
parameter PARITY = 3'b011;
parameter STOP   = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx <= 1'b1;
        busy <= 1'b0;
        bit_index <= 0;
        data_reg <= 0;
        parity_bit <= 0;
        state <= IDLE;
    end
    else begin
        case (state)

        IDLE: begin
            tx <= 1'b1;
            busy <= 1'b0;

            if (tx_start) begin
                data_reg <= data_in;
                parity_bit <= ^data_in;   // even parity
                bit_index <= 0;
                busy <= 1'b1;
                state <= START;
            end
        end

        START: begin
            if (baud_tick) begin
                tx <= 1'b0;
                state <= DATA;
            end
        end

        DATA: begin
            if (baud_tick) begin
                tx <= data_reg[bit_index];

                if (bit_index == 7)
                    state <= PARITY;
                else
                    bit_index <= bit_index + 1;
            end
        end

        PARITY: begin
            if (baud_tick) begin
                tx <= parity_bit;
                state <= STOP;
            end
        end

        STOP: begin
            if (baud_tick) begin
                tx <= 1'b1;
                busy <= 1'b0;
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule