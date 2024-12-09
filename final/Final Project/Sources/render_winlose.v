`define S_START 3'd0
`define  S_MENU 3'd1
`define S_PLAY1 3'd2
`define S_PLAY2 3'd3
`define S_PLAY3 3'd4
`define   S_WIN 3'd5
`define  S_LOSE 3'd6

module Render_WinLose (
    input rst,
    input clk,
    input clk_25MHz,
    input [9:0] h_cnt_1,
    input [9:0] v_cnt_1,
    input [9:0] h_cnt_5,
    input [9:0] v_cnt_5,
    input [2:0] scene,
    input [3:0] winLose_cnt,
    output reg [11:0] pixel
);

    reg [10:0] YOU_WIN_pp00, YOU_WIN_pp01, YOU_WIN_pp10, YOU_WIN_pp11, YOU_WIN_pp2;
    wire YOU_WIN_value;
    always @(posedge clk_25MHz) begin
        YOU_WIN_pp00 <= ((v_cnt_5-212)>>3);
        YOU_WIN_pp01 <= ((h_cnt_5-160)>>3);
        YOU_WIN_pp10 <= YOU_WIN_pp00 * 40;
        YOU_WIN_pp11 <= YOU_WIN_pp01;
        YOU_WIN_pp2 <= (YOU_WIN_pp10 + YOU_WIN_pp11) % 280;
    end
    mem_YOU_WIN mem_YOU_WIN_0 (.clka(clk_25MHz), .wea(0), .addra(YOU_WIN_pp2),  .dina(0), .douta(YOU_WIN_value));

    reg [10:0] YOU_LOSE_pp00, YOU_LOSE_pp01, YOU_LOSE_pp10, YOU_LOSE_pp11, YOU_LOSE_pp2;
    wire YOU_LOSE_value;
    always @(posedge clk_25MHz) begin
        YOU_LOSE_pp00 <= ((v_cnt_5-212)>>3);
        YOU_LOSE_pp01 <= ((h_cnt_5-160)>>3);
        YOU_LOSE_pp10 <= YOU_LOSE_pp00 * 40;
        YOU_LOSE_pp11 <= YOU_LOSE_pp01;
        YOU_LOSE_pp2 <= (YOU_LOSE_pp10 + YOU_LOSE_pp11) % 280;
    end
    mem_YOU_LOSE mem_YOU_LOSE_0 (.clka(clk_25MHz), .wea(0), .addra(YOU_LOSE_pp2),  .dina(0), .douta(YOU_LOSE_value));

    reg [10:0] TAP_TO_CONTINUE_pp00, TAP_TO_CONTINUE_pp01, TAP_TO_CONTINUE_pp10, TAP_TO_CONTINUE_pp11, TAP_TO_CONTINUE_pp2;
    wire TAP_TO_CONTINUE_value;
    always @(posedge clk_25MHz) begin
        TAP_TO_CONTINUE_pp00 <= ((v_cnt_5-285)/3);
        TAP_TO_CONTINUE_pp01 <= ((h_cnt_5-200)/3);
        TAP_TO_CONTINUE_pp10 <= TAP_TO_CONTINUE_pp00 * 80;
        TAP_TO_CONTINUE_pp11 <= TAP_TO_CONTINUE_pp01;
        TAP_TO_CONTINUE_pp2 <= (TAP_TO_CONTINUE_pp10 + TAP_TO_CONTINUE_pp11) % 560;
    end
    mem_TAP_TO_CONTINUE mem_TAP_TO_CONTINUE_0 (.clka(clk_25MHz), .wea(0), .addra(TAP_TO_CONTINUE_pp2), .dina(0), .douta(TAP_TO_CONTINUE_value));

    always @(*) begin
        if (scene == `S_WIN) begin
            if (h_cnt_1>=10'd160 && h_cnt_1<10'd480 && v_cnt_1>=10'd212 && v_cnt_1<10'd268 && YOU_WIN_value==1'b1) begin
                pixel = 12'h000;        // YOU WIN
            end else if (winLose_cnt[3]==1'b1 && h_cnt_1>=10'd200 && h_cnt_1<10'd440 && v_cnt_1>=10'd285 && v_cnt_1<10'd306 && TAP_TO_CONTINUE_value==1'b1) begin
                pixel = 12'h000;        // Tap To Continue
            end else if (v_cnt_1>=10'd160 && v_cnt_1<10'd320) begin
                pixel = 12'hF90;        // banner
            end else begin
                pixel = 12'heee;
            end
        end else begin
            if (h_cnt_1>=10'd160 && h_cnt_1<10'd480 && v_cnt_1>=10'd212 && v_cnt_1<10'd268 && YOU_LOSE_value==1'b1) begin
                pixel = 12'hfff;        // YOU LOSE
            end else if (winLose_cnt[3]==1'b1 && h_cnt_1>=10'd200 && h_cnt_1<10'd440 && v_cnt_1>=10'd285 && v_cnt_1<10'd306 && TAP_TO_CONTINUE_value==1'b1) begin
                pixel = 12'hfff;        // Tap To Continue
            end else if (v_cnt_1>=10'd160 && v_cnt_1<10'd320) begin
                pixel = 12'h000;        // banner
            end else begin
                pixel = 12'heee;
            end
        end
    end
endmodule