/* -------------------------------------------
* Author:   Nguyen Canh Trung
* Email:    trungnc@soc.one
* Date:     2023-05-16 16:48:36
* Filename: counter
* Last Modified by:     Nguyen Canh Trung
* Last Modified time:   2023-05-16 16:48:36
* --------------------------------------------*/
module count_up(
    clk, 
    reset, 
    count
);

input clk; 
input reset; 
output [3:0] count; 
reg [3:0] counter; 

always @(posedge clk)
begin
    if(reset) 
        counter <= 0;
    else 
        counter <= counter + 1; 
end
    
assign count = counter;

// Dump waves
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, count_up);
end
endmodule