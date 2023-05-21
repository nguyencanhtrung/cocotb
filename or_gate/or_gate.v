// implementation of or gate which has 2 inputs and 1 output
module or_gate(
    input a,
    input b,
    output y
    );
    assign y = a | b;

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, or_gate);
    end
endmodule