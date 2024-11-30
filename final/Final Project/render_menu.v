module Render_Menu (
    input clk,
    input [9:0] h_cnt,
    input [9:0] ah_cnt,
    input [9:0] v_cnt,
    input [9:0] av_cnt,
    input mouseInLevel1,
    input mouseInLevel2,
    input mouseInLevel3,
    output reg [11:0] pixel
);

    wire [10:0] LEVEL_1_addr = (((av_cnt-90)/2)*60 + ((ah_cnt-240)/2)) % 1200;
    wire LEVEL_1_value;
    mem_LEVEL mem_LEVEL_1 (
        .clka(clk),             // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(LEVEL_1_addr),   // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(LEVEL_1_value)   // output wire [0 : 0] douta
    );
    wire [10:0] LEVEL_2_addr = (((av_cnt-210)/2)*60 + ((ah_cnt-240)/2)) % 1200;
    wire LEVEL_2_value;
    mem_LEVEL mem_LEVEL_2 (
        .clka(clk),             // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(LEVEL_2_addr),   // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(LEVEL_2_value)   // output wire [0 : 0] douta
    );
    wire [10:0] LEVEL_3_addr = (((av_cnt-330)/2)*60 + ((ah_cnt-240)/2)) % 1200;
    wire LEVEL_3_value;
    mem_LEVEL mem_LEVEL_3 (
        .clka(clk),             // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(LEVEL_3_addr),   // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(LEVEL_3_value)   // output wire [0 : 0] douta
    );
    reg [10:0] num_menu_addr;
    wire num_menu_value;
    mem_Numbers mem_num_menu (
        .clka(clk),             // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(num_menu_addr),  // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(num_menu_value)  // output wire [0 : 0] douta
    );
    always @(*) begin
        if (ah_cnt>=10'd370 && ah_cnt<10'd400 && av_cnt>=10'd87 && av_cnt<10'd132) begin
            num_menu_addr = (((av_cnt-87)/3)*10 + ((ah_cnt-370)/3)+150) % 1650;
        end else if (ah_cnt>=10'd370 && ah_cnt<10'd400 && av_cnt>=10'd207 && av_cnt<10'd252) begin
            num_menu_addr = (((av_cnt-207)/3)*10 + ((ah_cnt-370)/3)+300) % 1650;
        end else if (ah_cnt>=10'd370 && ah_cnt<10'd400 && av_cnt>=10'd327 && av_cnt<10'd372) begin
            num_menu_addr = (((av_cnt-327)/3)*10 + ((ah_cnt-370)/3)+450) % 1650;
        end else num_menu_addr = 11'd0;
    end

    always @(*) begin
        if ((h_cnt>=10'd240 && h_cnt<10'd360 && v_cnt>=10'd90 && v_cnt<10'd130 && LEVEL_1_value==1'b1) ||
            (h_cnt>=10'd240 && h_cnt<10'd360 && v_cnt>=10'd210 && v_cnt<10'd250 && LEVEL_2_value==1'b1) ||
            (h_cnt>=10'd240 && h_cnt<10'd360 && v_cnt>=10'd330 && v_cnt<10'd370 && LEVEL_3_value==1'b1)) begin
            pixel = 12'hfff;        // LEVEL x3
        end else if (
            ((h_cnt>=10'd370 && h_cnt<10'd400 && v_cnt>=10'd87 && v_cnt<10'd132) ||
            (h_cnt>=10'd370 && h_cnt<10'd400 && v_cnt>=10'd207 && v_cnt<10'd252) ||
            (h_cnt>=10'd370 && h_cnt<10'd400 && v_cnt>=10'd327 && v_cnt<10'd372)) && num_menu_value == 1
        ) begin
            pixel = 12'hfff;        // numbers x3
        end else if (h_cnt>=10'd160 && h_cnt<10'd480 && v_cnt>=10'd80 && v_cnt<10'd140) begin
            if (mouseInLevel1) pixel = 12'h632;
            else               pixel = 12'h521;
        end else if (h_cnt>=10'd160 && h_cnt<10'd480 && v_cnt>=10'd200 && v_cnt<10'd260) begin
            if (mouseInLevel2) pixel = 12'h632;
            else               pixel = 12'h521;
        end else if (h_cnt>=10'd160 && h_cnt<10'd480 && v_cnt>=10'd320 && v_cnt<10'd380) begin
            if (mouseInLevel3) pixel = 12'h632;
            else               pixel = 12'h521;
        end else begin
            pixel = 12'h0;
        end
    end
endmodule