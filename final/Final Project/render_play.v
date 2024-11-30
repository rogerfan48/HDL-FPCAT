module Render_Play (
    input clk,
    input [9:0] h_cnt,
    input [9:0] ah_cnt,
    input [9:0] v_cnt,
    input [9:0] av_cnt,
    input [9:0] mouseInFrame,
    output reg [11:0] pixel
);
    wire [9:0] tower_enemy_addr = (((av_cnt-90)/3)*20 + ((ah_cnt-10)/3)) % 800;
    wire [1:0] tower_enemy_value;
    mem_Tower_Enemy mem_Tower_Enemy (.clka(clk), .wea(0), .addra(tower_enemy_addr), .dina(0), .douta(tower_enemy_value));
    wire [9:0] tower_cat_addr = (((av_cnt-90)/3)*20 + ((ah_cnt-570)/3)) % 800;
    wire [1:0] tower_cat_value;
    mem_Tower_Cat mem_Tower_Cat (.clka(clk), .wea(0), .addra(tower_cat_addr), .dina(0), .douta(tower_cat_value));

    wire [8:0] frame_joker_addr = (((av_cnt-290)/4)*25 + ((ah_cnt-105)/4)) % 500;
    wire [1:0] frame_joker_value;
    mem_Frame_Joker_Cat mem_Frame_Joker_Cat (.clka(clk), .wea(0), .addra(frame_joker_addr), .dina(0), .douta(frame_joker_value));
    wire [8:0] frame_fish_addr = (((av_cnt-290)/4)*25 + ((ah_cnt-215)/4)) % 500;
    wire [1:0] frame_fish_value;
    mem_Frame_Fish_Cat mem_Frame_Fish_Cat (.clka(clk), .wea(0), .addra(frame_fish_addr), .dina(0), .douta(frame_fish_value));
    wire [8:0] frame_trap_addr = (((av_cnt-290)/4)*25 + ((ah_cnt-325)/4)) % 500;
    wire [1:0] frame_trap_value;
    mem_Frame_Trap_Cat mem_Frame_Trap_Cat (.clka(clk), .wea(0), .addra(frame_trap_addr), .dina(0), .douta(frame_trap_value));
    wire [8:0] frame_jay_addr = (((av_cnt-290)/4)*25 + ((ah_cnt-435)/4)) % 500;
    wire [1:0] frame_jay_value;
    mem_Frame_Jay_Cat mem_Frame_Jay_Cat (.clka(clk), .wea(0), .addra(frame_jay_addr), .dina(0), .douta(frame_jay_value));
    wire [8:0] frame_bomb_addr = (((av_cnt-380)/4)*25 + ((ah_cnt-105)/4)) % 500;
    wire [1:0] frame_bomb_value;
    mem_Frame_Bomb_Cat mem_Frame_Bomb_Cat (.clka(clk), .wea(0), .addra(frame_bomb_addr), .dina(0), .douta(frame_bomb_value));
    wire [8:0] frame_CY_addr = (((av_cnt-380)/4)*25 + ((ah_cnt-215)/4)) % 500;
    wire [1:0] frame_CY_value;
    mem_Frame_CY_Cat mem_Frame_CY_Cat (.clka(clk), .wea(0), .addra(frame_CY_addr), .dina(0), .douta(frame_CY_value));
    wire [8:0] frame_hacker_addr = (((av_cnt-380)/4)*25 + ((ah_cnt-325)/4)) % 500;
    wire [1:0] frame_hacker_value;
    mem_Frame_Hacker_Cat mem_Frame_Hacker_Cat (.clka(clk), .wea(0), .addra(frame_hacker_addr), .dina(0), .douta(frame_hacker_value));
    wire [8:0] frame_elephant_addr = (((av_cnt-380)/4)*25 + ((ah_cnt-435)/4)) % 500;
    wire [1:0] frame_elephant_value;
    mem_Frame_Elephant_Cat mem_Frame_Elephant_Cat (.clka(clk), .wea(0), .addra(frame_elephant_addr), .dina(0), .douta(frame_elephant_value));

    wire [11:0] btn_purse_addr = (((av_cnt-380)/2)*50 + ((ah_cnt)/2)) % 2500;
    wire [1:0] btn_purse_value;
    mem_Btn_Purse mem_Btn_Purse (.clka(clk), .wea(0), .addra(btn_purse_addr), .dina(0), .douta(btn_purse_value));
    wire [12:0] btn_fire_addr = (((av_cnt-380)/2)*50 + ((ah_cnt-540)/2) + 2500) % 5000;
    wire [1:0] btn_fire_value;
    mem_Btn_Fire mem_Btn_Fire (.clka(clk), .wea(0), .addra(btn_fire_addr), .dina(0), .douta(btn_fire_value));

    always @(*) begin
        if (v_cnt<10'd270) begin    // simply cut half, this is upper half (gaming) for shortening Circuit Longest Length
            if (h_cnt>=10'd10 && h_cnt<10'd70 && v_cnt>=10'd90 && v_cnt<10'd210 && tower_enemy_value!=2'b11) begin
                case (tower_enemy_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd570 && h_cnt<10'd630 && v_cnt>=10'd90 && v_cnt<10'd210 && tower_cat_value!=2'b11) begin
                case (tower_cat_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (v_cnt>=10'd170 && v_cnt<10'd230) begin
                pixel = 12'hda5;    // path
            end else if (v_cnt>=10'd140) begin
                pixel = 12'h5b2;    // grass
            end else begin
                pixel = 12'h2bf;    // sky
            end
        end else begin              // simply cut half, this is lower half (board) for shortening Circuit Longest Length
            if (h_cnt>=10'd105 && h_cnt<10'd205 && v_cnt>=10'd290 && v_cnt<10'd370) begin
                case (frame_joker_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd215 && h_cnt<10'd315 && v_cnt>=10'd290 && v_cnt<10'd370) begin
                case (frame_fish_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd325 && h_cnt<10'd425 && v_cnt>=10'd290 && v_cnt<10'd370) begin
                case (frame_trap_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd435 && h_cnt<10'd535 && v_cnt>=10'd290 && v_cnt<10'd370) begin
                case (frame_jay_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd105 && h_cnt<10'd205 && v_cnt>=10'd380 && v_cnt<10'd460) begin
                case (frame_bomb_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd215 && h_cnt<10'd315 && v_cnt>=10'd380 && v_cnt<10'd460) begin
                case (frame_CY_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd325 && h_cnt<10'd425 && v_cnt>=10'd380 && v_cnt<10'd460) begin
                case (frame_hacker_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd435 && h_cnt<10'd535 && v_cnt>=10'd380 && v_cnt<10'd460) begin
                case (frame_elephant_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt<10'd100 && v_cnt>=10'd380 && btn_purse_value!=2'b11) begin
                case (btn_purse_value)      // purse
                    2'b00: pixel = 12'ha63;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd540 && v_cnt>=10'd380 && btn_fire_value!=2'b11) begin
                case (btn_fire_value)       // fire
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (v_cnt>=10'd270) begin
                pixel = 12'hfb7;    // board
            end 
        end
    end
endmodule