`define W_PP 18:12
`define H_PP 11:5
`define D_PP 4:0

`define       EXIST_P  55
`define        TYPE_P  54:52
`define           X_P  51:42
`define           Y_P  41:32
`define          HP_P  31:20
`define       STATE_P  19:16
`define   STATE_CNT_P  15:12
`define  BE_DAMAGED_P  11:0

module Render_Play (
    input clk,
    input [9:0] h_cnt,
    input [9:0] ah_cnt,
    input [9:0] v_cnt,
    input [9:0] av_cnt,
    input [55:0] Enemy_Instance [15:0],
    input [55:0] Army_Instance [15:0],
    input [9:0] mouseInFrame,
    output reg [11:0] pixel
);

    reg [18:0] enemy_0_pixel_value;
    reg  [2:0] enemy_0_picnum;
    Enemy_Pixel EnemyPixel0 (Enemy_Instance[0][`TYPE_P], enemy_0_pixel_value);
    STATS_acc_PIC STATS_acc_PIC0 (Enemy_Instance[0][`STATE_P], Enemy_Instance[0][`X_P], enemy_0_picnum);
    wire [11:0] enemy_0_addr = (((av_cnt - Enemy_Instance[0][`Y_P]) >> 1) * enemy_0_pixel_value[`W_PP]) + (((ah_cnt - Enemy_Instance[0][`X_P])) >> 1) + (enemy_0_pixel_value[`W_PP] * enemy_0_pixel_value[`H_pp] * enemy_0_picnum);   
    wire [1:0] enemy_0_value;
    Enemy_Render_Pixel enemy_0_Render (.clk(clk), .type(Enemy_Instance[0][`TYPE_P]), .addr(enemy_0_addr), .pixel_value(enemy_0_value));

    reg [18:0] enemy_1_pixel_value;
    reg  [2:0] enemy_1_picnum;
    Enemy_Pixel EnemyPixel1 (Enemy_Instance[1][`TYPE_P], enemy_1_pixel_value);
    STATS_acc_PIC STATS_acc_PIC1 (Enemy_Instance[1][`STATE_P], Enemy_Instance[1][`X_P], enemy_1_picnum);
    wire [11:0] enemy_1_addr = (((av_cnt - Enemy_Instance[1][`Y_P]) >> 1) * enemy_1_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[1][`X_P])) >> 1) + (enemy_1_pixel_value[`W_PP] * enemy_1_pixel_value[`H_pp] * enemy_1_picnum);   
    wire [1:0] enemy_1_value;
    Enemy_Render_Pixel enemy_1_Render (.clk(clk), .type(Enemy_Instance[1][`TYPE_P]), .addr(enemy_1_addr), .pixel_value(enemy_1_value));

    reg [18:0] enemy_2_pixel_value;
    reg  [2:0] enemy_2_picnum;
    Enemy_Pixel EnemyPixel2 (Enemy_Instance[2][`TYPE_P], enemy_2_pixel_value);
    STATS_acc_PIC STATS_acc_PIC2 (Enemy_Instance[2][`STATE_P], Enemy_Instance[2][`X_P], enemy_2_picnum);
    wire [11:0] enemy_2_addr = (((av_cnt - Enemy_Instance[2][`Y_P]) >> 1) * enemy_2_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[1][`X_P])) >> 1) + (enemy_2_pixel_value[`W_PP] * enemy_2_pixel_value[`H_pp] * enemy_2_picnum);
    wire [1:0] enemy_2_value;
    Enemy_Render_Pixel enemy_2_Render (.clk(clk), .type(Enemy_Instance[2][`TYPE_P]), .addr(enemy_2_addr), .pixel_value(enemy_2_value));

    reg [18:0] enemy_3_pixel_value;
    reg  [2:0] enemy_3_picnum;
    Enemy_Pixel EnemyPixel3 (Enemy_Instance[3][`TYPE_P], enemy_3_pixel_value);
    STATS_acc_PIC STATS_acc_PIC3 (Enemy_Instance[3][`STATE_P], Enemy_Instance[3][`X_P], enemy_3_picnum);
    wire [11:0] enemy_3_addr = (((av_cnt - Enemy_Instance[3][`Y_P]) >> 1) * enemy_3_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[3][`X_P])) >> 1) + (enemy_3_pixel_value[`W_PP] * enemy_3_pixel_value[`H_pp] * enemy_3_picnum);
    wire [1:0] enemy_3_value;
    Enemy_Render_Pixel enemy_3_Render (.clk(clk), .type(Enemy_Instance[3][`TYPE_P]), .addr(enemy_3_addr), .pixel_value(enemy_3_value));

    reg [18:0] enemy_4_pixel_value;
    reg  [2:0] enemy_4_picnum;
    Enemy_Pixel EnemyPixel4 (Enemy_Instance[4][`TYPE_P], enemy_4_pixel_value);
    STATS_acc_PIC STATS_acc_PIC4 (Enemy_Instance[4][`STATE_P], Enemy_Instance[4][`X_P], enemy_4_picnum);
    wire [11:0] enemy_4_addr = (((av_cnt - Enemy_Instance[4][`Y_P]) >> 1) * enemy_4_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[4][`X_P])) >> 1) + (enemy_4_pixel_value[`W_PP] * enemy_4_pixel_value[`H_pp] * enemy_4_picnum);
    wire [1:0] enemy_4_value;
    Enemy_Render_Pixel enemy_4_Render (.clk(clk), .type(Enemy_Instance[4][`TYPE_P]), .addr(enemy_4_addr), .pixel_value(enemy_4_value));

    reg [18:0] enemy_5_pixel_value;
    reg  [2:0] enemy_5_picnum;
    Enemy_Pixel EnemyPixel5 (Enemy_Instance[5][`TYPE_P], enemy_5_pixel_value);
    STATS_acc_PIC STATS_acc_PIC5 (Enemy_Instance[5][`STATE_P], Enemy_Instance[5][`X_P], enemy_5_picnum);
    wire [11:0] enemy_5_addr = (((av_cnt - Enemy_Instance[5][`Y_P]) >> 1) * enemy_5_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[5][`X_P])) >> 1) + (enemy_5_pixel_value[`W_PP] * enemy_5_pixel_value[`H_pp] * enemy_5_picnum);
    wire [1:0] enemy_5_value;
    Enemy_Render_Pixel enemy_5_Render (.clk(clk), .type(Enemy_Instance[5][`TYPE_P]), .addr(enemy_5_addr), .pixel_value(enemy_5_value));

    reg [18:0] enemy_6_pixel_value;
    reg  [2:0] enemy_6_picnum;
    Enemy_Pixel EnemyPixel6 (Enemy_Instance[6][`TYPE_P], enemy_6_pixel_value);
    STATS_acc_PIC STATS_acc_PIC6 (Enemy_Instance[6][`STATE_P], Enemy_Instance[6][`X_P], enemy_6_picnum);
    wire [11:0] enemy_6_addr = (((av_cnt - Enemy_Instance[6][`Y_P]) >> 1) * enemy_6_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[6][`X_P])) >> 1) + (enemy_6_pixel_value[`W_PP] * enemy_6_pixel_value[`H_pp] * enemy_6_picnum);
    wire [1:0] enemy_6_value;
    Enemy_Render_Pixel enemy_6_Render (.clk(clk), .type(Enemy_Instance[6][`TYPE_P]), .addr(enemy_6_addr), .pixel_value(enemy_6_value));

    reg [18:0] enemy_7_pixel_value;
    reg  [2:0] enemy_7_picnum;
    Enemy_Pixel EnemyPixel7 (Enemy_Instance[7][`TYPE_P], enemy_7_pixel_value);
    STATS_acc_PIC STATS_acc_PIC7 (Enemy_Instance[7][`STATE_P], Enemy_Instance[7][`X_P], enemy_7_picnum);
    wire [11:0] enemy_7_addr = (((av_cnt - Enemy_Instance[7][`Y_P]) >> 1) * enemy_7_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[7][`X_P])) >> 1) + (enemy_7_pixel_value[`W_PP] * enemy_7_pixel_value[`H_pp] * enemy_7_picnum);
    wire [1:0] enemy_7_value;
    Enemy_Render_Pixel enemy_7_Render (.clk(clk), .type(Enemy_Instance[7][`TYPE_P]), .addr(enemy_7_addr), .pixel_value(enemy_7_value));

    reg [18:0] enemy_8_pixel_value;
    reg  [2:0] enemy_8_picnum;
    Enemy_Pixel EnemyPixel8 (Enemy_Instance[8][`TYPE_P], enemy_8_pixel_value);
    STATS_acc_PIC STATS_acc_PIC8 (Enemy_Instance[8][`STATE_P], Enemy_Instance[8][`X_P], enemy_8_picnum);
    wire [11:0] enemy_8_addr = (((av_cnt - Enemy_Instance[8][`Y_P]) >> 1) * enemy_8_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[8][`X_P])) >> 1) + (enemy_8_pixel_value[`W_PP] * enemy_8_pixel_value[`H_pp] * enemy_8_picnum);
    wire [1:0] enemy_8_value;
    Enemy_Render_Pixel enemy_8_Render (.clk(clk), .type(Enemy_Instance[8][`TYPE_P]), .addr(enemy_8_addr), .pixel_value(enemy_8_value));

    reg [18:0] enemy_9_pixel_value;
    reg  [2:0] enemy_9_picnum;
    Enemy_Pixel EnemyPixel9 (Enemy_Instance[9][`TYPE_P], enemy_9_pixel_value);
    STATS_acc_PIC STATS_acc_PIC9 (Enemy_Instance[9][`STATE_P], Enemy_Instance[9][`X_P], enemy_9_picnum);
    wire [11:0] enemy_9_addr = (((av_cnt - Enemy_Instance[9][`Y_P]) >> 1) * enemy_9_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[9][`X_P])) >> 1) + (enemy_9_pixel_value[`W_PP] * enemy_9_pixel_value[`H_pp] * enemy_9_picnum);
    wire [1:0] enemy_9_value;
    Enemy_Render_Pixel enemy_9_Render (.clk(clk), .type(Enemy_Instance[9][`TYPE_P]), .addr(enemy_9_addr), .pixel_value(enemy_9_value));

    reg [18:0] enemy_10_pixel_value;
    reg  [2:0] enemy_10_picnum;
    Enemy_Pixel EnemyPixel10 (Enemy_Instance[10][`TYPE_P], enemy_10_pixel_value);
    STATS_acc_PIC STATS_acc_PIC10 (Enemy_Instance[10][`STATE_P], Enemy_Instance[10][`X_P], enemy_10_picnum);
    wire [11:0] enemy_10_addr = (((av_cnt - Enemy_Instance[10][`Y_P]) >> 1) * enemy_10_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[10][`X_P])) >> 1) + (enemy_10_pixel_value[`W_PP] * enemy_10_pixel_value[`H_pp] * enemy_10_picnum);
    wire [1:0] enemy_10_value;
    Enemy_Render_Pixel enemy_10_Render (.clk(clk), .type(Enemy_Instance[10][`TYPE_P]), .addr(enemy_10_addr), .pixel_value(enemy_10_value));

    reg [18:0] enemy_11_pixel_value;
    reg  [2:0] enemy_11_picnum;
    Enemy_Pixel EnemyPixel11 (Enemy_Instance[11][`TYPE_P], enemy_11_pixel_value);
    STATS_acc_PIC STATS_acc_PIC11 (Enemy_Instance[11][`STATE_P], Enemy_Instance[11][`X_P], enemy_11_picnum);
    wire [11:0] enemy_11_addr = (((av_cnt - Enemy_Instance[11][`Y_P]) >> 1) * enemy_11_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[11][`X_P])) >> 1) + (enemy_11_pixel_value[`W_PP] * enemy_11_pixel_value[`H_pp] * enemy_11_picnum);
    wire [1:0] enemy_11_value;
    Enemy_Render_Pixel enemy_11_Render (.clk(clk), .type(Enemy_Instance[11][`TYPE_P]), .addr(enemy_11_addr), .pixel_value(enemy_11_value));

    reg [18:0] enemy_12_pixel_value;
    reg  [2:0] enemy_12_picnum;
    Enemy_Pixel EnemyPixel12 (Enemy_Instance[12][`TYPE_P], enemy_12_pixel_value);
    STATS_acc_PIC STATS_acc_PIC12 (Enemy_Instance[12][`STATE_P], Enemy_Instance[12][`X_P], enemy_12_picnum);
    wire [11:0] enemy_12_addr = (((av_cnt - Enemy_Instance[12][`Y_P]) >> 1) * enemy_12_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[12][`X_P])) >> 1) + (enemy_12_pixel_value[`W_PP] * enemy_12_pixel_value[`H_pp] * enemy_12_picnum);
    wire [1:0] enemy_12_value;
    Enemy_Render_Pixel enemy_12_Render (.clk(clk), .type(Enemy_Instance[12][`TYPE_P]), .addr(enemy_12_addr), .pixel_value(enemy_12_value));

    reg [18:0] enemy_13_pixel_value;
    reg  [2:0] enemy_13_picnum;
    Enemy_Pixel EnemyPixel13 (Enemy_Instance[13][`TYPE_P], enemy_13_pixel_value);
    STATS_acc_PIC STATS_acc_PIC13 (Enemy_Instance[13][`STATE_P], Enemy_Instance[13][`X_P], enemy_13_picnum);
    wire [11:0] enemy_13_addr = (((av_cnt - Enemy_Instance[13][`Y_P]) >> 1) * enemy_13_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[13][`X_P])) >> 1) + (enemy_13_pixel_value[`W_PP] * enemy_13_pixel_value[`H_pp] * enemy_13_picnum);
    wire [1:0] enemy_13_value;
    Enemy_Render_Pixel enemy_13_Render (.clk(clk), .type(Enemy_Instance[13][`TYPE_P]), .addr(enemy_13_addr), .pixel_value(enemy_13_value));

    reg [18:0] enemy_14_pixel_value;
    reg  [2:0] enemy_14_picnum;
    Enemy_Pixel EnemyPixel14 (Enemy_Instance[14][`TYPE_P], enemy_14_pixel_value);
    STATS_acc_PIC STATS_acc_PIC14 (Enemy_Instance[14][`STATE_P], Enemy_Instance[14][`X_P], enemy_14_picnum);
    wire [11:0] enemy_14_addr = (((av_cnt - Enemy_Instance[14][`Y_P]) >> 1) * enemy_14_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[14][`X_P])) >> 1) + (enemy_14_pixel_value[`W_PP] * enemy_14_pixel_value[`H_pp] * enemy_14_picnum);
    wire [1:0] enemy_14_value;
    Enemy_Render_Pixel enemy_14_Render (.clk(clk), .type(Enemy_Instance[14][`TYPE_P]), .addr(enemy_14_addr), .pixel_value(enemy_14_value));

    reg [18:0] enemy_15_pixel_value;
    reg  [2:0] enemy_15_picnum;
    Enemy_Pixel EnemyPixel15 (Enemy_Instance[15][`TYPE_P], enemy_15_pixel_value);
    STATS_acc_PIC STATS_acc_PIC15 (Enemy_Instance[15][`STATE_P], Enemy_Instance[15][`X_P], enemy_15_picnum);
    wire [11:0] enemy_15_addr = (((av_cnt - Enemy_Instance[15][`Y_P]) >> 1) * enemy_15_pixel_value[`W_PP]) + (((ah_cnt-Enemy_Instance[15][`X_P])) >> 1) + (enemy_15_pixel_value[`W_PP] * enemy_15_pixel_value[`H_pp] * enemy_15_picnum);
    wire [1:0] enemy_15_value;
    Enemy_Render_Pixel enemy_15_Render (.clk(clk), .type(Enemy_Instance[15][`TYPE_P]), .addr(enemy_15_addr), .pixel_value(enemy_15_value));

    
    reg [18:0] army_0_pixel_value;
    reg  [2:0] army_0_picnum;
    Army_Pixel ArmyPixel0 (Army_Instance[0][`TYPE_P], army_0_pixel_value);
    STATS_acc_PIC STATS_acc_PIC16 (Army_Instance[0][`STATE_P], Army_Instance[0][`X_P], army_0_picnum);
    wire [12:0] army_0_addr = (((av_cnt - Army_Instance[0][`Y_P]) >> 1) * army_0_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[0][`X_P])) >> 1) + (army_0_pixel_value[`W_PP] * army_0_pixel_value[`H_pp] * army_0_picnum);
    wire [1:0] army_0_value;
    Army_Render_Pixel army_0_Render (.clk(clk), .type(Army_Instance[0][`TYPE_P]), .addr(army_0_addr), .pixel_value(army_0_value));

    reg [18:0] army_1_pixel_value;
    reg  [2:0] army_1_picnum;
    Army_Pixel ArmyPixel1 (Army_Instance[1][`TYPE_P], army_1_pixel_value);
    STATS_acc_PIC STATS_acc_PIC17 (Army_Instance[1][`STATE_P], Army_Instance[1][`X_P], army_1_picnum);
    wire [12:0] army_1_addr = (((av_cnt - Army_Instance[1][`Y_P]) >> 1) * army_1_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[1][`X_P])) >> 1) + (army_1_pixel_value[`W_PP] * army_1_pixel_value[`H_pp] * army_1_picnum);
    wire [1:0] army_1_value;
    Army_Render_Pixel army_1_Render (.clk(clk), .type(Army_Instance[1][`TYPE_P]), .addr(army_1_addr), .pixel_value(army_1_value));

    reg [18:0] army_2_pixel_value;
    reg  [2:0] army_2_picnum;
    Army_Pixel ArmyPixel2 (Army_Instance[2][`TYPE_P], army_2_pixel_value);
    STATS_acc_PIC STATS_acc_PIC18 (Army_Instance[2][`STATE_P], Army_Instance[2][`X_P], army_2_picnum);
    wire [12:0] army_2_addr = (((av_cnt - Army_Instance[2][`Y_P]) >> 1) * army_2_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[2][`X_P])) >> 1) + (army_2_pixel_value[`W_PP] * army_2_pixel_value[`H_pp] * army_2_picnum);
    wire [1:0] army_2_value;
    Army_Render_Pixel army_2_Render (.clk(clk), .type(Army_Instance[2][`TYPE_P]), .addr(army_2_addr), .pixel_value(army_2_value));

    reg [18:0] army_3_pixel_value;
    reg  [2:0] army_3_picnum;
    Army_Pixel ArmyPixel3 (Army_Instance[3][`TYPE_P], army_3_pixel_value);
    STATS_acc_PIC STATS_acc_PIC19 (Army_Instance[3][`STATE_P], Army_Instance[3][`X_P], army_3_picnum);
    wire [12:0] army_3_addr = (((av_cnt - Army_Instance[3][`Y_P]) >> 1) * army_3_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[3][`X_P])) >> 1) + (army_3_pixel_value[`W_PP] * army_3_pixel_value[`H_pp] * army_3_picnum);
    wire [1:0] army_3_value;
    Army_Render_Pixel army_3_Render (.clk(clk), .type(Army_Instance[3][`TYPE_P]), .addr(army_3_addr), .pixel_value(army_3_value));

    reg [18:0] army_4_pixel_value;
    reg  [2:0] army_4_picnum;
    Army_Pixel ArmyPixel4 (Army_Instance[4][`TYPE_P], army_4_pixel_value);
    STATS_acc_PIC STATS_acc_PIC20 (Army_Instance[4][`STATE_P], Army_Instance[4][`X_P], army_4_picnum);
    wire [12:0] army_4_addr = (((av_cnt - Army_Instance[4][`Y_P]) >> 1) * army_4_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[4][`X_P])) >> 1) + (army_4_pixel_value[`W_PP] * army_4_pixel_value[`H_pp] * army_4_picnum);
    wire [1:0] army_4_value;
    Army_Render_Pixel army_4_Render (.clk(clk), .type(Army_Instance[4][`TYPE_P]), .addr(army_4_addr), .pixel_value(army_4_value));

    reg [18:0] army_5_pixel_value;
    reg  [2:0] army_5_picnum;
    Army_Pixel ArmyPixel5 (Army_Instance[5][`TYPE_P], army_5_pixel_value);
    STATS_acc_PIC STATS_acc_PIC21 (Army_Instance[5][`STATE_P], Army_Instance[5][`X_P], army_5_picnum);
    wire [12:0] army_5_addr = (((av_cnt - Army_Instance[5][`Y_P]) >> 1) * army_5_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[5][`X_P])) >> 1) + (army_5_pixel_value[`W_PP] * army_5_pixel_value[`H_pp] * army_5_picnum);
    wire [1:0] army_5_value;
    Army_Render_Pixel army_5_Render (.clk(clk), .type(Army_Instance[5][`TYPE_P]), .addr(army_5_addr), .pixel_value(army_5_value));

    reg [18:0] army_6_pixel_value;
    reg  [2:0] army_6_picnum;
    Army_Pixel ArmyPixel6 (Army_Instance[6][`TYPE_P], army_6_pixel_value);
    STATS_acc_PIC STATS_acc_PIC22 (Army_Instance[6][`STATE_P], Army_Instance[6][`X_P], army_6_picnum);
    wire [12:0] army_6_addr = (((av_cnt - Army_Instance[6][`Y_P]) >> 1) * army_6_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[6][`X_P])) >> 1) + (army_6_pixel_value[`W_PP] * army_6_pixel_value[`H_pp] * army_6_picnum);
    wire [1:0] army_6_value;
    Army_Render_Pixel army_6_Render (.clk(clk), .type(Army_Instance[6][`TYPE_P]), .addr(army_6_addr), .pixel_value(army_6_value));

    reg [18:0] army_7_pixel_value;
    reg  [2:0] army_7_picnum;
    Army_Pixel ArmyPixel7 (Army_Instance[7][`TYPE_P], army_7_pixel_value);
    STATS_acc_PIC STATS_acc_PIC23 (Army_Instance[7][`STATE_P], Army_Instance[7][`X_P], army_7_picnum);
    wire [12:0] army_7_addr = (((av_cnt - Army_Instance[7][`Y_P]) >> 1) * army_7_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[7][`X_P])) >> 1) + (army_7_pixel_value[`W_PP] * army_7_pixel_value[`H_pp] * army_7_picnum);
    wire [1:0] army_7_value;
    Army_Render_Pixel army_7_Render (.clk(clk), .type(Army_Instance[7][`TYPE_P]), .addr(army_7_addr), .pixel_value(army_7_value));

    reg [18:0] army_8_pixel_value;
    reg  [2:0] army_8_picnum;
    Army_Pixel ArmyPixel8 (Army_Instance[8][`TYPE_P], army_8_pixel_value);
    STATS_acc_PIC STATS_acc_PIC24 (Army_Instance[8][`STATE_P], Army_Instance[8][`X_P], army_8_picnum);
    wire [12:0] army_8_addr = (((av_cnt - Army_Instance[8][`Y_P]) >> 1) * army_8_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[8][`X_P])) >> 1) + (army_8_pixel_value[`W_PP] * army_8_pixel_value[`H_pp] * army_8_picnum);
    wire [1:0] army_8_value;
    Army_Render_Pixel army_8_Render (.clk(clk), .type(Army_Instance[8][`TYPE_P]), .addr(army_8_addr), .pixel_value(army_8_value));

    reg [18:0] army_9_pixel_value;
    reg  [2:0] army_9_picnum;
    Army_Pixel ArmyPixel9 (Army_Instance[9][`TYPE_P], army_9_pixel_value);
    STATS_acc_PIC STATS_acc_PIC25 (Army_Instance[9][`STATE_P], Army_Instance[9][`X_P], army_9_picnum);
    wire [12:0] army_9_addr = (((av_cnt - Army_Instance[9][`Y_P]) >> 1) * army_9_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[9][`X_P])) >> 1) + (army_9_pixel_value[`W_PP] * army_9_pixel_value[`H_pp] * army_9_picnum);
    wire [1:0] army_9_value;
    Army_Render_Pixel army_9_Render (.clk(clk), .type(Army_Instance[9][`TYPE_P]), .addr(army_9_addr), .pixel_value(army_9_value));

    reg [18:0] army_10_pixel_value;
    reg  [2:0] army_10_picnum;
    Army_Pixel ArmyPixel10 (Army_Instance[10][`TYPE_P], army_10_pixel_value);
    STATS_acc_PIC STATS_acc_PIC26 (Army_Instance[10][`STATE_P], Army_Instance[10][`X_P], army_10_picnum);
    wire [12:0] army_10_addr = (((av_cnt - Army_Instance[10][`Y_P]) >> 1) * army_10_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[10][`X_P])) >> 1) + (army_10_pixel_value[`W_PP] * army_10_pixel_value[`H_pp] * army_10_picnum);
    wire [1:0] army_10_value;
    Army_Render_Pixel army_10_Render (.clk(clk), .type(Army_Instance[10][`TYPE_P]), .addr(army_10_addr), .pixel_value(army_10_value));

    reg [18:0] army_11_pixel_value;
    reg  [2:0] army_11_picnum;
    Army_Pixel ArmyPixel11 (Army_Instance[11][`TYPE_P], army_11_pixel_value);
    STATS_acc_PIC STATS_acc_PIC27 (Army_Instance[11][`STATE_P], Army_Instance[11][`X_P], army_11_picnum);
    wire [12:0] army_11_addr = (((av_cnt - Army_Instance[11][`Y_P]) >> 1) * army_11_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[11][`X_P])) >> 1) + (army_11_pixel_value[`W_PP] * army_11_pixel_value[`H_pp] * army_11_picnum);
    wire [1:0] army_11_value;
    Army_Render_Pixel army_11_Render (.clk(clk), .type(Army_Instance[11][`TYPE_P]), .addr(army_11_addr), .pixel_value(army_11_value));

    reg [18:0] army_12_pixel_value;
    reg  [2:0] army_12_picnum;
    Army_Pixel ArmyPixel12 (Army_Instance[12][`TYPE_P], army_12_pixel_value);
    STATS_acc_PIC STATS_acc_PIC28 (Army_Instance[12][`STATE_P], Army_Instance[12][`X_P], army_12_picnum);
    wire [12:0] army_12_addr = (((av_cnt - Army_Instance[12][`Y_P]) >> 1) * army_12_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[12][`X_P])) >> 1) + (army_12_pixel_value[`W_PP] * army_12_pixel_value[`H_pp] * army_12_picnum);
    wire [1:0] army_12_value;
    Army_Render_Pixel army_12_Render (.clk(clk), .type(Army_Instance[12][`TYPE_P]), .addr(army_12_addr), .pixel_value(army_12_value));

    reg [18:0] army_13_pixel_value;
    reg  [2:0] army_13_picnum;
    Army_Pixel ArmyPixel13 (Army_Instance[13][`TYPE_P], army_13_pixel_value);
    STATS_acc_PIC STATS_acc_PIC29 (Army_Instance[13][`STATE_P], Army_Instance[13][`X_P], army_13_picnum);
    wire [12:0] army_13_addr = (((av_cnt - Army_Instance[13][`Y_P]) >> 1) * army_13_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[13][`X_P])) >> 1) + (army_13_pixel_value[`W_PP] * army_13_pixel_value[`H_pp] * army_13_picnum);
    wire [1:0] army_13_value;
    Army_Render_Pixel army_13_Render (.clk(clk), .type(Army_Instance[13][`TYPE_P]), .addr(army_13_addr), .pixel_value(army_13_value));

    reg [18:0] army_14_pixel_value;
    reg  [2:0] army_14_picnum;
    Army_Pixel ArmyPixel14 (Army_Instance[14][`TYPE_P], army_14_pixel_value);
    STATS_acc_PIC STATS_acc_PIC30 (Army_Instance[14][`STATE_P], Army_Instance[14][`X_P], army_14_picnum);
    wire [12:0] army_14_addr = (((av_cnt - Army_Instance[14][`Y_P]) >> 1) * army_14_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[14][`X_P])) >> 1) + (army_14_pixel_value[`W_PP] * army_14_pixel_value[`H_pp] * army_14_picnum);
    wire [1:0] army_14_value;
    Army_Render_Pixel army_14_Render (.clk(clk), .type(Army_Instance[14][`TYPE_P]), .addr(army_14_addr), .pixel_value(army_14_value));

    reg [18:0] army_15_pixel_value;
    reg  [2:0] army_15_picnum;
    Army_Pixel ArmyPixel15 (Army_Instance[15][`TYPE_P], army_15_pixel_value);
    STATS_acc_PIC STATS_acc_PIC31 (Army_Instance[15][`STATE_P], Army_Instance[15][`X_P], army_15_picnum);
    wire [12:0] army_15_addr = (((av_cnt - Army_Instance[15][`Y_P]) >> 1) * army_15_pixel_value[`W_PP]) + (((ah_cnt - Army_Instance[15][`X_P])) >> 1) + (army_15_pixel_value[`W_PP] * army_15_pixel_value[`H_pp] * army_15_picnum);
    wire [1:0] army_15_value;
    Army_Render_Pixel army_15_Render (.clk(clk), .type(Army_Instance[15][`TYPE_P]), .addr(army_15_addr), .pixel_value(army_15_value));

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
            if (Army_Instance[0][`EXIST_P] && h_cnt>=Army_Instance[0][`X_P] && h_cnt<Army_Instance[0][`X_P]+Army_0_pixel_value[`W_PP] && v_cnt>=Army_Instance[0][`Y_P] && v_cnt<Army_Instance[0][`Y_P]+Army_0_pixel_value[`H_pp] && Army_0_pixel_value != 2'b11) begin
                case (Army_0_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[1][`EXIST_P] && h_cnt>=Army_Instance[1][`X_P] && h_cnt<Army_Instance[1][`X_P]+Army_1_pixel_value[`W_PP] && v_cnt>=Army_Instance[1][`Y_P] && v_cnt<Army_Instance[1][`Y_P]+Army_1_pixel_value[`H_pp] && Army_1_pixel_value != 2'b11) begin
                case (Army_1_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[2][`EXIST_P] && h_cnt>=Army_Instance[2][`X_P] && h_cnt<Army_Instance[2][`X_P]+Army_2_pixel_value[`W_PP] && v_cnt>=Army_Instance[2][`Y_P] && v_cnt<Army_Instance[2][`Y_P]+Army_2_pixel_value[`H_pp] && Army_2_pixel_value != 2'b11) begin
                case (Army_2_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[3][`EXIST_P] && h_cnt>=Army_Instance[3][`X_P] && h_cnt<Army_Instance[3][`X_P]+Army_3_pixel_value[`W_PP] && v_cnt>=Army_Instance[3][`Y_P] && v_cnt<Army_Instance[3][`Y_P]+Army_3_pixel_value[`H_pp] && Army_3_pixel_value != 2'b11) begin
                case (Army_3_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[4][`EXIST_P] && h_cnt>=Army_Instance[4][`X_P] && h_cnt<Army_Instance[4][`X_P]+Army_4_pixel_value[`W_PP] && v_cnt>=Army_Instance[4][`Y_P] && v_cnt<Army_Instance[4][`Y_P]+Army_4_pixel_value[`H_pp] && Army_4_pixel_value != 2'b11) begin
                case (Army_4_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[5][`EXIST_P] && h_cnt>=Army_Instance[5][`X_P] && h_cnt<Army_Instance[5][`X_P]+Army_5_pixel_value[`W_PP] && v_cnt>=Army_Instance[5][`Y_P] && v_cnt<Army_Instance[5][`Y_P]+Army_5_pixel_value[`H_pp] && Army_5_pixel_value != 2'b11) begin
                case (Army_5_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[6][`EXIST_P] && h_cnt>=Army_Instance[6][`X_P] && h_cnt<Army_Instance[6][`X_P]+Army_6_pixel_value[`W_PP] && v_cnt>=Army_Instance[6][`Y_P] && v_cnt<Army_Instance[6][`Y_P]+Army_6_pixel_value[`H_pp] && Army_6_pixel_value != 2'b11) begin
                case (Army_6_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[7][`EXIST_P] && h_cnt>=Army_Instance[7][`X_P] && h_cnt<Army_Instance[7][`X_P]+Army_7_pixel_value[`W_PP] && v_cnt>=Army_Instance[7][`Y_P] && v_cnt<Army_Instance[7][`Y_P]+Army_7_pixel_value[`H_pp] && Army_7_pixel_value != 2'b11) begin
                case (Army_7_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[8][`EXIST_P] && h_cnt>=Army_Instance[8][`X_P] && h_cnt<Army_Instance[8][`X_P]+Army_8_pixel_value[`W_PP] && v_cnt>=Army_Instance[8][`Y_P] && v_cnt<Army_Instance[8][`Y_P]+Army_8_pixel_value[`H_pp] && Army_8_pixel_value != 2'b11) begin
                case (Army_8_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[9][`EXIST_P] && h_cnt>=Army_Instance[9][`X_P] && h_cnt<Army_Instance[9][`X_P]+Army_9_pixel_value[`W_PP] && v_cnt>=Army_Instance[9][`Y_P] && v_cnt<Army_Instance[9][`Y_P]+Army_9_pixel_value[`H_pp] && Army_9_pixel_value != 2'b11) begin
                case (Army_9_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[10][`EXIST_P] && h_cnt>=Army_Instance[10][`X_P] && h_cnt<Army_Instance[10][`X_P]+Army_10_pixel_value[`W_PP] && v_cnt>=Army_Instance[10][`Y_P] && v_cnt<Army_Instance[10][`Y_P]+Army_10_pixel_value[`H_pp] && Army_10_pixel_value != 2'b11) begin
                case (Army_10_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[11][`EXIST_P] && h_cnt>=Army_Instance[11][`X_P] && h_cnt<Army_Instance[11][`X_P]+Army_11_pixel_value[`W_PP] && v_cnt>=Army_Instance[11][`Y_P] && v_cnt<Army_Instance[11][`Y_P]+Army_11_pixel_value[`H_pp] && Army_11_pixel_value != 2'b11) begin
                case (Army_11_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[12][`EXIST_P] && h_cnt>=Army_Instance[12][`X_P] && h_cnt<Army_Instance[12][`X_P]+Army_12_pixel_value[`W_PP] && v_cnt>=Army_Instance[12][`Y_P] && v_cnt<Army_Instance[12][`Y_P]+Army_12_pixel_value[`H_pp] && Army_12_pixel_value != 2'b11) begin
                case (Army_12_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[13][`EXIST_P] && h_cnt>=Army_Instance[13][`X_P] && h_cnt<Army_Instance[13][`X_P]+Army_13_pixel_value[`W_PP] && v_cnt>=Army_Instance[13][`Y_P] && v_cnt<Army_Instance[13][`Y_P]+Army_13_pixel_value[`H_pp] && Army_13_pixel_value != 2'b11) begin
                case (Army_13_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[14][`EXIST_P] && h_cnt>=Army_Instance[14][`X_P] && h_cnt<Army_Instance[14][`X_P]+Army_14_pixel_value[`W_PP] && v_cnt>=Army_Instance[14][`Y_P] && v_cnt<Army_Instance[14][`Y_P]+Army_14_pixel_value[`H_pp] && Army_14_pixel_value != 2'b11) begin
                case (Army_14_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Army_Instance[15][`EXIST_P] && h_cnt>=Army_Instance[15][`X_P] && h_cnt<Army_Instance[15][`X_P]+Army_15_pixel_value[`W_PP] && v_cnt>=Army_Instance[15][`Y_P] && v_cnt<Army_Instance[15][`Y_P]+Army_15_pixel_value[`H_pp] && Army_15_pixel_value != 2'b11) begin
                case (Army_15_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[0][`EXIST_P] && h_cnt>=Enemy_Instance[0][`X_P] && h_cnt<Enemy_Instance[0][`X_P]+enemy_0_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[0][`Y_P] && v_cnt<Enemy_Instance[0][`Y_P]+enemy_0_pixel_value[`H_pp] && enemy_0_pixel_value != 2'b11) begin
                case (enemy_0_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[1][`EXIST_P] && h_cnt>=Enemy_Instance[1][`X_P] && h_cnt<Enemy_Instance[1][`X_P]+enemy_1_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[1][`Y_P] && v_cnt<Enemy_Instance[1][`Y_P]+enemy_1_pixel_value[`H_pp] && enemy_1_pixel_value != 2'b11) begin
                case (enemy_1_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[2][`EXIST_P] && h_cnt>=Enemy_Instance[2][`X_P] && h_cnt<Enemy_Instance[2][`X_P]+enemy_2_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[2][`Y_P] && v_cnt<Enemy_Instance[2][`Y_P]+enemy_2_pixel_value[`H_pp] && enemy_2_pixel_value != 2'b11) begin
                case (enemy_2_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[3][`EXIST_P] && h_cnt>=Enemy_Instance[3][`X_P] && h_cnt<Enemy_Instance[3][`X_P]+enemy_3_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[3][`Y_P] && v_cnt<Enemy_Instance[3][`Y_P]+enemy_3_pixel_value[`H_pp] && enemy_3_pixel_value != 2'b11) begin
                case (enemy_3_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[4][`EXIST_P] && h_cnt>=Enemy_Instance[4][`X_P] && h_cnt<Enemy_Instance[4][`X_P]+enemy_4_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[4][`Y_P] && v_cnt<Enemy_Instance[4][`Y_P]+enemy_4_pixel_value[`H_pp] && enemy_4_pixel_value != 2'b11) begin
                case (enemy_4_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[5][`EXIST_P] && h_cnt>=Enemy_Instance[5][`X_P] && h_cnt<Enemy_Instance[5][`X_P]+enemy_5_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[5][`Y_P] && v_cnt<Enemy_Instance[5][`Y_P]+enemy_5_pixel_value[`H_pp] && enemy_5_pixel_value != 2'b11) begin
                case (enemy_5_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[6][`EXIST_P] && h_cnt>=Enemy_Instance[6][`X_P] && h_cnt<Enemy_Instance[6][`X_P]+enemy_6_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[6][`Y_P] && v_cnt<Enemy_Instance[6][`Y_P]+enemy_6_pixel_value[`H_pp] && enemy_6_pixel_value != 2'b11) begin
                case (enemy_6_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[7][`EXIST_P] && h_cnt>=Enemy_Instance[7][`X_P] && h_cnt<Enemy_Instance[7][`X_P]+enemy_7_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[7][`Y_P] && v_cnt<Enemy_Instance[7][`Y_P]+enemy_7_pixel_value[`H_pp] && enemy_7_pixel_value != 2'b11) begin
                case (enemy_7_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[8][`EXIST_P] && h_cnt>=Enemy_Instance[8][`X_P] && h_cnt<Enemy_Instance[8][`X_P]+enemy_8_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[8][`Y_P] && v_cnt<Enemy_Instance[8][`Y_P]+enemy_8_pixel_value[`H_pp] && enemy_8_pixel_value != 2'b11) begin
                case (enemy_8_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[9][`EXIST_P] && h_cnt>=Enemy_Instance[9][`X_P] && h_cnt<Enemy_Instance[9][`X_P]+enemy_9_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[9][`Y_P] && v_cnt<Enemy_Instance[9][`Y_P]+enemy_9_pixel_value[`H_pp] && enemy_9_pixel_value != 2'b11) begin
                case (enemy_9_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[10][`EXIST_P] && h_cnt>=Enemy_Instance[10][`X_P] && h_cnt<Enemy_Instance[10][`X_P]+enemy_10_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[10][`Y_P] && v_cnt<Enemy_Instance[10][`Y_P]+enemy_10_pixel_value[`H_pp] && enemy_10_pixel_value != 2'b11) begin
                case (enemy_10_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[11][`EXIST_P] && h_cnt>=Enemy_Instance[11][`X_P] && h_cnt<Enemy_Instance[11][`X_P]+enemy_11_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[11][`Y_P] && v_cnt<Enemy_Instance[11][`Y_P]+enemy_11_pixel_value[`H_pp] && enemy_11_pixel_value != 2'b11) begin
                case (enemy_11_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[12][`EXIST_P] && h_cnt>=Enemy_Instance[12][`X_P] && h_cnt<Enemy_Instance[12][`X_P]+enemy_12_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[12][`Y_P] && v_cnt<Enemy_Instance[12][`Y_P]+enemy_12_pixel_value[`H_pp] && enemy_12_pixel_value != 2'b11) begin
                case (enemy_12_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[13][`EXIST_P] && h_cnt>=Enemy_Instance[13][`X_P] && h_cnt<Enemy_Instance[13][`X_P]+enemy_13_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[13][`Y_P] && v_cnt<Enemy_Instance[13][`Y_P]+enemy_13_pixel_value[`H_pp] && enemy_13_pixel_value != 2'b11) begin
                case (enemy_13_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[14][`EXIST_P] && h_cnt>=Enemy_Instance[14][`X_P] && h_cnt<Enemy_Instance[14][`X_P]+enemy_14_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[14][`Y_P] && v_cnt<Enemy_Instance[14][`Y_P]+enemy_14_pixel_value[`H_pp] && enemy_14_pixel_value != 2'b11) begin
                case (enemy_14_value)
                    2'b00: pixel = 12'hfff;
                    2'b10: pixel = 12'hf00;
                    default: pixel = 12'h000;
                endcase
            end else if (Enemy_Instance[15][`EXIST_P] && h_cnt>=Enemy_Instance[15][`X_P] && h_cnt<Enemy_Instance[15][`X_P]+enemy_15_pixel_value[`W_PP] && v_cnt>=Enemy_Instance[15][`Y_P] && v_cnt<Enemy_Instance[15][`Y_P]+enemy_15_pixel_value[`H_pp] && enemy_15_pixel_value != 2'b11) begin
                case (enemy_15_value)
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
            end else if (v_cnt>=10'd270) begin
                pixel = 12'hfb7;    // board
            end 
        end
    end
endmodule