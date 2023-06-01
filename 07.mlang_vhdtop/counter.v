module counter (
    input clk,
    input rst,
    output [6:0] count
    );

    reg [6:0] counter_int;

    always @(posedge clk)
    begin
        if (rst)
            counter_int <= 0;
        else
            counter_int <= counter_int + 1;
    end

    assign count = counter_int;
endmodule 