`timescale 1ns/1ps

module tb_baud_generator;

reg clk;
reg reset;
wire baud_tick;

// Instantiate the Baud Generator
baud_generator uut (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick)
);

// Clock Generation (10 ns period)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Generate VCD file for GTKWave
initial begin
    $dumpfile("baud_generator.vcd");
    $dumpvars(0, tb_baud_generator);
end

// Test Sequence
initial begin

    $display("Time\tReset\tBaud_Tick");
    $monitor("%0t\t%b\t%b", $time, reset, baud_tick);

    // Apply Reset
    reset = 1;

    #20;
    reset = 0;

    // Run simulation for some time
    #250;

    $finish;

end

endmodule