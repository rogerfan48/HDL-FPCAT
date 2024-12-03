`define S_START 3'd0
`define  S_MENU 3'd1
`define S_PLAY1 3'd2
`define S_PLAY2 3'd3
`define S_PLAY3 3'd4
`define   S_WIN 3'd5
`define  S_LOSE 3'd6

`define     GS_REST 4'd0
`define     GS_INIT 4'd1
`define    GS_GEN_E 4'd2
`define  GS_GEN_A_D 4'd3
`define  GS_GEN_A_G 4'd4
`define    GS_ATK_E 4'd5
`define    GS_ATK_A 4'd6
`define    GS_TOWER 4'd7
`define    GS_PURSE 4'd8
`define    GS_MONEY 4'd9
`define   GS_HURT_E 4'd10
`define   GS_HURT_A 4'd11
`define    GS_STORE 4'd12
`define    GS_CLEAN 4'd13

`define ARMY_0_W 6'd32
`define ARMY_0_H 5'd20
`define ARMY_1_W 6'd32
`define ARMY_1_H 5'd20
`define ARMY_2_W 5'd16
`define ARMY_2_H 4'd12
`define ARMY_3_W 6'd32
`define ARMY_3_H 5'd20
`define ARMY_4_W 5'd16
`define ARMY_4_H 4'd10
`define ARMY_5_W 6'd32
`define ARMY_5_H 5'd25
`define ARMY_6_W 6'd32
`define ARMY_6_H 5'd25
`define ARMY_7_W 7'd64
`define ARMY_7_H 5'd24

`define ENEMY_0_W 5'd16
`define ENEMY_0_H 4'd15
`define ENEMY_1_W 5'd16
`define ENEMY_1_H 5'd30
`define ENEMY_2_W 5'd16
`define ENEMY_2_H 5'd20
`define ENEMY_3_W 5'd16
`define ENEMY_3_H 5'd30

`define REPEL_CD 4'd10
`define REPEL_SPEED 2'd3
`define INIT_MONEY_MAX 15'd500

module Game_Engine (
    input clk_25MHz,
    input [9:0] h_cnt;   //640
    input [9:0] v_cnt;   //480
    input clk_6,
    input clk_frame,
    input mouseL,
    input [9:0] mouseInFrame,
    input [2:0] scene,
    input gameInit_OP,
    output [14:0] money,
    output [14:0] money_Max
);

    reg [5:0] enemyGenPtr;
    wire [5:0] next_enemyGenPtr;
    wire [14:0] enemyQueueObj, enemyQueueObj1, enemyQueueObj2, enemyQueueObj3;
    mem_Enemy_Queue_1 mem_EQ1 (.clka(clk_25MHz), .wea(0), .addra(enemyGenPtr), .dina(0), .douta(enemyQueueObj1));
    mem_Enemy_Queue_2 mem_EQ2 (.clka(clk_25MHz), .wea(0), .addra(enemyGenPtr), .dina(0), .douta(enemyQueueObj2));
    mem_Enemy_Queue_3 mem_EQ3 (.clka(clk_25MHz), .wea(0), .addra(enemyGenPtr), .dina(0), .douta(enemyQueueObj3));
    always @(*) begin
        if (scene==S_PLAY1)         enemyQueueObj = enemyQueueObj1;
        else if (scene==S_PLAY2)    enemyQueueObj = enemyQueueObj2;
        else if (scene==S_PLAY3)    enemyQueueObj = enemyQueueObj3;
        else                        enemyQueueObj = 15'b111111111111000;
    end
    reg [1:0] enemyStatsPtr;
    wire [1:0] next_enemyStatsPtr;
    wire [37:0] enemyStatsObj;
    mem_Enemy_Stats mem_ES0 (.clka(clk_25MHz), .wea(0), .addra(enemyStatsPtr), .dina(0), .douta(enemyStatsObj));
    reg [1:0] armyStatsPtr;
    wire [1:0] next_armyStatsPtr;
    wire [37:0] armyStatsObj;
    mem_Army_Stats mem_AS0 (.clka(clk_25MHz), .wea(0), .addra(armyStatsPtr), .dina(0), .douta(armyStatsObj));

    reg [55:0] Enemy_Instance [16];
    reg [55:0] Army_Instance [16];
    wire [55:0] next_Enemy_Instance [16];
    wire [55:0] next_Army_Instance [16];

    reg [4:0] gameState;
    reg [4:0] next_gameState;
    always @(posedge clk_25MHz) begin
        if (rst) gameState <= GS_REST;
        else if (scene!=S_PLAY1&&scene!=S_PLAY2&&scene!=S_PLAY3) gameState <= GS_REST;
        else gameState <= next_gameState;
    end

    reg [11:0] game_cnt;
    always @(posedge clk_frame) begin
        if (rst) game_cnt <= 12'd0;
        else if (gameState==GS_INIT) game_cnt <= 12'd0;
        else if (clk_6) game_cnt <= game_cnt + 1'b1;
        else game_cnt <= game_cnt;
    end

    reg [14:0] money;
    wire [14:0] next_money;
    reg [14:0] money_Max;
    wire [14:0] next_money_Max;

    reg [7:0] genArmy;
    reg [7:0] next_genArmy;
    wire timeToGenArmy = (gameState == GS_GEN_A_D);
    always @(*) begin
        integer i;
        for (i=0; i<8; i=i+1) begin
            if (mouseL && mouseInFrame[i+1])    next_genArmy[i] = 1'b1;
            else if (timeToGenArmy)             next_genArmy[i] = 1'b0;
            else                                next_genArmy[i] = genArmy[i];
        end
    end

    reg next_towerFire;
    reg towerFire;
    wire timeToFire = (gameState == GS_TOWER);
    always @(*) begin
        if (mouseL && mouseInFrame[9])  next_towerFire = 1'b1;
        else if (timeToFire)            next_towerFire = 1'b0;
        else                            next_towerFire = towerFire;
    end

    reg purseUpgrade;
    reg next_purseUpgrade;
    wire timeToUpgradePurse = (gameState == GS_PURSE);
    always @(*) begin
        if (mouseL && mouseInFrame[0])  next_purseUpgrade = 1'b1;
        else if (timeToUpgradePurse)    next_purseUpgrade = 1'b0;
        else                            next_purseUpgrade = purseUpgrade;
    end

    always @(posedge clk_25MHz) begin
        integer i;
        for (i=0; i<16; i=i+1) begin
            Enemy_Instance[i] <= next_Enemy_Instance[i];
            Army_Instance[i] <= next_Army_Instance[i];
        end
        enemyGenPtr <= next_enemyGenPtr;
        enemyStatsPtr <= next_enemyStatsPtr;
        armyStatsPtr <= next_armyStatsPtr;
        genArmy <= next_genArmy;
        purseUpgrade <= next_purseUpgrade;
        towerFire <= next_towerFire;
        money <= next_money;
        money_Max <= next_money_Max;
    end
    
    always @(*) begin
        integer i;
        for (i=0; i<16; i=i+1) begin
            next_Enemy_Instance[i] = Enemy_Instance[i];
            next_Army_Instance[i] = Army_Instance[i];
        end
        next_enemyGenPtr = enemyGenPtr;
        next_enemyStatsPtr = enemyStatsPtr;
        next_armyStatsPtr = armyStatsPtr;
        next_money = money;
        next_money_Max = money_Max;
        case (gameState)
            GS_REST: begin
                if (v_cnt==10'd490 && h_cnt<10'd5 && gameInit_OP)   next_gameState = GS_INIT;
                else                                                next_gameState = gameState;
            end
            GS_INIT: begin
                next_gameState = GS_GEN_E;
                for (i=0; i<16; i=i+1) begin
                    next_Enemy_Instance[i] = 56'd0;
                    next_Army_Instance[i] = 56'd0;
                end
                next_money = 15'd0;
                next_money_Max = INIT_MONEY_MAX;
            end
            GS_GEN_E: begin     // generate Enemy

            end
            GS_GEN_A_D: begin     // generate Army - Detect
                next_gameState = GS_GEN_A_G;
            end
            GS_GEN_A_G: begin     // generate Army - Find Space to gen

            end
            GS_ATK_E: begin     // atk or move Enemy

            end
            GS_ATK_A: begin     // atk or move Army

            end
            GS_TOWER: begin     // Tower fire
                next_gameState = GS_PURSE;
            end
            GS_PURSE: begin     // Purse Upgrade
                next_gameState = GS_MONEY;
            end
            GS_MONEY: begin     // Money Add with Time
                next_gameState = GS_HURT_E;
                if (clk_6 && money<money_Max)   next_money = money + 1'b1;
                else                            next_money = money;
            end
            GS_HURT_E: begin    // beDamaged Enemy

            end
            GS_HURT_A: begin    // beDamaged Army

            end
            GS_STORE: begin     // Store for Render

            end
            default: begin
                next_gameState = GS_REST;
            end
        endcase
    end
endmodule