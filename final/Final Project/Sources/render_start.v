module Render_Start (
    input rst,
    input clk,
    input clk_25MHz,
    input [1:0] display_cnt,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [9:0] h_cnt_1,
    input [9:0] h_cnt_2,
    input [9:0] h_cnt_3,
    input [9:0] h_cnt_4,
    input [9:0] h_cnt_5,
    input [9:0] h_cnt_6,
    input [9:0] v_cnt_1,
    input [9:0] v_cnt_2,
    input [9:0] v_cnt_3,
    input [9:0] v_cnt_4,
    input [9:0] v_cnt_5,
    input [9:0] v_cnt_6,
    input mouseInStart,
    output reg [11:0] pixel
);

    reg [10:0] FPCAT_pp00, FPCAT_pp01, FPCAT_pp10, FPCAT_pp11, FPCAT_pp2;
    wire FPCAT_value;
    always @(posedge clk_25MHz) begin
        FPCAT_pp00 <= ((v_cnt_5-150)/5);
        FPCAT_pp01 <= ((h_cnt_5-170)/5);
        FPCAT_pp10 <= FPCAT_pp00 * 60;
        FPCAT_pp11 <= FPCAT_pp01;
        FPCAT_pp2 <= (FPCAT_pp10 + FPCAT_pp11) % 1200;
    end
    mem_FPCAT mem_FPCAT_0 (.clka(clk_25MHz), .wea(0), .addra(FPCAT_pp2),  .dina(0), .douta(FPCAT_value));

    reg [10:0] GAME_START_pp00, GAME_START_pp01, GAME_START_pp10, GAME_START_pp11, GAME_START_pp2;
    wire GAME_START_value;
    always @(posedge clk_25MHz) begin
        GAME_START_pp00 <= ((v_cnt_5-280)/2);
        GAME_START_pp01 <= ((h_cnt_5-220)/2);
        GAME_START_pp10 <= GAME_START_pp00 * 100;
        GAME_START_pp11 <= GAME_START_pp01;
        GAME_START_pp2 <= (GAME_START_pp10 + GAME_START_pp11) % 2000;
    end
    mem_GAME_START mem_GAME_START_0 (.clka(clk_25MHz), .wea(0), .addra(GAME_START_pp2), .dina(0), .douta(GAME_START_value));

    always @(*) begin
        if (h_cnt_1>=10'd170 && h_cnt_1<10'd470 && v_cnt_1>=10'd150 && v_cnt_1<10'd250 && FPCAT_value==1'b1) begin
            pixel = 12'hfff;      // Title
        end else if (h_cnt_1>=10'd220 && h_cnt_1<10'd420 && v_cnt_1>=10'd280 && v_cnt_1<10'd320 && GAME_START_value==1'b1) begin
            pixel = 12'hfff;      // Game Start
        end else if (h_cnt_1>=10'd200 && h_cnt_1<10'd440 && v_cnt_1>=10'd270 && v_cnt_1<10'd330) begin
            if (mouseInStart) pixel = 12'h632;
            else              pixel = 12'h521;
        end else begin
            pixel = 12'h0;
        end
    end
endmodule