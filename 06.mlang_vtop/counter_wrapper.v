module counter_wrapper (
    input clk,
    input rst,
    output [6:0] counter
);

// Declare the counter module
counter count_inst(
    .clk        (clk),
    .rst        (rst),
    .counter    (counter)
);

endmodule