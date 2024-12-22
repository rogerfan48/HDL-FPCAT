module Clk_Divisor_4 (
    input clk,
    output out
);
    reg [1:0] num;
    wire [1:0] next_num;

    always @(posedge clk) num <= next_num;
    assign next_num = num + 1'b1;
    assign out = num[1];
endmodule

module Clk_Divisor_6 (
    input clk,
    input clk_25MHz,
    input clk_frame,
    output out
);
    reg  [3:0] num;
    wire [3:0] next_num;

    wire clk_frame_db, clk_frame_op;
    Debounce DB_clk_frame (clk, clk_frame, clk_frame_db);
    One_Palse OP_clk_frame (clk_25MHz, clk_frame_db, clk_frame_op);
    
    always @(posedge clk_25MHz) begin
        if (clk_frame_op) num <= next_num;
    end
    
    assign next_num = ((num == 4'd8) ? 4'd0: num + 1'b1);
    assign out = (num == 4'd8);
endmodule

module Debounce(clk, pb, pb_d);
    input clk, pb;
    output pb_d;
    reg [8-1:0] DFF;

    assign pb_d = &DFF;
    always @(posedge clk) DFF[7:0] <= {DFF[6:0], pb};
endmodule

module One_Palse (clk, pb_d, pb_1p);
    input clk, pb_d;
    output reg pb_1p;

    reg pb_delay;
    always @(posedge clk) pb_delay <= pb_d;
    always @(posedge clk) pb_1p <= pb_d & ~pb_delay;
endmodule

module Priority_Encoder_8x3 (
    input [7:0] in,
    output reg [2:0] out
);

    always @(*) begin
        casex (in)
            8'bxxxxxxx1: out = 3'b000;
            8'bxxxxxx10: out = 3'b001;
            8'bxxxxx100: out = 3'b010;
            8'bxxxx1000: out = 3'b011;
            8'bxxx10000: out = 3'b100;
            8'bxx100000: out = 3'b101;
            8'bx1000000: out = 3'b110;
            8'b10000000: out = 3'b111;
            default:     out = 3'b000;
        endcase
    end
endmodule