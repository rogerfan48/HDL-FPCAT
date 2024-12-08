module Render_Menu (
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
    input mouseInLevel1,
    input mouseInLevel2,
    input mouseInLevel3,
    output reg [11:0] pixel
);

    // reg [10:0] FPCAT_pp00, FPCAT_pp01, FPCAT_pp10, FPCAT_pp11, FPCAT_pp2;
    // wire FPCAT_value;
    // always @(posedge clk_25MHz) begin
    //     FPCAT_pp00 <= ((v_cnt_5-150)/5);
    //     FPCAT_pp01 <= ((h_cnt_5-170)/5);
    //     FPCAT_pp10 <= FPCAT_pp00 * 60;
    //     FPCAT_pp11 <= FPCAT_pp01;
    //     FPCAT_pp2 <= (FPCAT_pp10 + FPCAT_pp11) % 1200;
    // end
    // mem_FPCAT mem_FPCAT_0 (.clka(clk_25MHz), .wea(0), .addra(FPCAT_pp2),  .dina(0), .douta(FPCAT_value));

    reg [10:0] LEVEL_1_pp00, LEVEL_1_pp01, LEVEL_1_pp10, LEVEL_1_pp11, LEVEL_1_pp2;
    reg [10:0] LEVEL_2_pp00, LEVEL_2_pp01, LEVEL_2_pp10, LEVEL_2_pp11, LEVEL_2_pp2;
    reg [10:0] LEVEL_3_pp00, LEVEL_3_pp01, LEVEL_3_pp10, LEVEL_3_pp11, LEVEL_3_pp2;
    always @(posedge clk_25MHz) begin
        LEVEL_1_pp00 <= ((v_cnt_5-90)/2);
        LEVEL_1_pp01 <= ((h_cnt_5-240)/2);
        LEVEL_1_pp10 <= LEVEL_1_pp00 * 60;
        LEVEL_1_pp11 <= LEVEL_1_pp01;
        LEVEL_1_pp2 <= (LEVEL_1_pp10 + LEVEL_1_pp11) % 1200;

        LEVEL_2_pp00 <= ((v_cnt_5-210)/2);
        LEVEL_2_pp01 <= ((h_cnt_5-240)/2);
        LEVEL_2_pp10 <= LEVEL_2_pp00 * 60;
        LEVEL_2_pp11 <= LEVEL_2_pp01;
        LEVEL_2_pp2 <= (LEVEL_2_pp10 + LEVEL_2_pp11) % 1200;

        LEVEL_3_pp00 <= ((v_cnt_5-330)/2);
        LEVEL_3_pp01 <= ((h_cnt_5-240)/2);
        LEVEL_3_pp10 <= LEVEL_3_pp00 * 60;
        LEVEL_3_pp11 <= LEVEL_3_pp01;
        LEVEL_3_pp2 <= (LEVEL_3_pp10 + LEVEL_3_pp11) % 1200;
    end
    wire LEVEL_1_value;
    mem_LEVEL mem_LEVEL_1 (
        .clka(clk_25MHz),       // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(LEVEL_1_pp2),   // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(LEVEL_1_value)   // output wire [0 : 0] douta
    );
    wire LEVEL_2_value;
    mem_LEVEL mem_LEVEL_2 (
        .clka(clk_25MHz),       // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(LEVEL_2_pp2),   // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(LEVEL_2_value)   // output wire [0 : 0] douta
    );
    wire LEVEL_3_value;
    mem_LEVEL mem_LEVEL_3 (
        .clka(clk_25MHz),       // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(LEVEL_3_pp2),   // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(LEVEL_3_value)   // output wire [0 : 0] douta
    );
    
    reg [10:0] num_menu_pp00, num_menu_pp01, num_menu_pp10, num_menu_pp11, num_menu_pp2;
    wire num_menu_value;
    always @(posedge clk_25MHz) begin
        if (h_cnt_5>=10'd370 && h_cnt_5<10'd400 && v_cnt_5>=10'd87 && v_cnt_5<10'd132) begin
            num_menu_pp00 <= ((v_cnt_5-87)/3);
            num_menu_pp01 <= ((h_cnt_5-370)/3);
            num_menu_pp10 <= num_menu_pp00 * 10;
            num_menu_pp11 <= num_menu_pp01 + 150;
            num_menu_pp2 <= (num_menu_pp10 + num_menu_pp11) % 1650;
        end else if (h_cnt_5>=10'd370 && h_cnt_5<10'd400 && v_cnt_5>=10'd207 && v_cnt_5<10'd252) begin
            num_menu_pp00 <= ((v_cnt_5-207)/3);
            num_menu_pp01 <= ((h_cnt_5-370)/3);
            num_menu_pp10 <= num_menu_pp00 * 10;
            num_menu_pp11 <= num_menu_pp01 + 300;
            num_menu_pp2 <= (num_menu_pp10 + num_menu_pp11) % 1650;
        end else if (h_cnt_5>=10'd370 && h_cnt_5<10'd400 && v_cnt_5>=10'd327 && v_cnt_5<10'd372) begin
            num_menu_pp00 <= ((v_cnt_5-327)/3);
            num_menu_pp01 <= ((h_cnt_5-370)/3);
            num_menu_pp10 <= num_menu_pp00 * 10;
            num_menu_pp11 <= num_menu_pp01 + 450;
            num_menu_pp2 <= (num_menu_pp10 + num_menu_pp11) % 1650;
        end else num_menu_pp2 <= 11'd0;
    end
    mem_Numbers mem_num_menu (
        .clka(clk_25MHz),       // input wire clka
        .wea(0),                // input wire [0 : 0] wea
        .addra(num_menu_pp2),  // input wire [10 : 0] addra
        .dina(0),               // input wire [0 : 0] dina
        .douta(num_menu_value)  // output wire [0 : 0] douta
    );

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