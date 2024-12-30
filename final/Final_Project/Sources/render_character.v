module Enemy_Render_Pixel(
    input clk,
    input [2:0] type_a,
    input [2:0] type_b,
    input [11:0] addr_a,
    input [11:0] addr_b,
    output reg [1:0] pixel_value_a,
    output reg [1:0] pixel_value_b
);
    wire [1:0] pixel_value_0;
    wire [1:0] pixel_value_1;
    wire [1:0] pixel_value_2;
    wire [1:0] pixel_value_3;
    wire [1:0] pixel_value_4;
    wire [1:0] pixel_value_5;
    wire [1:0] pixel_value_6;
    wire [1:0] pixel_value_7;
    
    mem_Enemy_Killer_Bird mem_Enemy_Killer_Bird (
        .clka(clk), .wea(0), .addra(addr_a[10:0]), .dina(0), .douta(pixel_value_0), 
        .clkb(clk), .web(0), .addrb(addr_b[10:0]), .dinb(0), .doutb(pixel_value_1));
    mem_Enemy_White_Bear  mem_Enemy_White_Bear (
        .clka(clk), .wea(0), .addra(addr_a[11:0]), .dina(0), .douta(pixel_value_2),
        .clkb(clk), .web(0), .addrb(addr_b[11:0]), .dinb(0), .doutb(pixel_value_3));
    mem_Enemy_Metal_Duck  mem_Enemy_Metal_Duck (
        .clka(clk), .wea(0), .addra(addr_a[10:0]), .dina(0), .douta(pixel_value_4),
        .clkb(clk), .web(0), .addrb(addr_b[10:0]), .dinb(0), .doutb(pixel_value_5));
    mem_Enemy_Black_Bear  mem_Enemy_Black_Bear (
        .clka(clk), .wea(0), .addra(addr_a[11:0]), .dina(0), .douta(pixel_value_6),
        .clkb(clk), .web(0), .addrb(addr_b[11:0]), .dinb(0), .doutb(pixel_value_7));
    
    always @(*) begin
        case (type_a)
            3'b000:  pixel_value_a = pixel_value_0;
            3'b001:  pixel_value_a = pixel_value_2;
            3'b010:  pixel_value_a = pixel_value_4;
            3'b011:  pixel_value_a = pixel_value_6;
            default: pixel_value_a = 2'b11;
        endcase
        case (type_b)
            3'b000:  pixel_value_b = pixel_value_1;
            3'b001:  pixel_value_b = pixel_value_3;
            3'b010:  pixel_value_b = pixel_value_5;
            3'b011:  pixel_value_b = pixel_value_7;
            default: pixel_value_b = 2'b11;
        endcase
    end
endmodule

module Army_Render_Pixel(
    input clk,
    input [2:0] type_a,
    input [2:0] type_b,
    input [12:0] addr_a,
    input [12:0] addr_b,
    output reg [1:0] pixel_value_a,
    output reg [1:0] pixel_value_b
);
    wire [1:0] pixel_value_0;
    wire [1:0] pixel_value_1;
    wire [1:0] pixel_value_2;
    wire [1:0] pixel_value_3;
    wire [1:0] pixel_value_4;
    wire [1:0] pixel_value_5;
    wire [1:0] pixel_value_6;
    wire [1:0] pixel_value_7;
    wire [1:0] pixel_value_8;
    wire [1:0] pixel_value_9;
    wire [1:0] pixel_value_10;
    wire [1:0] pixel_value_11;
    wire [1:0] pixel_value_12;
    wire [1:0] pixel_value_13;
    wire [1:0] pixel_value_14;
    wire [1:0] pixel_value_15;

    mem_Army_Joker_Cat    mem_Army_Joker_Cat (
        .clka(clk), .wea(0), .addra(addr_a[11:0]), .dina(0), .douta(pixel_value_0),
        .clkb(clk), .web(0), .addrb(addr_b[11:0]), .dinb(0), .doutb(pixel_value_1));
    mem_Army_Fish_Cat     mem_Army_Fish_Cat (
        .clka(clk), .wea(0), .addra(addr_a[11:0]), .dina(0), .douta(pixel_value_2),
        .clkb(clk), .web(0), .addrb(addr_b[11:0]), .dinb(0), .doutb(pixel_value_3));
    mem_Army_Trap_Cat     mem_Army_Trap_Cat (
        .clka(clk), .wea(0), .addra(addr_a[10:0]), .dina(0), .douta(pixel_value_4),
        .clkb(clk), .web(0), .addrb(addr_b[10:0]), .dinb(0), .doutb(pixel_value_5));
    mem_Army_Jay_Cat      mem_Army_Jay_Cat (
        .clka(clk), .wea(0), .addra(addr_a[11:0]), .dina(0), .douta(pixel_value_6), 
        .clkb(clk), .web(0), .addrb(addr_b[11:0]), .dinb(0), .doutb(pixel_value_7));
    mem_Army_Bomb_Cat     mem_Army_Bomb_Cat (
        .clka(clk), .wea(0), .addra(addr_a[9:0]), .dina(0), .douta(pixel_value_8), 
        .clkb(clk), .web(0), .addrb(addr_b[9:0]), .dinb(0), .doutb(pixel_value_9));
    mem_Army_CY_Cat       mem_Army_CY_Cat (
        .clka(clk), .wea(0), .addra(addr_a[11:0]), .dina(0), .douta(pixel_value_10), 
        .clkb(clk), .web(0), .addrb(addr_b[11:0]), .dinb(0), .doutb(pixel_value_11));
    mem_Army_Hacker_Cat   mem_Army_Hacker_Cat (
        .clka(clk), .wea(0), .addra(addr_a[11:0]), .dina(0), .douta(pixel_value_12), 
        .clkb(clk), .web(0), .addrb(addr_b[11:0]), .dinb(0), .doutb(pixel_value_13));
    mem_Army_Elephant_Cat mem_Army_Elephant_Cat (
        .clka(clk), .wea(0), .addra(addr_a[12:0]), .dina(0), .douta(pixel_value_14), 
        .clkb(clk), .web(0), .addrb(addr_b[12:0]), .dinb(0), .doutb(pixel_value_15));
    
    always @(*) begin
        case (type_a)
            3'b000:  pixel_value_a = pixel_value_0;
            3'b001:  pixel_value_a = pixel_value_2;
            3'b010:  pixel_value_a = pixel_value_4;
            3'b011:  pixel_value_a = pixel_value_6;
            3'b100:  pixel_value_a = pixel_value_8;
            3'b101:  pixel_value_a = pixel_value_10;
            3'b110:  pixel_value_a = pixel_value_12;
            3'b111:  pixel_value_a = pixel_value_14;
            default: pixel_value_a = 2'b11;
        endcase
        case (type_b)
            3'b000:  pixel_value_b = pixel_value_1;
            3'b001:  pixel_value_b = pixel_value_3;
            3'b010:  pixel_value_b = pixel_value_5;
            3'b011:  pixel_value_b = pixel_value_7;
            3'b100:  pixel_value_b = pixel_value_9;
            3'b101:  pixel_value_b = pixel_value_11;
            3'b110:  pixel_value_b = pixel_value_13;
            3'b111:  pixel_value_b = pixel_value_15;
            default: pixel_value_b = 2'b11;
        endcase
    end
endmodule