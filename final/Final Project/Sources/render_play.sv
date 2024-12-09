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
    input [55:0] Enemy_Instance [7:0],
    input [55:0] Army_Instance [7:0],
    input [4:0] genArmyCD [7:0],
    input [6:0] tower_cnt,
    input [9:0] mouseInFrame,
    output reg [11:0] pixel
);

    wire [18:0] enemy_0_pixel_value, enemy_1_pixel_value;
    wire  [2:0] enemy_0_picNum, enemy_1_picNum;
    wire [11:0] enemy_0_diff = enemy_0_pixel_value[18:12] * enemy_0_pixel_value[11:5] * enemy_0_picNum;
    wire [11:0] enemy_1_diff = enemy_1_pixel_value[18:12] * enemy_1_pixel_value[11:5] * enemy_1_picNum;
    Enemy_Pixel EnemyPixel0 (Enemy_Instance[0][54:52], enemy_0_pixel_value);
    Enemy_Pixel EnemyPixel1 (Enemy_Instance[1][54:52], enemy_1_pixel_value);
    PicNum_By_State PicNum_By_State0 (Enemy_Instance[0][19:16], Enemy_Instance[0][46], enemy_0_picNum);
    PicNum_By_State PicNum_By_State1 (Enemy_Instance[1][19:16], Enemy_Instance[1][46], enemy_1_picNum);
    reg [11:0] enemy_0_pp00, enemy_0_pp01, enemy_0_pp10, enemy_0_pp11, enemy_0_pp2;
    reg [11:0] enemy_1_pp00, enemy_1_pp01, enemy_1_pp10, enemy_1_pp11, enemy_1_pp2;
    wire [1:0] enemy_0_value, enemy_1_value;
    always @(posedge clk_25MHz) begin
        enemy_0_pp00 <= ((v_cnt_5 - Enemy_Instance[0][41:32]) >> 1);
        enemy_0_pp01 <= ((h_cnt_5 - Enemy_Instance[0][51:42]) >> 1);
        enemy_0_pp10 <= enemy_0_pp00 * enemy_0_pixel_value[18:12];
        enemy_0_pp11 <= enemy_0_pp01 + enemy_0_diff;
        enemy_0_pp2 <= (enemy_0_pp10 + enemy_0_pp11);
    end
    always @(posedge clk_25MHz) begin
        enemy_1_pp00 <= ((v_cnt_5 - Enemy_Instance[1][41:32]) >> 1);
        enemy_1_pp01 <= ((h_cnt_5 - Enemy_Instance[1][51:42]) >> 1);
        enemy_1_pp10 <= enemy_1_pp00 * enemy_1_pixel_value[18:12];
        enemy_1_pp11 <= enemy_1_pp01 + enemy_1_diff;
        enemy_1_pp2 <= (enemy_1_pp10 + enemy_1_pp11);
    end
    Enemy_Render_Pixel Enemy_Render_01 (.clk(clk_25MHz), 
        .type_a(Enemy_Instance[0][54:52]), .addr_a(enemy_0_pp2), .pixel_value_a(enemy_0_value),
        .type_b(Enemy_Instance[1][54:52]), .addr_b(enemy_1_pp2), .pixel_value_b(enemy_1_value));

    wire [18:0] enemy_2_pixel_value, enemy_3_pixel_value;
    wire  [2:0] enemy_2_picNum, enemy_3_picNum;
    wire [11:0] enemy_2_diff = enemy_2_pixel_value[18:12] * enemy_2_pixel_value[11:5] * enemy_2_picNum;
    wire [11:0] enemy_3_diff = enemy_3_pixel_value[18:12] * enemy_3_pixel_value[11:5] * enemy_3_picNum;
    Enemy_Pixel EnemyPixel2 (Enemy_Instance[2][54:52], enemy_2_pixel_value);
    Enemy_Pixel EnemyPixel3 (Enemy_Instance[3][54:52], enemy_3_pixel_value);
    PicNum_By_State PicNum_By_State2 (Enemy_Instance[2][19:16], Enemy_Instance[2][46], enemy_2_picNum);
    PicNum_By_State PicNum_By_State3 (Enemy_Instance[3][19:16], Enemy_Instance[3][46], enemy_3_picNum);
    reg [11:0] enemy_2_pp00, enemy_2_pp01, enemy_2_pp10, enemy_2_pp11, enemy_2_pp2;
    reg [11:0] enemy_3_pp00, enemy_3_pp01, enemy_3_pp10, enemy_3_pp11, enemy_3_pp2;
    wire [1:0] enemy_2_value, enemy_3_value;
    always @(posedge clk_25MHz) begin
        enemy_2_pp00 <= ((v_cnt_5 - Enemy_Instance[2][41:32]) >> 1);
        enemy_2_pp01 <= ((h_cnt_5 - Enemy_Instance[2][51:42]) >> 1);
        enemy_2_pp10 <= enemy_2_pp00 * enemy_2_pixel_value[18:12];
        enemy_2_pp11 <= enemy_2_pp01 + enemy_2_diff;
        enemy_2_pp2 <= (enemy_2_pp10 + enemy_2_pp11);
    end
    always @(posedge clk_25MHz) begin
        enemy_3_pp00 <= ((v_cnt_5 - Enemy_Instance[3][41:32]) >> 1);
        enemy_3_pp01 <= ((h_cnt_5 - Enemy_Instance[3][51:42]) >> 1);
        enemy_3_pp10 <= enemy_3_pp00 * enemy_3_pixel_value[18:12];
        enemy_3_pp11 <= enemy_3_pp01 + enemy_3_diff;
        enemy_3_pp2 <= (enemy_3_pp10 + enemy_3_pp11);
    end
    Enemy_Render_Pixel Enemy_Render_23 (.clk(clk_25MHz), 
        .type_a(Enemy_Instance[2][54:52]), .addr_a(enemy_2_pp2), .pixel_value_a(enemy_2_value),
        .type_b(Enemy_Instance[3][54:52]), .addr_b(enemy_3_pp2), .pixel_value_b(enemy_3_value));

    wire [18:0] enemy_4_pixel_value, enemy_5_pixel_value;
    wire  [2:0] enemy_4_picNum, enemy_5_picNum;
    wire [11:0] enemy_4_diff = enemy_4_pixel_value[18:12] * enemy_4_pixel_value[11:5] * enemy_4_picNum;
    wire [11:0] enemy_5_diff = enemy_5_pixel_value[18:12] * enemy_5_pixel_value[11:5] * enemy_5_picNum;
    Enemy_Pixel EnemyPixel4 (Enemy_Instance[4][54:52], enemy_4_pixel_value);
    Enemy_Pixel EnemyPixel5 (Enemy_Instance[5][54:52], enemy_5_pixel_value);
    PicNum_By_State PicNum_By_State4 (Enemy_Instance[4][19:16], Enemy_Instance[4][46], enemy_4_picNum);
    PicNum_By_State PicNum_By_State5 (Enemy_Instance[5][19:16], Enemy_Instance[5][46], enemy_5_picNum);
    reg [11:0] enemy_4_pp00, enemy_4_pp01, enemy_4_pp10, enemy_4_pp11, enemy_4_pp2;
    reg [11:0] enemy_5_pp00, enemy_5_pp01, enemy_5_pp10, enemy_5_pp11, enemy_5_pp2;
    wire [1:0] enemy_4_value, enemy_5_value;
    always @(posedge clk_25MHz) begin
        enemy_4_pp00 <= ((v_cnt_5 - Enemy_Instance[4][41:32]) >> 1);
        enemy_4_pp01 <= ((h_cnt_5 - Enemy_Instance[4][51:42]) >> 1);
        enemy_4_pp10 <= enemy_4_pp00 * enemy_4_pixel_value[18:12];
        enemy_4_pp11 <= enemy_4_pp01 + enemy_4_diff;
        enemy_4_pp2 <= (enemy_4_pp10 + enemy_4_pp11);
    end
    always @(posedge clk_25MHz) begin
        enemy_5_pp00 <= ((v_cnt_5 - Enemy_Instance[5][41:32]) >> 1);
        enemy_5_pp01 <= ((h_cnt_5 - Enemy_Instance[5][51:42]) >> 1);
        enemy_5_pp10 <= enemy_5_pp00 * enemy_5_pixel_value[18:12];
        enemy_5_pp11 <= enemy_5_pp01 + enemy_5_diff;
        enemy_5_pp2 <= (enemy_5_pp10 + enemy_5_pp11);
    end
    Enemy_Render_Pixel Enemy_Render_45 (.clk(clk_25MHz), 
        .type_a(Enemy_Instance[4][54:52]), .addr_a(enemy_4_pp2), .pixel_value_a(enemy_4_value),
        .type_b(Enemy_Instance[5][54:52]), .addr_b(enemy_5_pp2), .pixel_value_b(enemy_5_value));

    wire [18:0] enemy_6_pixel_value, enemy_7_pixel_value;
    wire  [2:0] enemy_6_picNum, enemy_7_picNum;
    wire [11:0] enemy_6_diff = enemy_6_pixel_value[18:12] * enemy_6_pixel_value[11:5] * enemy_6_picNum;
    wire [11:0] enemy_7_diff = enemy_7_pixel_value[18:12] * enemy_7_pixel_value[11:5] * enemy_7_picNum;
    Enemy_Pixel EnemyPixel6 (Enemy_Instance[6][54:52], enemy_6_pixel_value);
    Enemy_Pixel EnemyPixel7 (Enemy_Instance[7][54:52], enemy_7_pixel_value);
    PicNum_By_State PicNum_By_State6 (Enemy_Instance[6][19:16], Enemy_Instance[6][46], enemy_6_picNum);
    PicNum_By_State PicNum_By_State7 (Enemy_Instance[7][19:16], Enemy_Instance[7][46], enemy_7_picNum);
    reg [11:0] enemy_6_pp00, enemy_6_pp01, enemy_6_pp10, enemy_6_pp11, enemy_6_pp2;
    reg [11:0] enemy_7_pp00, enemy_7_pp01, enemy_7_pp10, enemy_7_pp11, enemy_7_pp2;
    wire [1:0] enemy_6_value, enemy_7_value;
    always @(posedge clk_25MHz) begin
        enemy_6_pp00 <= ((v_cnt_5 - Enemy_Instance[6][41:32]) >> 1);
        enemy_6_pp01 <= ((h_cnt_5 - Enemy_Instance[6][51:42]) >> 1);
        enemy_6_pp10 <= enemy_6_pp00 * enemy_6_pixel_value[18:12];
        enemy_6_pp11 <= enemy_6_pp01 + enemy_6_diff;
        enemy_6_pp2 <= (enemy_6_pp10 + enemy_6_pp11);
    end
    always @(posedge clk_25MHz) begin
        enemy_7_pp00 <= ((v_cnt_5 - Enemy_Instance[7][41:32]) >> 1);
        enemy_7_pp01 <= ((h_cnt_5 - Enemy_Instance[7][51:42]) >> 1);
        enemy_7_pp10 <= enemy_7_pp00 * enemy_7_pixel_value[18:12];
        enemy_7_pp11 <= enemy_7_pp01 + enemy_7_diff;
        enemy_7_pp2 <= (enemy_7_pp10 + enemy_7_pp11);
    end
    Enemy_Render_Pixel Enemy_Render_67 (.clk(clk_25MHz), 
        .type_a(Enemy_Instance[6][54:52]), .addr_a(enemy_6_pp2), .pixel_value_a(enemy_6_value),
        .type_b(Enemy_Instance[7][54:52]), .addr_b(enemy_7_pp2), .pixel_value_b(enemy_7_value));



    wire [18:0] army_0_pixel_value, army_1_pixel_value;
    wire  [2:0] army_0_picNum, army_1_picNum;
    wire [12:0] army_0_diff = army_0_pixel_value[18:12] * army_0_pixel_value[11:5] * army_0_picNum;
    wire [12:0] army_1_diff = army_1_pixel_value[18:12] * army_1_pixel_value[11:5] * army_1_picNum;
    Army_Pixel ArmyPixel0 (Army_Instance[0][54:52], army_0_pixel_value);
    Army_Pixel ArmyPixel1 (Army_Instance[1][54:52], army_1_pixel_value);
    PicNum_By_State PicNum_By_State0_ (Army_Instance[0][19:16], Army_Instance[0][46], army_0_picNum);
    PicNum_By_State PicNum_By_State1_ (Army_Instance[1][19:16], Army_Instance[1][46], army_1_picNum);
    reg [12:0] army_0_pp00, army_0_pp01, army_0_pp10, army_0_pp11, army_0_pp2;
    reg [12:0] army_1_pp00, army_1_pp01, army_1_pp10, army_1_pp11, army_1_pp2;
    wire [1:0] army_0_value, army_1_value;
    always @(posedge clk_25MHz) begin
        army_0_pp00 <= ((v_cnt_5 - Army_Instance[0][41:32]) >> 1);
        army_0_pp01 <= ((h_cnt_5 - Army_Instance[0][51:42]) >> 1);
        army_0_pp10 <= army_0_pp00 * army_0_pixel_value[18:12];
        army_0_pp11 <= army_0_pp01 + army_0_diff;
        army_0_pp2 <= (army_0_pp10 + army_0_pp11);
    end
    always @(posedge clk_25MHz) begin
        army_1_pp00 <= ((v_cnt_5 - Army_Instance[1][41:32]) >> 1);
        army_1_pp01 <= ((h_cnt_5 - Army_Instance[1][51:42]) >> 1);
        army_1_pp10 <= army_1_pp00 * army_1_pixel_value[18:12];
        army_1_pp11 <= army_1_pp01 + army_1_diff;
        army_1_pp2 <= (army_1_pp10 + army_1_pp11);
    end
    Army_Render_Pixel Army_Render_01 (.clk(clk_25MHz), 
        .type_a(Army_Instance[0][54:52]), .addr_a(army_0_pp2), .pixel_value_a(army_0_value),
        .type_b(Army_Instance[1][54:52]), .addr_b(army_1_pp2), .pixel_value_b(army_1_value));

    wire [18:0] army_2_pixel_value, army_3_pixel_value;
    wire  [2:0] army_2_picNum, army_3_picNum;
    wire [12:0] army_2_diff = army_2_pixel_value[18:12] * army_2_pixel_value[11:5] * army_2_picNum;
    wire [12:0] army_3_diff = army_3_pixel_value[18:12] * army_3_pixel_value[11:5] * army_3_picNum;
    Army_Pixel ArmyPixel2 (Army_Instance[2][54:52], army_2_pixel_value);
    Army_Pixel ArmyPixel3 (Army_Instance[3][54:52], army_3_pixel_value);
    PicNum_By_State PicNum_By_State2_ (Army_Instance[2][19:16], Army_Instance[2][46], army_2_picNum);
    PicNum_By_State PicNum_By_State3_ (Army_Instance[3][19:16], Army_Instance[3][46], army_3_picNum);
    reg [12:0] army_2_pp00, army_2_pp01, army_2_pp10, army_2_pp11, army_2_pp2;
    reg [12:0] army_3_pp00, army_3_pp01, army_3_pp10, army_3_pp11, army_3_pp2;
    wire [1:0] army_2_value, army_3_value;
    always @(posedge clk_25MHz) begin
        army_2_pp00 <= ((v_cnt_5 - Army_Instance[2][41:32]) >> 1);
        army_2_pp01 <= ((h_cnt_5 - Army_Instance[2][51:42]) >> 1);
        army_2_pp10 <= army_2_pp00 * army_2_pixel_value[18:12];
        army_2_pp11 <= army_2_pp01 + army_2_diff;
        army_2_pp2 <= (army_2_pp10 + army_2_pp11);
    end
    always @(posedge clk_25MHz) begin
        army_3_pp00 <= ((v_cnt_5 - Army_Instance[3][41:32]) >> 1);
        army_3_pp01 <= ((h_cnt_5 - Army_Instance[3][51:42]) >> 1);
        army_3_pp10 <= army_3_pp00 * army_3_pixel_value[18:12];
        army_3_pp11 <= army_3_pp01 + army_3_diff;
        army_3_pp2 <= (army_3_pp10 + army_3_pp11);
    end
    Army_Render_Pixel Army_Render_23 (.clk(clk_25MHz), 
        .type_a(Army_Instance[2][54:52]), .addr_a(army_2_pp2), .pixel_value_a(army_2_value),
        .type_b(Army_Instance[3][54:52]), .addr_b(army_3_pp2), .pixel_value_b(army_3_value));

    wire [18:0] army_4_pixel_value, army_5_pixel_value;
    wire  [2:0] army_4_picNum, army_5_picNum;
    wire [12:0] army_4_diff = army_4_pixel_value[18:12] * army_4_pixel_value[11:5] * army_4_picNum;
    wire [12:0] army_5_diff = army_5_pixel_value[18:12] * army_5_pixel_value[11:5] * army_5_picNum;
    Army_Pixel ArmyPixel4 (Army_Instance[4][54:52], army_4_pixel_value);
    Army_Pixel ArmyPixel5 (Army_Instance[5][54:52], army_5_pixel_value);
    PicNum_By_State PicNum_By_State4_ (Army_Instance[4][19:16], Army_Instance[4][46], army_4_picNum);
    PicNum_By_State PicNum_By_State5_ (Army_Instance[5][19:16], Army_Instance[5][46], army_5_picNum);
    reg [12:0] army_4_pp00, army_4_pp01, army_4_pp10, army_4_pp11, army_4_pp2;
    reg [12:0] army_5_pp00, army_5_pp01, army_5_pp10, army_5_pp11, army_5_pp2;
    wire [1:0] army_4_value, army_5_value;
    always @(posedge clk_25MHz) begin
        army_4_pp00 <= ((v_cnt_5 - Army_Instance[4][41:32]) >> 1);
        army_4_pp01 <= ((h_cnt_5 - Army_Instance[4][51:42]) >> 1);
        army_4_pp10 <= army_4_pp00 * army_4_pixel_value[18:12];
        army_4_pp11 <= army_4_pp01 + army_4_diff;
        army_4_pp2 <= (army_4_pp10 + army_4_pp11);
    end
    always @(posedge clk_25MHz) begin
        army_5_pp00 <= ((v_cnt_5 - Army_Instance[5][41:32]) >> 1);
        army_5_pp01 <= ((h_cnt_5 - Army_Instance[5][51:42]) >> 1);
        army_5_pp10 <= army_5_pp00 * army_5_pixel_value[18:12];
        army_5_pp11 <= army_5_pp01 + army_5_diff;
        army_5_pp2 <= (army_5_pp10 + army_5_pp11);
    end
    Army_Render_Pixel Army_Render_45 (.clk(clk_25MHz), 
        .type_a(Army_Instance[4][54:52]), .addr_a(army_4_pp2), .pixel_value_a(army_4_value),
        .type_b(Army_Instance[5][54:52]), .addr_b(army_5_pp2), .pixel_value_b(army_5_value));

    wire [18:0] army_6_pixel_value, army_7_pixel_value;
    wire  [2:0] army_6_picNum, army_7_picNum;
    wire [12:0] army_6_diff = army_6_pixel_value[18:12] * army_6_pixel_value[11:5] * army_6_picNum;
    wire [12:0] army_7_diff = army_7_pixel_value[18:12] * army_7_pixel_value[11:5] * army_7_picNum;
    Army_Pixel ArmyPixel6 (Army_Instance[6][54:52], army_6_pixel_value);
    Army_Pixel ArmyPixel7 (Army_Instance[7][54:52], army_7_pixel_value);
    PicNum_By_State PicNum_By_State6_ (Army_Instance[6][19:16], Army_Instance[6][46], army_6_picNum);
    PicNum_By_State PicNum_By_State7_ (Army_Instance[7][19:16], Army_Instance[7][46], army_7_picNum);
    reg [12:0] army_6_pp00, army_6_pp01, army_6_pp10, army_6_pp11, army_6_pp2;
    reg [12:0] army_7_pp00, army_7_pp01, army_7_pp10, army_7_pp11, army_7_pp2;
    wire [1:0] army_6_value, army_7_value;
    always @(posedge clk_25MHz) begin
        army_6_pp00 <= ((v_cnt_5 - Army_Instance[6][41:32]) >> 1);
        army_6_pp01 <= ((h_cnt_5 - Army_Instance[6][51:42]) >> 1);
        army_6_pp10 <= army_6_pp00 * army_6_pixel_value[18:12];
        army_6_pp11 <= army_6_pp01 + army_6_diff;
        army_6_pp2 <= (army_6_pp10 + army_6_pp11);
    end
    always @(posedge clk_25MHz) begin
        army_7_pp00 <= ((v_cnt_5 - Army_Instance[7][41:32]) >> 1);
        army_7_pp01 <= ((h_cnt_5 - Army_Instance[7][51:42]) >> 1);
        army_7_pp10 <= army_7_pp00 * army_7_pixel_value[18:12];
        army_7_pp11 <= army_7_pp01 + army_7_diff;
        army_7_pp2 <= (army_7_pp10 + army_7_pp11);
    end
    Army_Render_Pixel Army_Render_67 (.clk(clk_25MHz), 
        .type_a(Army_Instance[6][54:52]), .addr_a(army_6_pp2), .pixel_value_a(army_6_value),
        .type_b(Army_Instance[7][54:52]), .addr_b(army_7_pp2), .pixel_value_b(army_7_value));



    reg  [9:0] tower_enemy_pp00, tower_enemy_pp01, tower_enemy_pp10, tower_enemy_pp11, tower_enemy_pp2;
    wire [1:0] tower_enemy_value;
    always @(posedge clk_25MHz) begin
        tower_enemy_pp00 <= ((v_cnt_5-90)/3);
        tower_enemy_pp01 <= ((h_cnt_5-10)/3);
        tower_enemy_pp10 <= tower_enemy_pp00 * 20;
        tower_enemy_pp11 <= tower_enemy_pp01;
        tower_enemy_pp2 <= (tower_enemy_pp10 + tower_enemy_pp11) % 800;
    end
    mem_Tower_Enemy mem_Tower_Enemy_0 (.clka(clk_25MHz), .wea(0), .addra(tower_enemy_pp2),  .dina(0), .douta(tower_enemy_value));

    reg  [9:0] tower_army_pp00, tower_army_pp01, tower_army_pp10, tower_army_pp11, tower_army_pp2;
    wire [1:0] tower_cat_value;
    always @(posedge clk_25MHz) begin
        tower_army_pp00 <= ((v_cnt_5-90)/3);
        tower_army_pp01 <= ((h_cnt_5-570)/3);
        tower_army_pp10 <= tower_army_pp00 * 20;
        tower_army_pp11 <= tower_army_pp01;
        tower_army_pp2 <= (tower_army_pp10 + tower_army_pp11) % 800;
    end
    mem_Tower_Cat mem_Tower_Cat_0 (.clka(clk_25MHz), .wea(0), .addra(tower_army_pp2),  .dina(0), .douta(tower_cat_value));



    reg  [8:0] frame_joker_pp00, frame_joker_pp01, frame_joker_pp10, frame_joker_pp11, frame_joker_pp2;
    wire [1:0] frame_joker_value;
    always @(posedge clk_25MHz) begin
        frame_joker_pp00 <= ((v_cnt_5-290)/4);
        frame_joker_pp01 <= ((h_cnt_5-105)/4);
        frame_joker_pp10 <= frame_joker_pp00 * 25;
        frame_joker_pp11 <= frame_joker_pp01;
        frame_joker_pp2 <= (frame_joker_pp10 + frame_joker_pp11) % 500;
    end
    reg  [8:0] frame_fish_pp00, frame_fish_pp01, frame_fish_pp10, frame_fish_pp11, frame_fish_pp2;
    wire [1:0] frame_fish_value;
    always @(posedge clk_25MHz) begin
        frame_fish_pp00 <= ((v_cnt_5-290)/4);
        frame_fish_pp01 <= ((h_cnt_5-215)/4);
        frame_fish_pp10 <= frame_fish_pp00 * 25;
        frame_fish_pp11 <= frame_fish_pp01;
        frame_fish_pp2 <= (frame_fish_pp10 + frame_fish_pp11) % 500;
    end
    reg  [8:0] frame_trap_pp00, frame_trap_pp01, frame_trap_pp10, frame_trap_pp11, frame_trap_pp2;
    wire [1:0] frame_trap_value;
    always @(posedge clk_25MHz) begin
        frame_trap_pp00 <= ((v_cnt_5-290)/4);
        frame_trap_pp01 <= ((h_cnt_5-325)/4);
        frame_trap_pp10 <= frame_trap_pp00 * 25;
        frame_trap_pp11 <= frame_trap_pp01;
        frame_trap_pp2 <= (frame_trap_pp10 + frame_trap_pp11) % 500;
    end
    reg  [8:0] frame_jay_pp00, frame_jay_pp01, frame_jay_pp10, frame_jay_pp11, frame_jay_pp2;
    wire [1:0] frame_jay_value;
    always @(posedge clk_25MHz) begin
        frame_jay_pp00 <= ((v_cnt_5-290)/4);
        frame_jay_pp01 <= ((h_cnt_5-435)/4);
        frame_jay_pp10 <= frame_jay_pp00 * 25;
        frame_jay_pp11 <= frame_jay_pp01;
        frame_jay_pp2 <= (frame_jay_pp10 + frame_jay_pp11) % 500;
    end
    reg  [8:0] frame_bomb_pp00, frame_bomb_pp01, frame_bomb_pp10, frame_bomb_pp11, frame_bomb_pp2;
    wire [1:0] frame_bomb_value;
    always @(posedge clk_25MHz) begin
        frame_bomb_pp00 <= ((v_cnt_5-380)/4);
        frame_bomb_pp01 <= ((h_cnt_5-105)/4);
        frame_bomb_pp10 <= frame_bomb_pp00 * 25;
        frame_bomb_pp11 <= frame_bomb_pp01;
        frame_bomb_pp2 <= (frame_bomb_pp10 + frame_bomb_pp11) % 500;
    end
    reg  [8:0] frame_CY_pp00, frame_CY_pp01, frame_CY_pp10, frame_CY_pp11, frame_CY_pp2;
    wire [1:0] frame_CY_value;
    always @(posedge clk_25MHz) begin
        frame_CY_pp00 <= ((v_cnt_5-380)/4);
        frame_CY_pp01 <= ((h_cnt_5-215)/4);
        frame_CY_pp10 <= frame_CY_pp00 * 25;
        frame_CY_pp11 <= frame_CY_pp01;
        frame_CY_pp2 <= (frame_CY_pp10 + frame_CY_pp11) % 500;
    end
    reg  [8:0] frame_hacker_pp00, frame_hacker_pp01, frame_hacker_pp10, frame_hacker_pp11, frame_hacker_pp2;
    wire [1:0] frame_hacker_value;
    always @(posedge clk_25MHz) begin
        frame_hacker_pp00 <= ((v_cnt_5-380)/4);
        frame_hacker_pp01 <= ((h_cnt_5-325)/4);
        frame_hacker_pp10 <= frame_hacker_pp00 * 25;
        frame_hacker_pp11 <= frame_hacker_pp01;
        frame_hacker_pp2 <= (frame_hacker_pp10 + frame_hacker_pp11) % 500;
    end
    reg  [8:0] frame_elephant_pp00, frame_elephant_pp01, frame_elephant_pp10, frame_elephant_pp11, frame_elephant_pp2;
    wire [1:0] frame_elephant_value;
    always @(posedge clk_25MHz) begin
        frame_elephant_pp00 <= ((v_cnt_5-380)/4);
        frame_elephant_pp01 <= ((h_cnt_5-435)/4);
        frame_elephant_pp10 <= frame_elephant_pp00 * 25;
        frame_elephant_pp11 <= frame_elephant_pp01;
        frame_elephant_pp2 <= (frame_elephant_pp10 + frame_elephant_pp11) % 500;
    end
    mem_Frame_Joker_Cat mem_Frame_Joker_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_joker_pp2), .dina(0), .douta(frame_joker_value));
    mem_Frame_Fish_Cat  mem_Frame_Fish_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_fish_pp2), .dina(0), .douta(frame_fish_value));
    mem_Frame_Trap_Cat  mem_Frame_Trap_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_trap_pp2), .dina(0), .douta(frame_trap_value));
    mem_Frame_Jay_Cat   mem_Frame_Jay_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_jay_pp2), .dina(0), .douta(frame_jay_value));
    mem_Frame_Bomb_Cat  mem_Frame_Bomb_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_bomb_pp2), .dina(0), .douta(frame_bomb_value));
    mem_Frame_CY_Cat    mem_Frame_CY_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_CY_pp2), .dina(0), .douta(frame_CY_value));
    mem_Frame_Hacker_Cat mem_Frame_Hacker_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_hacker_pp2), .dina(0), .douta(frame_hacker_value));
    mem_Frame_Elephant_Cat mem_Frame_Elephant_Cat (.clka(clk_25MHz), .wea(0), .addra(frame_elephant_pp2), .dina(0), .douta(frame_elephant_value));



    reg [12:0] btn_fire_pp00, btn_fire_pp01, btn_fire_pp10, btn_fire_pp11, btn_fire_pp2;
    wire [1:0] btn_fire_value;
    always @(posedge clk_25MHz) begin
        btn_fire_pp00 <= ((v_cnt_5-380)/2);
        btn_fire_pp01 <= ((h_cnt_5-540)/2);
        btn_fire_pp10 <= btn_fire_pp00 * 50;
        btn_fire_pp11 <= btn_fire_pp01 + 2500;          // TODO
        btn_fire_pp2 <= (btn_fire_pp10 + btn_fire_pp11) % 5000;
    end
    mem_Btn_Fire mem_Btn_Fire_0 (.clka(clk_25MHz), .wea(0), .addra(btn_fire_pp2),  .dina(0), .douta(btn_fire_value));

    reg [11:0] btn_purse_pp00, btn_purse_pp01, btn_purse_pp10, btn_purse_pp11, btn_purse_pp2;
    wire [1:0] btn_purse_value;
    always @(posedge clk_25MHz) begin
        btn_purse_pp00 <= ((v_cnt_5-380)/2);
        btn_purse_pp01 <= ((h_cnt_5)/2);
        btn_purse_pp10 <= btn_purse_pp00 * 50;
        btn_purse_pp11 <= btn_purse_pp01;
        btn_purse_pp2 <= (btn_purse_pp10 + btn_purse_pp11) % 2500;
    end
    mem_Btn_Purse mem_Btn_Purse_0 (.clka(clk_25MHz), .wea(0), .addra(btn_purse_pp2),  .dina(0), .douta(btn_purse_value));



    always @(*) begin
        if (v_cnt_1<10'd270) begin    // simply cut half, this is upper half (gaming) for shortening Circuit Longest Length
            if (Army_Instance[0][55] && 
            h_cnt_1>=Army_Instance[0][51:42] && h_cnt_1<Army_Instance[0][51:42]+(army_0_pixel_value[18:12] << 1) && 
            v_cnt_1>=Army_Instance[0][41:32] && v_cnt_1<Army_Instance[0][41:32]+(army_0_pixel_value[11:5] << 1) && army_0_value != 2'b11) begin
                case (army_0_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[1][55] && 
            h_cnt_1>=Army_Instance[1][51:42] && h_cnt_1<Army_Instance[1][51:42]+(army_1_pixel_value[18:12] << 1) &&
            v_cnt_1>=Army_Instance[1][41:32] && v_cnt_1<Army_Instance[1][41:32]+(army_1_pixel_value[11:5] << 1) && army_1_value != 2'b11) begin
                case (army_1_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[2][55] && 
            h_cnt_1>=Army_Instance[2][51:42] && h_cnt_1<Army_Instance[2][51:42]+(army_2_pixel_value[18:12] << 1) && 
            v_cnt_1>=Army_Instance[2][41:32] && v_cnt_1<Army_Instance[2][41:32]+(army_2_pixel_value[11:5] << 1) && army_2_value != 2'b11) begin
                case (army_2_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[3][55] && 
            h_cnt_1>=Army_Instance[3][51:42] && h_cnt_1<Army_Instance[3][51:42]+(army_3_pixel_value[18:12] << 1) && 
            v_cnt_1>=Army_Instance[3][41:32] && v_cnt_1<Army_Instance[3][41:32]+(army_3_pixel_value[11:5] << 1) && army_3_value != 2'b11) begin
                case (army_3_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[4][55] && 
            h_cnt_1>=Army_Instance[4][51:42] && h_cnt_1<Army_Instance[4][51:42]+(army_4_pixel_value[18:12] << 1) && 
            v_cnt_1>=Army_Instance[4][41:32] && v_cnt_1<Army_Instance[4][41:32]+(army_4_pixel_value[11:5] << 1) && army_4_value != 2'b11) begin
                case (army_4_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[5][55] && 
            h_cnt_1>=Army_Instance[5][51:42] && h_cnt_1<Army_Instance[5][51:42]+(army_5_pixel_value[18:12] << 1) && 
            v_cnt_1>=Army_Instance[5][41:32] && v_cnt_1<Army_Instance[5][41:32]+(army_5_pixel_value[11:5] << 1) && army_5_value != 2'b11) begin
                case (army_5_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[6][55] && 
            h_cnt_1>=Army_Instance[6][51:42] && h_cnt_1<Army_Instance[6][51:42]+(army_6_pixel_value[18:12] << 1) && 
            v_cnt_1>=Army_Instance[6][41:32] && v_cnt_1<Army_Instance[6][41:32]+(army_6_pixel_value[11:5] << 1) && army_6_value != 2'b11) begin
                case (army_6_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[7][55] && 
            h_cnt_1>=Army_Instance[7][51:42] && h_cnt_1<Army_Instance[7][51:42]+(army_7_pixel_value[18:12] << 1) && 
            v_cnt_1>=Army_Instance[7][41:32] && v_cnt_1<Army_Instance[7][41:32]+(army_7_pixel_value[11:5] << 1) && army_7_value != 2'b11) begin
                case (army_7_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[0][55] && 
            h_cnt_1>=Enemy_Instance[0][51:42] && h_cnt_1<Enemy_Instance[0][51:42]+(enemy_0_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[0][41:32] && v_cnt_1<Enemy_Instance[0][41:32]+(enemy_0_pixel_value[11:5] << 1) && enemy_0_value != 2'b11) begin
                case (enemy_0_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[1][55] && 
            h_cnt_1>=Enemy_Instance[1][51:42] && h_cnt_1<Enemy_Instance[1][51:42]+(enemy_1_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[1][41:32] && v_cnt_1<Enemy_Instance[1][41:32]+(enemy_1_pixel_value[11:5] << 1) && enemy_1_value != 2'b11) begin
                case (enemy_1_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[2][55] && 
            h_cnt_1>=Enemy_Instance[2][51:42] && h_cnt_1<Enemy_Instance[2][51:42]+(enemy_2_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[2][41:32] && v_cnt_1<Enemy_Instance[2][41:32]+(enemy_2_pixel_value[11:5] << 1) && enemy_2_value != 2'b11) begin
                case (enemy_2_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[3][55] && 
            h_cnt_1>=Enemy_Instance[3][51:42] && h_cnt_1<Enemy_Instance[3][51:42]+(enemy_3_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[3][41:32] && v_cnt_1<Enemy_Instance[3][41:32]+(enemy_3_pixel_value[11:5] << 1) && enemy_3_value != 2'b11) begin
                case (enemy_3_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[4][55] && 
            h_cnt_1>=Enemy_Instance[4][51:42] && h_cnt_1<Enemy_Instance[4][51:42]+(enemy_4_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[4][41:32] && v_cnt_1<Enemy_Instance[4][41:32]+(enemy_4_pixel_value[11:5] << 1) && enemy_4_value != 2'b11) begin
                case (enemy_4_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[5][55] && 
            h_cnt_1>=Enemy_Instance[5][51:42] && h_cnt_1<Enemy_Instance[5][51:42]+(enemy_5_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[5][41:32] && v_cnt_1<Enemy_Instance[5][41:32]+(enemy_5_pixel_value[11:5] << 1) && enemy_5_value != 2'b11) begin
                case (enemy_5_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[6][55] && 
            h_cnt_1>=Enemy_Instance[6][51:42] && h_cnt_1<Enemy_Instance[6][51:42]+(enemy_6_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[6][41:32] && v_cnt_1<Enemy_Instance[6][41:32]+(enemy_6_pixel_value[11:5] << 1) && enemy_6_value != 2'b11) begin
                case (enemy_6_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[7][55] && 
            h_cnt_1>=Enemy_Instance[7][51:42] && h_cnt_1<Enemy_Instance[7][51:42]+(enemy_7_pixel_value[18:12] << 1) && 
            v_cnt_1>=Enemy_Instance[7][41:32] && v_cnt_1<Enemy_Instance[7][41:32]+(enemy_7_pixel_value[11:5] << 1) && enemy_7_value != 2'b11) begin
                case (enemy_7_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd10 && h_cnt_1<10'd70 && v_cnt_1>=10'd90 && v_cnt_1<10'd210 && tower_enemy_value!=2'b11) begin
                case (tower_enemy_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd570 && h_cnt_1<10'd630 && v_cnt_1>=10'd90 && v_cnt_1<10'd210 && tower_cat_value!=2'b11) begin
                case (tower_cat_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (v_cnt_1>=10'd170 && v_cnt_1<10'd230) begin
                pixel = 12'hda5;    // path
            end else if (v_cnt_1>=10'd140) begin
                pixel = 12'h5b2;    // grass
            end else begin
                pixel = 12'h2bf;    // sky
            end
        end else begin              // simply cut half, this is lower half (board) for shortening Circuit Longest Length
            if (h_cnt_1>=10'd105 && h_cnt_1<10'd205 && v_cnt_1>=10'd290 && v_cnt_1<10'd370) begin
                case (frame_joker_value)
                    2'b00: pixel = (genArmyCD[0]==5'd0 ? 12'hfff : ((h_cnt-10'd105)>(genArmyCD[0]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd215 && h_cnt_1<10'd315 && v_cnt_1>=10'd290 && v_cnt_1<10'd370) begin
                case (frame_fish_value)
                    2'b00: pixel = (genArmyCD[1]==5'd0 ? 12'hfff : ((h_cnt-10'd215)>(genArmyCD[1]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd325 && h_cnt_1<10'd425 && v_cnt_1>=10'd290 && v_cnt_1<10'd370) begin
                case (frame_trap_value)
                    2'b00: pixel = (genArmyCD[2]==5'd0 ? 12'hfff : ((h_cnt-10'd325)>(genArmyCD[2]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd435 && h_cnt_1<10'd535 && v_cnt_1>=10'd290 && v_cnt_1<10'd370) begin
                case (frame_jay_value)
                    2'b00: pixel = (genArmyCD[3]==5'd0 ? 12'hfff : ((h_cnt-10'd435)>(genArmyCD[3]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd105 && h_cnt_1<10'd205 && v_cnt_1>=10'd380 && v_cnt_1<10'd460) begin
                case (frame_bomb_value)
                    2'b00: pixel = (genArmyCD[4]==5'd0 ? 12'hfff : ((h_cnt-10'd105)>(genArmyCD[4]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd215 && h_cnt_1<10'd315 && v_cnt_1>=10'd380 && v_cnt_1<10'd460) begin
                case (frame_CY_value)
                    2'b00: pixel = (genArmyCD[5]==5'd0 ? 12'hfff : ((h_cnt-10'd215)>(genArmyCD[5]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd325 && h_cnt_1<10'd425 && v_cnt_1>=10'd380 && v_cnt_1<10'd460) begin
                case (frame_hacker_value)
                    2'b00: pixel = (genArmyCD[6]==5'd0 ? 12'hfff : ((h_cnt-10'd325)>(genArmyCD[6]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd435 && h_cnt_1<10'd535 && v_cnt_1>=10'd380 && v_cnt_1<10'd460) begin
                case (frame_elephant_value)
                    2'b00: pixel = (genArmyCD[7]==5'd0 ? 12'hfff : ((h_cnt-10'd435)>(genArmyCD[7]*3) ? 12'h666 : 12'hfff));
                    // 2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1<10'd100 && v_cnt_1>=10'd380 && btn_purse_value!=2'b11) begin
                case (btn_purse_value)      // purse
                    2'b00: pixel = 12'ha63;
                    default: pixel = 12'h000;
                endcase
            end else if (h_cnt_1>=10'd540 && v_cnt_1>=10'd380 && btn_fire_value!=2'b11) begin
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