module Clk_Divisor_4 (
    input clk, 
    output out
);
    reg  [1:0] num;
    wire [1:0] next_num;

    always @(posedge clk) num <= next_num;

    assign next_num = num + 1'b1;
    assign out = num[1];
endmodule
