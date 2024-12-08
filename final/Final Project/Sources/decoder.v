`define  ST_NONE  3'd0
`define  ST_MOVE  3'd1
`define ST_ATK_0  3'd2
`define ST_ATK_1  3'd3
`define ST_ATK_2  3'd4
`define ST_ATK_3  3'd5
`define ST_REPEL  3'd6

module Enemy_Stats (
    input [2:0] addr,
    output reg [37:0] out
);
    always @(*) begin
        case (addr)
            3'd0:    out = 38'b00011111010000011001010000100000010100;
            3'd1:    out = 38'b01111101000001100100010100010001010000;
            3'd2:    out = 38'b11111010000011111010011110001000101000;
            default: out = 38'b00000011001001100100000011010001010000;
        endcase
    end
endmodule

module Army_Stats (
    input [2:0] addr,
    output reg [37:0] out
);
    always @(*) begin
        case (addr)
            3'd0:    out = 38'b00001001011000110010010000001100001111;
            3'd1:    out = 38'b00011111010000011001010000000100001010;
            3'd2:    out = 38'b01011101110001001011011111000000000101;
            3'd3:    out = 38'b00011001000001100100011000010100011110;
            3'd4:    out = 38'b00011001000011111010011111010000000101;
            3'd5:    out = 38'b00110010000011001000011000001000110010;
            3'd6:    out = 38'b01011101110011001000011000001000110010;
            default: out = 38'b01111101000011111010011110000101000110;
        endcase
    end
endmodule

module Army_Cost (
    input [2:0] addr,
    output reg [14:0] out
);
    always @(*) begin
        case (addr)
            3'd0:    out = 15'd75;
            3'd1:    out = 15'd150;
            3'd2:    out = 15'd240;
            3'd3:    out = 15'd350;
            3'd4:    out = 15'd750;
            3'd5:    out = 15'd1500;
            3'd6:    out = 15'd2000;
            default: out = 15'd2400;
        endcase
    end
endmodule

module Enemy_Pixel (
    input [2:0] addr,
    output reg [18:0] out   // W[7B][18:12], H[7B][11:5], D[5B][4:0]
);
    always @(*) begin
        case (addr)
            3'd0:    out = 19'b0010000000111111110;
            3'd1:    out = 19'b0010000001111011000;
            3'd2:    out = 19'b0010000001010011100;
            default: out = 19'b0010000001111011000;
        endcase
    end
endmodule

module Army_Pixel (
    input [2:0] addr,
    output reg [18:0] out   // W[7B][18:12], H[7B][11:5], D[5B][4:0]
);
    always @(*) begin
        case (addr)
            3'd0:    out = 19'b0010100001010000010;
            3'd1:    out = 19'b0010100001010000010;
            3'd2:    out = 19'b0010000000110000000;
            3'd3:    out = 19'b0010100001010001100;
            3'd4:    out = 19'b0010000000101000000;
            3'd5:    out = 19'b0010100001100101010;
            3'd6:    out = 19'b0010100001100101010;
            default: out = 19'b0101000001100001000;
        endcase
    end
endmodule

module Purse_Upgrade_Need_Money (
    input [2:0] level,
    output reg [14:0] out
);
    always @(*) begin
        case (level)
            3'd0:    out = 15'd100;
            3'd1:    out = 15'd200;
            3'd2:    out = 15'd400;
            3'd3:    out = 15'd600;
            3'd4:    out = 15'd1000;
            3'd5:    out = 15'd2000;
            3'd6:    out = 15'd4000;
            default: out = 15'd8000;
        endcase
    end
endmodule

module Purse_Max_Money (
    input [2:0] level,
    output reg [14:0] out
);
    always @(*) begin
        case (level)
            3'd0:    out = 15'd150;
            3'd1:    out = 15'd300;
            3'd2:    out = 15'd500;
            3'd3:    out = 15'd1000;
            3'd4:    out = 15'd2000;
            3'd5:    out = 15'd4000;
            3'd6:    out = 15'd6000;
            default: out = 15'd9999;
        endcase
    end
endmodule

module PicNum_By_State (
    input [3:0] state,
    input x_pos,
    output reg [2:0] pic
);
    always @(*) begin
        case(state)
            `ST_MOVE:  pic = (x_pos ? 3'd1 : 3'd0);
            `ST_ATK_0, `ST_ATK_1: pic = 3'd2;
            `ST_ATK_2: pic = 3'd3;
            `ST_ATK_3: pic = 3'd4;
            4'd6: pic = 3'd5;
            default:   pic = 3'd0;
        endcase
    end
endmodule