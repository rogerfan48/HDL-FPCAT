module Render_LV1 (
    input clk,
    input [9:0] h_cnt,
    input [9:0] ah_cnt,
    input [9:0] v_cnt,
    input [9:0] av_cnt,
    input mouseInStart,
    output reg [11:0] pixel
);

    wire [10:0] FPCAT_addr = (((av_cnt-150)/5)*60 + ((ah_cnt-170)/5)) % 1200;
    wire FPCAT_value;
    mem_FPCAT mem_FPCAT_0 (
        .clka(clk),         // input wire clka 輸入時鐘信號
        .wea(0),            // input wire [0 : 0] wea 1位元的寫入使能信號
        .addra(FPCAT_addr), // input wire [10 : 0] addra 11位元的位址信號[10:0]
        .dina(0),           // input wire [0 : 0] dina 1位元的輸入資料
        .douta(FPCAT_value) // output wire [0 : 0] douta 1位元的輸出資料
    );

    wire [10:0] GAME_START_addr = (((av_cnt-280)/2)*100 + ((ah_cnt-220)/2)) % 2000;
    wire GAME_START_value;
    mem_GAME_START mem_GAME_START_0 (
        .clka(clk),                 // input wire clka
        .wea(0),                    // input wire [0 : 0] wea
        .addra(GAME_START_addr),    // input wire [10 : 0] addra
        .dina(0),                   // input wire [0 : 0] dina
        .douta(GAME_START_value)    // output wire [0 : 0] douta
    );

    always @(*) begin
        if (h_cnt>=10'd170 && h_cnt<10'd470 && v_cnt>=10'd150 && v_cnt<10'd250 && FPCAT_value==1'b1) begin
            pixel = 12'hfff;      // Title
        end else if (h_cnt>=10'd220 && h_cnt<10'd420 && v_cnt>=10'd280 && v_cnt<10'd320 && GAME_START_value==1'b1) begin
            pixel = 12'hfff;      // Game Start
        end else if (h_cnt>=10'd200 && h_cnt<10'd440 && v_cnt>=10'd270 && v_cnt<10'd330) begin
            if (mouseInStart) pixel = 12'h632;
            else              pixel = 12'h521;
        end else begin
            pixel = 12'h0;
        end
    end
endmodule