module uart_rx(
    input clk,
    input reset,
    input baud_tick,
    input rx,

    output reg [7:0] data_out,
    output reg data_valid,
    output reg parity_error,
    output reg framing_error
);

reg [3:0] bit_index;
reg [7:0] data_reg;
reg [2:0] state;

parameter IDLE   = 3'b000;
parameter START  = 3'b001;
parameter DATA   = 3'b010;
parameter PARITY = 3'b011;
parameter STOP   = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_index <= 0;
        data_reg <= 0;
        data_out <= 0;
        data_valid <= 0;
        parity_error <= 0;
        framing_error <= 0;
        state <= IDLE;
    end
    else begin
        data_valid <= 0;

        case(state)

        IDLE: begin
            parity_error <= 0;
            framing_error <= 0;

            if (rx == 0)
                state <= START;
        end

        START: begin
            if (baud_tick) begin
                bit_index <= 0;
                state <= DATA;
            end
        end

        DATA: begin
            if (baud_tick) begin
                data_reg[bit_index] <= rx;

                if (bit_index == 7)
                    state <= PARITY;
                else
                    bit_index <= bit_index + 1;
            end
        end

        PARITY: begin
            if (baud_tick) begin
                if (rx != ^data_reg)
                    parity_error <= 1;
                else
                    parity_error <= 0;

                state <= STOP;
            end
        end

        STOP: begin
            if (baud_tick) begin
                if (rx != 1'b1) begin
                    framing_error <= 1;
                    data_valid <= 0;
                end
                else if (parity_error == 0) begin
                    data_out <= data_reg;
                    data_valid <= 1;
                end

                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule