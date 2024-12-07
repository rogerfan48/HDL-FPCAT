`define S_START 3'd0
`define  S_MENU 3'd1
`define S_PLAY1 3'd2
`define S_PLAY2 3'd3
`define S_PLAY3 3'd4
`define   S_WIN 3'd5
`define  S_LOSE 3'd6

`define TOWER_CNT_MAX 8'd150

module Top (
    input clk,
    input rst,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync,
    inout PS2_CLK,
    inout PS2_DATA,
    output [7:0] arm_LED,
    output [6:0] display,
    output [3:0] digit
);

    wire clk_25MHz;
    wire [1:0] display_cnt;
    Clk_Divisor_4 Clk_Div_4 (clk, clk_25MHz, display_cnt);

    wire valid;
    wire clk_frame;
    wire clk_6;     // !! with respect to clk_frame
    Clk_Divisor_6 Clk_Divisor_6_0 (clk_25MHz, clk_frame, clk_6);
    wire [9:0] h_cnt;   //640
    wire [9:0] ah_cnt;  //640
    wire [9:0] v_cnt;   //480
    wire [9:0] av_cnt;  //480
    wire [9:0] d_h_cnt;
    wire [9:0] d_v_cnt;
    wire [9:0] h_cnt_1, h_cnt_2, h_cnt_3, h_cnt_4, h_cnt_5, h_cnt_6;
    wire [9:0] v_cnt_1, v_cnt_2, v_cnt_3, v_cnt_4, v_cnt_5, v_cnt_6;

    wire enable_mouse_display;
    wire [9:0] mouseX, mouseY;
    wire mouseL;
    wire [3:0] MOUSE_RED, MOUSE_GREEN, MOUSE_BLUE;
    wire [11:0] MOUSE_PIXEL = {MOUSE_RED, MOUSE_GREEN, MOUSE_BLUE};

    reg [2:0] scene;
    reg [2:0] next_scene;

    wire mouseInStart = (mouseX>=10'd200 && mouseX<10'd440 && mouseY>=10'd270 && mouseY<10'd330);
    wire mouseInLevel1 = (mouseX>=10'd160 && mouseX<10'd480 && mouseY>=10'd80 && mouseY<10'd140);
    wire mouseInLevel2 = (mouseX>=10'd160 && mouseX<10'd480 && mouseY>=10'd200 && mouseY<10'd260);
    wire mouseInLevel3 = (mouseX>=10'd160 && mouseX<10'd480 && mouseY>=10'd320 && mouseY<10'd380);
    wire gameInit;
    assign gameInit = (mouseL && (mouseInLevel1||mouseInLevel2||mouseInLevel3));

    wire ableToUpgrade;
    wire [2:0] purse_level;
    wire [7:0] tower_cnt;
    wire [14:0] money;
    wire [55:0] Enemy_Instance [7:0];
    wire [55:0] Army_Instance [7:0];
    wire game_win;
    wire game_lose;

    assign arm_LED[0] = Army_Instance[0][55];
    assign arm_LED[1] = Army_Instance[1][55];
    assign arm_LED[2] = Army_Instance[2][55];
    assign arm_LED[3] = Army_Instance[3][55];
    assign arm_LED[4] = Army_Instance[4][55];
    assign arm_LED[5] = Army_Instance[5][55];
    assign arm_LED[6] = Army_Instance[6][55];
    assign arm_LED[7] = Army_Instance[7][55];

    wire [9:0] mouseInFrame;    // [0]:purse, [9]:Fire
    wire [9:0] effectiveClick;
    assign mouseInFrame[0] = (mouseX<10'd100 && mouseY>=10'd380);
    assign mouseInFrame[1] = (mouseX>=10'd105 && mouseX<10'd205 && mouseY>=10'd290 && mouseY<10'd370);
    assign mouseInFrame[2] = (mouseX>=10'd215 && mouseX<10'd315 && mouseY>=10'd290 && mouseY<10'd370);
    assign mouseInFrame[3] = (mouseX>=10'd325 && mouseX<10'd425 && mouseY>=10'd290 && mouseY<10'd370);
    assign mouseInFrame[4] = (mouseX>=10'd435 && mouseX<10'd535 && mouseY>=10'd290 && mouseY<10'd370);
    assign mouseInFrame[5] = (mouseX>=10'd105 && mouseX<10'd205 && mouseY>=10'd380 && mouseY<10'd460);
    assign mouseInFrame[6] = (mouseX>=10'd215 && mouseX<10'd315 && mouseY>=10'd380 && mouseY<10'd460);
    assign mouseInFrame[7] = (mouseX>=10'd325 && mouseX<10'd425 && mouseY>=10'd380 && mouseY<10'd460);
    assign mouseInFrame[8] = (mouseX>=10'd435 && mouseX<10'd535 && mouseY>=10'd380 && mouseY<10'd460);
    assign mouseInFrame[9] = (mouseX>=10'd540 && mouseY>=10'd380);
    assign effectiveClick[0] = (mouseL && mouseInFrame[0] && ableToUpgrade);
    assign effectiveClick[1] = (mouseL && mouseInFrame[1] && money>=15'd75);
    assign effectiveClick[2] = (mouseL && mouseInFrame[2] && money>=15'd150);
    assign effectiveClick[3] = (mouseL && mouseInFrame[3] && money>=15'd240);
    assign effectiveClick[4] = (mouseL && mouseInFrame[4] && money>=15'd350);
    assign effectiveClick[5] = (mouseL && mouseInFrame[5] && money>=15'd750);
    assign effectiveClick[6] = (mouseL && mouseInFrame[6] && money>=15'd1500);
    assign effectiveClick[7] = (mouseL && mouseInFrame[7] && money>=15'd2000);
    assign effectiveClick[8] = (mouseL && mouseInFrame[8] && money>=15'd2400);
    assign effectiveClick[9] = (mouseL && mouseInFrame[9] && tower_cnt==`TOWER_CNT_MAX);

    Game_Engine Game_Engine_0 (
        .rst(rst),
        .clk_25MHz(clk_25MHz),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .clk_6(clk_6),
        .clk_frame(clk_frame),
        .effectiveClick(effectiveClick),
        .scene(scene),
        .gameInit(gameInit),
        .ableToUpgrade(ableToUpgrade),
        .purse_level(purse_level),
        .tower_cnt(tower_cnt),
        .money(money),
        .Enemy_Instance(Enemy_Instance),
        .Army_Instance(Army_Instance),
        .game_win(game_win),
        .game_lose(game_lose)
    );

    Render Render_0 (
        .rst(rst),
        .clk(clk),
        .clk_25MHz(clk_25MHz),
        .display_cnt(display_cnt),
        .h_cnt(h_cnt),
        .ah_cnt(ah_cnt),
        .v_cnt(v_cnt),
        .av_cnt(av_cnt),
        .d_h_cnt(d_h_cnt),
        .d_v_cnt(d_v_cnt),
        .h_cnt_1(h_cnt_1),
        .h_cnt_2(h_cnt_2),
        .h_cnt_3(h_cnt_3),
        .h_cnt_4(h_cnt_4),
        .h_cnt_5(h_cnt_5),
        .h_cnt_6(h_cnt_6),
        .v_cnt_1(v_cnt_1),
        .v_cnt_2(v_cnt_2),
        .v_cnt_3(v_cnt_3),
        .v_cnt_4(v_cnt_4),
        .v_cnt_5(v_cnt_5),
        .v_cnt_6(v_cnt_6),
        .mouseX(mouseX),
        .mouseY(mouseY),
        .valid(valid),
        .enable_mouse_display(enable_mouse_display),
        .mouse_pixel(MOUSE_PIXEL),
        .scene(scene),
        .mouseInStart(mouseInStart),
        .mouseInLevel1(mouseInLevel1),
        .mouseInLevel2(mouseInLevel2),
        .mouseInLevel3(mouseInLevel3),
        .mouseInFrame(mouseInFrame),
        .Enemy_Instance(Enemy_Instance),
        .Army_Instance(Army_Instance),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );

    Seven_Segment Seven_Segment_0 (rst, clk, money, display, digit);

    VGA_Control VGA_Ctrl_0 (
        .clk(clk),
        .pclk(clk_25MHz),
        .display_cnt(display_cnt),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .ah_cnt(ah_cnt),
        .v_cnt(v_cnt),
        .av_cnt(av_cnt),
        .d_h_cnt(d_h_cnt),
        .d_v_cnt(d_v_cnt),
        .h_cnt_1(h_cnt_1),
        .h_cnt_2(h_cnt_2),
        .h_cnt_3(h_cnt_3),
        .h_cnt_4(h_cnt_4),
        .h_cnt_5(h_cnt_5),
        .h_cnt_6(h_cnt_6),
        .v_cnt_1(v_cnt_1),
        .v_cnt_2(v_cnt_2),
        .v_cnt_3(v_cnt_3),
        .v_cnt_4(v_cnt_4),
        .v_cnt_5(v_cnt_5),
        .v_cnt_6(v_cnt_6),
        .clk_frame(clk_frame)
    );

    Mouse Mouse_Ctrl_0 (
        .clk(clk),
        .clk_25MHz(clk_25MHz),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .enable_mouse_display(enable_mouse_display),
        .MOUSE_X_POS(mouseX),
        .MOUSE_Y_POS(mouseY),
        .MOUSE_LEFT_OP(mouseL),
        .red(MOUSE_RED),
        .green(MOUSE_GREEN),
        .blue(MOUSE_BLUE),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA)
    );

    // Scene
    always @(posedge clk_25MHz) begin
        if (rst) scene <= `S_START;
        else     scene <= next_scene;
    end
    always @(*) begin
        next_scene = scene;
        case (scene)
            `S_START: begin
                if (mouseL && mouseInStart) next_scene = `S_MENU;
                else                        next_scene = `S_START;
            end
            `S_MENU: begin
                if (mouseL && mouseInLevel1)        next_scene = `S_PLAY1;
                else if (mouseL && mouseInLevel2)   next_scene = `S_PLAY2;
                else if (mouseL && mouseInLevel3)   next_scene = `S_PLAY3;
                else                                next_scene = `S_MENU;
            end
            `S_PLAY1, `S_PLAY2, `S_PLAY3: begin
                if (game_win)       next_scene = `S_WIN;
                else if (game_lose) next_scene = `S_LOSE;
            end
            `S_WIN: begin
                next_scene = scene;
            end
            `S_LOSE: begin
                next_scene = scene;
            end
            default: next_scene = scene;
        endcase
    end
endmodule

/*

IP Protocol:
    mem_Enemy_Queue_1: {timestamp[12b], type[3b]}
    mem_Enemy_Queue_2: {timestamp[12b], type[3b]}
    mem_Enemy_Queue_3: {timestamp[12b], type[3b]}
    mem_Enemy_Instance[55:0]: {exist[1b][55], type[3b][54:52], x[10b][51:42], y[10b][41:32], hp[12b][31:20], state[4b][19:16], state_cnt[4b][15:12], beDamaged[12b][11:0]}
    mem_Army_Instance [55:0]: {exist[1b][55], type[3b][54:52], x[10b][51:42], y[10b][41:32], hp[12b][31:20], state[4b][19:16], state_cnt[4b][15:12], beDamaged[12b][11:0]}
    mem_Enemy_Stats[37:0]: {hp[12b][37:26], atk[9b][25:17], atk_cd[4b][16:13], speed[5b][12:8], range[8b][7:0]}
    mem_Army_Stats [37:0]: {hp[12b][37:26], atk[9b][25:17], atk_cd[4b][16:13], speed[5b][12:8], range[8b][7:0]}

State Protocol: 0[null], 1[move], 2[atk0], 3[atk1], 4[atk2], 5[atk3], 6[repel]

*/