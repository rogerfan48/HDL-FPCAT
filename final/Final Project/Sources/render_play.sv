// `define W_PP 18:12
// `define H_PP 11:5
// `define D_PP 4:0

// `define       EXIST_P  55
// `define        TYPE_P  54:52
// `define           X_P  51:42
// `define           Y_P  41:32
// `define          HP_P  31:20
// `define       STATE_P  19:16
// `define   STATE_CNT_P  15:12
// `define  BE_DAMAGED_P  11:0

module Render_Play (
    input rst,
    input clk,
    input clk_25MHz,
    input [1:0] display_cnt,
    input [9:0] h_cnt,
    input [9:0] ah_cnt,
    input [9:0] v_cnt,
    input [9:0] av_cnt,
    input [9:0] d_h_cnt,
    input [9:0] d_v_cnt,
    input [55:0] Enemy_Instance [7:0],
    input [55:0] Army_Instance [7:0],
    input [9:0] mouseInFrame,
    output reg [11:0] pixel
);

    reg  [55:0] Enemy_Instance_0, Enemy_Instance_1;
    wire [18:0] enemy_0_pixel_value, enemy_1_pixel_value;
    wire  [2:0] enemy_0_picNum, enemy_1_picNum;
    Enemy_Pixel EnemyPixel0 (Enemy_Instance_0[54:52], enemy_0_pixel_value);
    Enemy_Pixel EnemyPixel1 (Enemy_Instance_1[54:52], enemy_1_pixel_value);
    PicNum_By_State PicNum_By_State0 (Enemy_Instance_0[19:16], Enemy_Instance_0[45], enemy_0_picNum);
    PicNum_By_State PicNum_By_State1 (Enemy_Instance_1[19:16], Enemy_Instance_1[45], enemy_1_picNum);
    wire [11:0] enemy_0_addr = (
        (((d_v_cnt - Enemy_Instance_0[41:32]) >> 1) * enemy_0_pixel_value[18:12]) + 
        (((d_h_cnt - Enemy_Instance_0[51:42]) >> 1)) + 
        (enemy_0_pixel_value[18:12] * enemy_0_pixel_value[11:5] * enemy_0_picNum));   
    wire [11:0] enemy_1_addr = (
        (((d_v_cnt - Enemy_Instance_1[41:32]) >> 1) * enemy_1_pixel_value[18:12]) + 
        (((d_h_cnt - Enemy_Instance_1[51:42]) >> 1)) +
        (enemy_1_pixel_value[18:12] * enemy_1_pixel_value[11:5] * enemy_1_picNum));
    wire [1:0] enemy_0_value, enemy_1_value;
    Enemy_Render_Pixel Enemy_Render_01 (.clk(clk), 
        .type_a(Enemy_Instance_0[54:52]), .addr_a(enemy_0_addr), .pixel_value_a(enemy_0_value),
        .type_b(Enemy_Instance_1[54:52]), .addr_b(enemy_1_addr), .pixel_value_b(enemy_1_value));

    reg  [55:0] Army_Instance_0, Army_Instance_1;
    wire [18:0] army_0_pixel_value, army_1_pixel_value;
    wire  [2:0] army_0_picNum, army_1_picNum;
    Army_Pixel ArmyPixel0 (Army_Instance_0[54:52], army_0_pixel_value);
    Army_Pixel ArmyPixel1 (Army_Instance_1[54:52], army_1_pixel_value);
    PicNum_By_State PicNum_By_State8 (Army_Instance_0[19:16], Army_Instance_0[45], army_0_picNum);
    PicNum_By_State PicNum_By_State9 (Army_Instance_1[19:16], Army_Instance_1[45], army_1_picNum);
    wire [12:0] army_0_addr = (
        (((d_v_cnt - Army_Instance_0[41:32]) >> 1) * army_0_pixel_value[18:12]) + 
        (((d_h_cnt - Army_Instance_0[51:42]) >> 1)) + 
        (army_0_pixel_value[18:12] * army_0_pixel_value[11:5] * army_0_picNum));
    wire [12:0] army_1_addr = (
        (((d_v_cnt - Army_Instance_1[41:32]) >> 1) * army_1_pixel_value[18:12]) + 
        (((d_h_cnt - Army_Instance_1[51:42]) >> 1)) +
        (army_1_pixel_value[18:12] * army_1_pixel_value[11:5] * army_1_picNum));
    wire [1:0] army_0_value, army_1_value;
    Army_Render_Pixel Army_Render_01 (.clk(clk), 
        .type_a(Army_Instance_0[54:52]), .addr_a(army_0_addr), .pixel_value_a(army_0_value),
        .type_b(Army_Instance_1[54:52]), .addr_b(army_1_addr), .pixel_value_b(army_1_value));


