`define  ST_NONE  4'd0
`define  ST_MOVE  4'd1
`define ST_ATK_0  4'd2
`define ST_ATK_1  4'd3
`define ST_ATK_2  4'd4
`define ST_ATK_3  4'd5
`define ST_REPEL  4'd6

module Enemy_Render_Pixel(
    input clk,
    input [2:0] type,
    input [11:0] addr,
    output [1:0] pixel_value
);
    output [1:0] pixel_value_0;
    output [1:0] pixel_value_1;
    output [1:0] pixel_value_2;
    output [1:0] pixel_value_3;
    mem_Enemy_Killer_Bird mem_Enemy_Killer_Bird (.clka(clk), .wea(0), .addra(addr[10:0]), .dina(0), .douta(pixel_value_0));
    mem_Enemy_White_Bear  mem_Enemy_White_Bear  (.clka(clk), .wea(0), .addra(addr[11:0]), .dina(0), .douta(pixel_value_1));
    mem_Enemy_Metal_Duck  mem_Enemy_Metal_Duck  (.clka(clk), .wea(0), .addra(addr[10:0]), .dina(0), .douta(pixel_value_2));
    mem_Enemy_Black_Bear  mem_Enemy_Black_Bear  (.clka(clk), .wea(0), .addra(addr[11:0]), .dina(0), .douta(pixel_value_3));
    always @(*) begin
        case (type)
            3'b000:  pixel_value = pixel_value_0;
            3'b001:  pixel_value = pixel_value_1;
            3'b010:  pixel_value = pixel_value_2;
            3'b011:  pixel_value = pixel_value_3;
            default: pixel_value = 2'b11;
        endcase
    end
endmodule

module Army_Render_Pixel(
    input clk,
    input [2:0] type,
    input [12:0] addr,
    output [1:0] pixel_value
);
    output [1:0] pixel_value_0;
    output [1:0] pixel_value_1;
    output [1:0] pixel_value_2;
    output [1:0] pixel_value_3;
    output [1:0] pixel_value_4;
    output [1:0] pixel_value_5;
    output [1:0] pixel_value_6;
    output [1:0] pixel_value_7;
    mem_Army_Joker_Cat    mem_Army_Joker_Cat    (.clka(clk), .wea(0), .addra(addr[11:0]), .dina(0), .douta(pixel_value_0));
    mem_Army_Fish_Cat     mem_Army_Fish_Cat     (.clka(clk), .wea(0), .addra(addr[11:0]), .dina(0), .douta(pixel_value_1));
    mem_Army_Trap_Cat     mem_Army_Trap_Cat     (.clka(clk), .wea(0), .addra(addr[10:0]), .dina(0), .douta(pixel_value_2));
    mem_Army_Jay_Cat      mem_Army_Jay_Cat      (.clka(clk), .wea(0), .addra(addr[11:0]), .dina(0), .douta(pixel_value_3));
    mem_Army_Bomb_Cat     mem_Army_Bomb_Cat     (.clka(clk), .wea(0), .addra(addr[9:0]), .dina(0), .douta(pixel_value_4));
    mem_Army_CY_Cat       mem_Army_CY_Cat       (.clka(clk), .wea(0), .addra(addr[11:0]), .dina(0), .douta(pixel_value_5));
    mem_Army_Hacker_Cat   mem_Army_Hacker_Cat   (.clka(clk), .wea(0), .addra(addr[11:0]), .dina(0), .douta(pixel_value_6));
    mem_Army_Elephant_Cat mem_Army_Elephant_Cat (.clka(clk), .wea(0), .addra(addr[12:0]), .dina(0), .douta(pixel_value_7));
    always @(*) begin
        case (type)
            3'b000:  pixel_value = pixel_value_0;
            3'b001:  pixel_value = pixel_value_1;
            3'b010:  pixel_value = pixel_value_2;
            3'b011:  pixel_value = pixel_value_3;
            3'b100:  pixel_value = pixel_value_4;
            3'b101:  pixel_value = pixel_value_5;
            3'b110:  pixel_value = pixel_value_6;
            3'b111:  pixel_value = pixel_value_7;
            default: pixel_value = 2'b11;
        endcase
    end
endmodule