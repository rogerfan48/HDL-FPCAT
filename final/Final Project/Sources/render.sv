module Render (
    input clk,
    input clk_25MHz,
    input [9:0] h_cnt,
    input [9:0] ah_cnt,
    input [9:0] v_cnt,
    input [9:0] av_cnt,
    input [9:0] mouseX,
    input [9:0] mouseY,
    input valid,
    input enable_mouse_display,
    input [11:0] mouse_pixel,
    input [2:0] scene,
    input mouseInStart,
    input mouseInLevel1,
    input mouseInLevel2,
    input mouseInLevel3,
    input [9:0] mouseInFrame,
    input [55:0] Enemy_Instance [7:0],
    input [55:0] Army_Instance [7:0],
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
);

    parameter S_START = 3'd0;
    parameter S_MENU = 3'd1;
    parameter S_PLAY1 = 3'd2;
    parameter S_PLAY2 = 3'd3;
    parameter S_PLAY3 = 3'd4;
    parameter S_WIN = 3'd5;
    parameter S_LOSE = 3'd6;

    wire [11:0] pixel_start;
    Render_Start Render_Start (clk_25MHz, h_cnt, ah_cnt, v_cnt, av_cnt, mouseInStart, pixel_start);
    wire [11:0] pixel_menu;
    Render_Menu Render_Menu (clk_25MHz, h_cnt, ah_cnt, v_cnt, av_cnt,
        mouseInLevel1, mouseInLevel2, mouseInLevel3, pixel_menu);
    wire [11:0] pixel_play;
    Render_Play Render_Play ((scene==S_PLAY1 || scene==S_PLAY2 || scene==S_PLAY_3), 
        clk, clk_25MHz, h_cnt, ah_cnt, v_cnt, av_cnt,
        Enemy_Instance, Army_Instance, mouseInFrame, pixel_play);

    always@(*) begin
        if(!valid)                     {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        else if (enable_mouse_display) {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
        else begin
            case(scene)
                S_START: {vgaRed, vgaGreen, vgaBlue} = pixel_start;
                S_MENU:  {vgaRed, vgaGreen, vgaBlue} = pixel_menu;
                S_PLAY1: {vgaRed, vgaGreen, vgaBlue} = pixel_play;
                S_PLAY2: {vgaRed, vgaGreen, vgaBlue} = pixel_play;
                S_PLAY3: {vgaRed, vgaGreen, vgaBlue} = pixel_play;
                S_WIN:   {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                S_LOSE:  {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                default: {vgaRed, vgaGreen, vgaBlue} = 12'h0;
            endcase
        end
    end
endmodule