// <----------- Storing Value -------------
    reg [1:0] d_cnt;
    reg [1:0] enemy_value_tmp [5:0];
    reg [1:0] army_value_tmp [5:0];
    reg [1:0] enemy_value [7:0];
    reg [1:0] army_value [7:0];
    reg [1:0] next_enemy_value_tmp [5:0];
    reg [1:0] next_army_value_tmp [5:0];
    reg [1:0] next_enemy_value [7:0];
    reg [1:0] next_army_value [7:0];
    always @(posedge clk) begin
        if (rst) begin
            d_cnt <= display_cnt;
        end else begin
            d_cnt <= d_cnt + 1'b1;
        end
        enemy_value_tmp <= next_enemy_value_tmp;
        army_value_tmp <= next_army_value_tmp;
        enemy_value <= next_enemy_value;
        army_value <= next_army_value;
    end
    //   ||      |      |      |      ||  
    //   10      11     00     01     10
    always @(*) begin
        next_enemy_value_tmp = enemy_value_tmp;
        next_army_value_tmp = army_value_tmp;
        next_enemy_value = enemy_value;
        next_army_value = army_value;
        case (d_cnt)
            2'b11: begin
                Enemy_Instance_0 = Enemy_Instance[0];
                Enemy_Instance_1 = Enemy_Instance[1];
                next_enemy_value_tmp[2] = enemy_0_value;
                next_enemy_value_tmp[3] = enemy_1_value;
                Army_Instance_0 = Army_Instance[0];
                Army_Instance_1 = Army_Instance[1];
                next_army_value_tmp[2] = army_0_value;
                next_army_value_tmp[3] = army_1_value;
            end
            2'b00: begin
                Enemy_Instance_0 = Enemy_Instance[2];
                Enemy_Instance_1 = Enemy_Instance[3];
                next_enemy_value_tmp[4] = enemy_0_value;
                next_enemy_value_tmp[5] = enemy_1_value;
                Army_Instance_0 = Army_Instance[2];
                Army_Instance_1 = Army_Instance[3];
                next_army_value_tmp[4] = army_0_value;
                next_army_value_tmp[5] = army_1_value;
            end
            2'b01: begin
                Enemy_Instance_0 = Enemy_Instance[4];
                Enemy_Instance_1 = Enemy_Instance[5];
                next_enemy_value[5:0] = enemy_value_tmp[5:0];
                next_enemy_value[6] = enemy_0_value;
                next_enemy_value[7] = enemy_1_value;
                Army_Instance_0 = Army_Instance[4];
                Army_Instance_1 = Army_Instance[5];
                next_army_value[5:0] = army_value_tmp[5:0];
                next_army_value[6] = army_0_value;
                next_army_value[7] = army_1_value;
            end
            2'b10: begin
                Enemy_Instance_0 = Enemy_Instance[6];
                Enemy_Instance_1 = Enemy_Instance[7];
                next_enemy_value_tmp[0] = enemy_0_value;
                next_enemy_value_tmp[1] = enemy_1_value;
                Army_Instance_0 = Army_Instance[6];
                Army_Instance_1 = Army_Instance[7];
                next_army_value_tmp[0] = army_0_value;
                next_army_value_tmp[1] = army_1_value;
            end
        endcase
    end
