`define S_START 3'd0
`define  S_MENU 3'd1
`define S_PLAY1 3'd2
`define S_PLAY2 3'd3
`define S_PLAY3 3'd4
`define   S_WIN 3'd5
`define  S_LOSE 3'd6

module Top (
    input clk,
    input rst,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync,
    inout PS2_CLK,
    inout PS2_DATA
);

    wire clk_25MHz;
    Clk_Divisor_4 Clk_Div_4 (clk, clk_25MHz);

    wire valid;
    wire clk_frame;
    wire clk_6;     // !! with respect to clk_frame
    Clk_Divisor_6 Clk_Divisor_6(clk_frame, clk_6);
    wire [9:0] h_cnt;   //640
    wire [9:0] ah_cnt;  //640
    wire [9:0] v_cnt;   //480
    wire [9:0] av_cnt;  //480

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
    wire gameInit, gameInit_OP;
    assign gameInit = (mouseL && (mouseInLevel1||mouseInLevel2||mouseInLevel3));
    One_Palse One_Palse_GameInit (clk_frame, gameInit, gameInit_OP);

    wire [9:0] mouseInFrame;    // [0]:purse, [9]:Fire
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

    wire [14:0] money;
    wire [14:0] money_Max;

    Game_Engine Game_Engine_0 (
        .clk_25MHz(clk_25MHz),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .clk_6(clk_6),
        .clk_frame(clk_frame),
        .mouseL(mouseL),
        .mouseInFrame(mouseInFrame),
        .scene(scene),
        .gameInit_OP(gameInit_OP),
        .money(money),
        .money_Max(money_Max)
    );

    Render Render_0 (
        .clk(clk_25MHz),
        .h_cnt(h_cnt),
        .ah_cnt(ah_cnt),
        .v_cnt(v_cnt),
        .av_cnt(av_cnt),
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
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );

    VGA_Control VGA_Ctrl_0 (
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .ah_cnt(ah_cnt),
        .v_cnt(v_cnt),
        .av_cnt(av_cnt),
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
        if (rst) scene <= S_START;
        else     scene <= next_scene;
    end
    always @(*) begin
        case (scene)
            S_START: begin
                if (mouseL && mouseInStart) next_scene = S_MENU;
                else                        next_scene = S_START;
            end
            S_MENU: begin
                if (mouseL && mouseInLevel1)        next_scene = S_PLAY1;
                else if (mouseL && mouseInLevel2)   next_scene = S_PLAY2;
                else if (mouseL && mouseInLevel3)   next_scene = S_PLAY3;
                else                                next_scene = S_MENU;
            end
            S_PLAY1: begin
                next_scene = scene;
            end
            S_PLAY2: begin
                next_scene = scene;
            end
            S_PLAY3: begin
                next_scene = scene;
            end
            S_WIN: begin
                next_scene = scene;
            end
            S_LOSE: begin
                next_scene = scene;
            end
            default: next_scene = scene;
        endcase
    end
endmodule

/*

TODO:
top:
    gen_army_0~7    // ! move to Game_Engine
    tower_atk       // ! move to Game_Engine
    6_clk           
    game_cnt: [11:0] unit: 6_clk    // ! move to Game_Engine
    repel_cd = 10;
    repel_speed = 3;

6 ip:
    mem_Enemy_Queue_1: {timestamp[12b], type[3b]}
    mem_Enemy_Queue_2: {timestamp[12b], type[3b]}
    mem_Enemy_Queue_3: {timestamp[12b], type[3b]}
    mem_Enemy_Instance: {exist[1b], type[3b], x[10b], y[10b], hp[12b], state[4b], state_cnt[4b], beDamaged[12b]}
    mem_Army_Instance:  {exist[1b], type[3b], x[10b], y[10b], hp[12b], state[4b], state_cnt[4b], beDamaged[12b]}
    mem_Enemy_Stats: {hp[12b], atk[9b], atk_cd[4b], speed[5b], range[8b]}
    mem_Army_Stats: {hp[12b], atk[9b], atk_cd[4b], speed[5b], range[8b]}

state: 0[null], 1[move], 2[atk0], 3[atk1], 4[atk2], 5[atk3], 6[repel]

module Game_Engine
v_cnt==
    490: gen_En
    491: gen_Ar
        !!! 
            reg [7:0] genArmy;
            reg purseUpgrade;
            reg towerFire;
            always @(posedge clk) begin
                // ...
            end
        !!!
    492: Atk_move_En
    493: Atk_move_Ar
    494: Tower Fire
    495: Purse Upgrade
    496: Money Add with Time
    497: beDamaged_En (Repel)
    498: beDamaged_Ar (Repel)
    499: Store for Render

*/