// ------------ Storing Value ------------>


    wire [18:0] enemy_pixel_value [7:0];
    Enemy_Pixel EP0 (Enemy_Instance[0][54:52], enemy_pixel_value[0]);
    Enemy_Pixel EP1 (Enemy_Instance[1][54:52], enemy_pixel_value[1]);
    Enemy_Pixel EP2 (Enemy_Instance[2][54:52], enemy_pixel_value[2]);
    Enemy_Pixel EP3 (Enemy_Instance[3][54:52], enemy_pixel_value[3]);
    Enemy_Pixel EP4 (Enemy_Instance[4][54:52], enemy_pixel_value[4]);
    Enemy_Pixel EP5 (Enemy_Instance[5][54:52], enemy_pixel_value[5]);
    Enemy_Pixel EP6 (Enemy_Instance[6][54:52], enemy_pixel_value[6]);
    Enemy_Pixel EP7 (Enemy_Instance[7][54:52], enemy_pixel_value[7]);
    wire [18:0] army_pixel_value [7:0];
    Army_Pixel AP0 (Army_Instance[0][54:52], army_pixel_value[0]);
    Army_Pixel AP1 (Army_Instance[1][54:52], army_pixel_value[1]);
    Army_Pixel AP2 (Army_Instance[2][54:52], army_pixel_value[2]);
    Army_Pixel AP3 (Army_Instance[3][54:52], army_pixel_value[3]);
    Army_Pixel AP4 (Army_Instance[4][54:52], army_pixel_value[4]);
    Army_Pixel AP5 (Army_Instance[5][54:52], army_pixel_value[5]);
    Army_Pixel AP6 (Army_Instance[6][54:52], army_pixel_value[6]);
    Army_Pixel AP7 (Army_Instance[7][54:52], army_pixel_value[7]);

    wire [9:0] tower_enemy_addr_0 = ((av_cnt-90)/3)*20 + ((ah_cnt-10)/3);
    wire [9:0] tower_cat_addr_0 = ((av_cnt-90)/3)*20 + ((ah_cnt-570)/3);
    reg [9:0] tower_enemy_addr, tower_cat_addr;
    always @(posedge clk_25MHz) begin
        tower_enemy_addr <= (tower_enemy_addr_0 < 800 ? tower_enemy_addr_0 : 0);
        tower_cat_addr <= (tower_cat_addr_0 < 800 ? tower_cat_addr_0 : 0);
    end
    wire [1:0] tower_enemy_value, tower_cat_value;
    mem_Tower_Enemy mem_Tower_Enemy (.clka(clk_25MHz), .wea(0), .addra(tower_enemy_addr), .dina(0), .douta(tower_enemy_value));
    mem_Tower_Cat mem_Tower_Cat (.clka(clk_25MHz), .wea(0), .addra(tower_cat_addr), .dina(0), .douta(tower_cat_value));

    wire [8:0] frame_joker_addr_0 = ((av_cnt-290)/4)*25 + ((ah_cnt-105)/4);
    wire [8:0] frame_fish_addr_0 = ((av_cnt-290)/4)*25 + ((ah_cnt-215)/4);
    wire [8:0] frame_trap_addr_0 = ((av_cnt-290)/4)*25 + ((ah_cnt-325)/4);
    wire [8:0] frame_jay_addr_0 = ((av_cnt-290)/4)*25 + ((ah_cnt-435)/4);
    wire [8:0] frame_bomb_addr_0 = ((av_cnt-380)/4)*25 + ((ah_cnt-105)/4);
    wire [8:0] frame_CY_addr_0 = ((av_cnt-380)/4)*25 + ((ah_cnt-215)/4);
    wire [8:0] frame_hacker_addr_0 = ((av_cnt-380)/4)*25 + ((ah_cnt-325)/4);
    wire [8:0] frame_elephant_addr_0 = ((av_cnt-380)/4)*25 + ((ah_cnt-435)/4);
    reg [8:0] frame_joker_addr, frame_fish_addr, frame_trap_addr, frame_jay_addr, frame_bomb_addr, frame_CY_addr, frame_hacker_addr, frame_elephant_addr;
    always @(posedge clk_25MHz) begin
        frame_joker_addr <= (frame_joker_addr_0 < 500 ? frame_joker_addr_0 : 0);
        frame_fish_addr <= (frame_fish_addr_0 < 500 ? frame_fish_addr_0 : 0);
        frame_trap_addr <= (frame_trap_addr_0 < 500 ? frame_trap_addr_0 : 0);
        frame_jay_addr <= (frame_jay_addr_0 < 500 ? frame_jay_addr_0 : 0);
        frame_bomb_addr <= (frame_bomb_addr_0 < 500 ? frame_bomb_addr_0 : 0);
        frame_CY_addr <= (frame_CY_addr_0 < 500 ? frame_CY_addr_0 : 0);
        frame_hacker_addr <= (frame_hacker_addr_0 < 500 ? frame_hacker_addr_0 : 0);
        frame_elephant_addr <= (frame_elephant_addr_0 < 500 ? frame_elephant_addr_0 : 0);
    end
    wire [1:0] frame_joker_value, frame_fish_value, frame_trap_value, frame_jay_value, frame_bomb_value, frame_CY_value, frame_hacker_value, frame_elephant_value;
    mem_Frame_Joker_Cat mem_Frame_Joker_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_joker_addr), .dina(0), .douta(frame_joker_value));
    mem_Frame_Fish_Cat  mem_Frame_Fish_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_fish_addr), .dina(0), .douta(frame_fish_value));
    mem_Frame_Trap_Cat  mem_Frame_Trap_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_trap_addr), .dina(0), .douta(frame_trap_value));
    mem_Frame_Jay_Cat   mem_Frame_Jay_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_jay_addr), .dina(0), .douta(frame_jay_value));
    mem_Frame_Bomb_Cat  mem_Frame_Bomb_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_bomb_addr), .dina(0), .douta(frame_bomb_value));
    mem_Frame_CY_Cat    mem_Frame_CY_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_CY_addr), .dina(0), .douta(frame_CY_value));
    mem_Frame_Hacker_Cat mem_Frame_Hacker_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_hacker_addr), .dina(0), .douta(frame_hacker_value));
    mem_Frame_Elephant_Cat mem_Frame_Elephant_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_elephant_addr), .dina(0), .douta(frame_elephant_value));

    wire [12:0] btn_fire_addr_0 = ((av_cnt-380)/2)*50 + ((ah_cnt-540)/2) + 2500;
    wire [12:0] btn_fire_addr = (btn_fire_addr_0 < 5000 ? btn_fire_addr_0 : 0);
    wire [1:0] btn_fire_value;
    mem_Btn_Fire mem_Btn_Fire (.clka(clk_25MHz), .wea(0), .addra(btn_fire_addr), .dina(0), .douta(btn_fire_value));

    wire [11:0] btn_purse_addr_0 = ((av_cnt-380) >> 1)*50 + ((ah_cnt) >> 1);
    reg [11:0] btn_purse_addr;
    always @(posedge clk_25MHz) begin
        btn_purse_addr <= (btn_purse_addr_0 < 5000 ? btn_purse_addr_0 : 0);
    end
    wire [1:0] btn_purse_value;
    mem_Btn_Purse mem_Btn_Purse (.clka(clk_25MHz), .wea(0), .addra(btn_purse_addr), .dina(0), .douta(btn_purse_value));

    always @(*) begin
        if (v_cnt<10'd270) begin    // simply cut half, this is upper half (gaming) for shortening Circuit Longest Length
            if (Army_Instance[0][55] && 
            h_cnt>=Army_Instance[0][51:42] && h_cnt<Army_Instance[0][51:42]+army_pixel_value[0][18:12] && 
            v_cnt>=Army_Instance[0][41:32] && v_cnt<Army_Instance[0][41:32]+army_pixel_value[0][11:5] && army_value[0] != 2'b11) begin
                case (army_value[0])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[1][55] && 
            h_cnt>=Army_Instance[1][51:42] && h_cnt<Army_Instance[1][51:42]+army_pixel_value[1][18:12] &&
            v_cnt>=Army_Instance[1][41:32] && v_cnt<Army_Instance[1][41:32]+army_pixel_value[1][11:5] && army_value[1] != 2'b11) begin
                case (army_value[1])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[2][55] && 
            h_cnt>=Army_Instance[2][51:42] && h_cnt<Army_Instance[2][51:42]+army_pixel_value[2][18:12] && 
            v_cnt>=Army_Instance[2][41:32] && v_cnt<Army_Instance[2][41:32]+army_pixel_value[2][11:5] && army_value[2] != 2'b11) begin
                case (army_value[2])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[3][55] && 
            h_cnt>=Army_Instance[3][51:42] && h_cnt<Army_Instance[3][51:42]+army_pixel_value[3][18:12] && 
            v_cnt>=Army_Instance[3][41:32] && v_cnt<Army_Instance[3][41:32]+army_pixel_value[3][11:5] && army_value[3] != 2'b11) begin
                case (army_value[3])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[4][55] && 
            h_cnt>=Army_Instance[4][51:42] && h_cnt<Army_Instance[4][51:42]+army_pixel_value[4][18:12] && 
            v_cnt>=Army_Instance[4][41:32] && v_cnt<Army_Instance[4][41:32]+army_pixel_value[4][11:5] && army_value[4] != 2'b11) begin
                case (army_value[4])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[5][55] && 
            h_cnt>=Army_Instance[5][51:42] && h_cnt<Army_Instance[5][51:42]+army_pixel_value[5][18:12] && 
            v_cnt>=Army_Instance[5][41:32] && v_cnt<Army_Instance[5][41:32]+army_pixel_value[5][11:5] && army_value[5] != 2'b11) begin
                case (army_value[5])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[6][55] && 
            h_cnt>=Army_Instance[6][51:42] && h_cnt<Army_Instance[6][51:42]+army_pixel_value[6][18:12] && 
            v_cnt>=Army_Instance[6][41:32] && v_cnt<Army_Instance[6][41:32]+army_pixel_value[6][11:5] && army_value[6] != 2'b11) begin
                case (army_value[6])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[7][55] && 
            h_cnt>=Army_Instance[7][51:42] && h_cnt<Army_Instance[7][51:42]+army_pixel_value[7][18:12] && 
            v_cnt>=Army_Instance[7][41:32] && v_cnt<Army_Instance[7][41:32]+army_pixel_value[7][11:5] && army_value[7] != 2'b11) begin
                case (army_value[7])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[0][55] && 
            h_cnt>=Enemy_Instance[0][51:42] && h_cnt<Enemy_Instance[0][51:42]+enemy_pixel_value[0][18:12] && 
            v_cnt>=Enemy_Instance[0][41:32] && v_cnt<Enemy_Instance[0][41:32]+enemy_pixel_value[0][11:5] && enemy_value[0] != 2'b11) begin
                case (enemy_value[0])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[1][55] && 
            h_cnt>=Enemy_Instance[1][51:42] && h_cnt<Enemy_Instance[1][51:42]+enemy_pixel_value[1][18:12] && 
            v_cnt>=Enemy_Instance[1][41:32] && v_cnt<Enemy_Instance[1][41:32]+enemy_pixel_value[1][11:5] && enemy_value[1] != 2'b11) begin
                case (enemy_value[1])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[2][55] && 
            h_cnt>=Enemy_Instance[2][51:42] && h_cnt<Enemy_Instance[2][51:42]+enemy_pixel_value[2][18:12] && 
            v_cnt>=Enemy_Instance[2][41:32] && v_cnt<Enemy_Instance[2][41:32]+enemy_pixel_value[2][11:5] && enemy_value[2] != 2'b11) begin
                case (enemy_value[2])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[3][55] && 
            h_cnt>=Enemy_Instance[3][51:42] && h_cnt<Enemy_Instance[3][51:42]+enemy_pixel_value[3][18:12] && 
            v_cnt>=Enemy_Instance[3][41:32] && v_cnt<Enemy_Instance[3][41:32]+enemy_pixel_value[3][11:5] && enemy_value[3] != 2'b11) begin
                case (enemy_value[3])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[4][55] && 
            h_cnt>=Enemy_Instance[4][51:42] && h_cnt<Enemy_Instance[4][51:42]+enemy_pixel_value[4][18:12] && 
            v_cnt>=Enemy_Instance[4][41:32] && v_cnt<Enemy_Instance[4][41:32]+enemy_pixel_value[4][11:5] && enemy_value[4] != 2'b11) begin
                case (enemy_value[4])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[5][55] && 
            h_cnt>=Enemy_Instance[5][51:42] && h_cnt<Enemy_Instance[5][51:42]+enemy_pixel_value[5][18:12] && 
            v_cnt>=Enemy_Instance[5][41:32] && v_cnt<Enemy_Instance[5][41:32]+enemy_pixel_value[5][11:5] && enemy_value[5] != 2'b11) begin
                case (enemy_value[5])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[6][55] && 
            h_cnt>=Enemy_Instance[6][51:42] && h_cnt<Enemy_Instance[6][51:42]+enemy_pixel_value[6][18:12] && 
            v_cnt>=Enemy_Instance[6][41:32] && v_cnt<Enemy_Instance[6][41:32]+enemy_pixel_value[6][11:5] && enemy_value[6] != 2'b11) begin
                case (enemy_value[6])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[7][55] && 
            h_cnt>=Enemy_Instance[7][51:42] && h_cnt<Enemy_Instance[7][51:42]+enemy_pixel_value[7][18:12] && 
            v_cnt>=Enemy_Instance[7][41:32] && v_cnt<Enemy_Instance[7][41:32]+enemy_pixel_value[7][11:5] && enemy_value[7] != 2'b11) begin
                case (enemy_value[7])
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt>=10'd10 && h_cnt<10'd70 && v_cnt>=10'd90 && v_cnt<10'd210 && tower_enemy_value!=2'b11) begin
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
            end else begin
                pixel = 12'hfb7;    // board
            end 
        end
    end
endmodule