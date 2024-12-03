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
`define    GS_CLEAN 4'd12

`define ENEMY_SPAWN_X 10'd10
`define ARMY_SPAWN_X  10'd570
`define SPAWN_Y       10'd210

`define REPEL_CD 4'd10
`define REPEL_SPEED 2'd3
`define INIT_MONEY_MAX 15'd500

module Game_Engine (
    input clk_25MHz,
    input [9:0] h_cnt,   //640
    input [9:0] v_cnt,   //480
    input clk_6,
    input clk_frame,
    input mouseL,
    input [9:0] mouseInFrame,
    input [2:0] scene,
    input gameInit_OP,
    output ableToUpgrade,
    output reg [2:0] purse_level,
    output reg [14:0] money,
    output reg [55:0] Enemy_Instance [15:0],
    output reg [55:0] Army_Instance [15:0]
);
    integer i;

// ? //////////     IP: Enemy Queue     //////////////
    reg [5:0] enemyGenPtr;      // only can have 63 enemy, remaining: {12{1}, 3{0}}
    reg [5:0] next_enemyGenPtr;
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

// ? //////////     reg: Enemy/Army Stats/Pixel     //////////////
    reg [1:0] enemy_type_addr;
    reg [1:0] next_enemy_type_addr;
    reg [37:0] enemy_stats_value;
    reg [18:0] enemy_pixel_value;
    Enemy_Stats EnemyStats0 (enemy_type_addr, enemy_stats_value);
    Enemy_Pixel EnemyPixel0 (enemy_type_addr, enemy_pixel_value);
    reg [1:0] army_type_addr;
    reg [1:0] next_army_type_addr;
    reg [37:0] army_stats_value;
    reg [18:0] army_pixel_value;
    Army_Stats ArmyStats0 (army_type_addr, army_stats_value);
    Army_Pixel ArmyPixel0 (army_type_addr, army_pixel_value);

// ? //////////     reg: Enemy/Army Instance     //////////////
    reg [55:0] next_Enemy_Instance [15:0];
    reg [55:0] next_Army_Instance [15:0];

// ? //////////     reg: Game State     //////////////
    reg [4:0] gameState;
    reg [4:0] next_gameState;
    always @(posedge clk_25MHz) begin
        if (rst) gameState <= GS_REST;
        else if (scene!=S_PLAY1&&scene!=S_PLAY2&&scene!=S_PLAY3) gameState <= GS_REST;
        else gameState <= next_gameState;
    end

// ? //////////     reg: Game Cnt = GAME TIME     //////////////
    reg [11:0] game_cnt;
    always @(posedge clk_frame) begin
        if (rst) game_cnt <= 12'd0;
        else if (gameState==GS_INIT) game_cnt <= 12'd0;
        else if (clk_6) game_cnt <= game_cnt + 1'b1;
        else game_cnt <= game_cnt;
    end

// ? //////////     reg: Money     //////////////
    reg [2:0] next_purse_level;
    reg [14:0] next_money;
    wire [14:0] purseUpgradeNeedMoney;
    Purse_Upgrade_Need_Money PUNM0(purse_level, purseUpgradeNeedMoney);
    Purse_Max_Money PMM0(purse_level, money_Max);
    assign ableToUpgrade = (money>=purseUpgradeNeedMoney);

// ? //////////     reg: Screen Buttons     //////////////
    reg [7:0] genArmy;
    wire [3:0] genArmyType;
    Priority_Encoder_8x3 PE83_0 (genArmy, genArmyType);
    reg [7:0] next_genArmy;
    wire timeToGenArmy = (gameState == GS_GEN_A_D);
    always @(*) begin
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
        if (mouseL && mouseInFrame[0] && ableToUpgrade) next_purseUpgrade = 1'b1;
        else if (timeToUpgradePurse)                    next_purseUpgrade = 1'b0;
        else                                            next_purseUpgrade = purseUpgrade;
    end

    reg [5:0] counter1;
    reg [5:0] counter2;
    reg [5:0] counter3;
    wire [5:0] next_counter1;
    wire [5:0] next_counter2;
    wire [5:0] next_counter3;
    
    always @(posedge clk_25MHz) begin
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
        purse_level <= next_purse_level;
        counter1 <= next_counter1;
        counter2 <= next_counter2;
        counter3 <= next_counter3;
    end

    always @(*) begin
        for (i=0; i<16; i=i+1) begin
            next_Enemy_Instance[i] = Enemy_Instance[i];
            next_Army_Instance[i] = Army_Instance[i];
        end
        next_enemyGenPtr = enemyGenPtr;
        next_enemyStatsPtr = enemyStatsPtr;
        next_armyStatsPtr = armyStatsPtr;
        next_money = money;
        next_money_Max = money_Max;
        next_purse_level = purse_level;
        enemy_type_addr = enemy_type_addr;    // just default
        army_type_addr = army_type_addr;      // just default
        next_counter1 = counter1;
        next_counter2 = counter2;
        next_counter3 = counter3;

        case (gameState)
            GS_REST: begin
                if (v_cnt==10'd490 && h_cnt<10'd5) begin
                    if (gameInit)   next_gameState = GS_INIT;
                    else            next_gameState = GS_GEN_E;
                end else next_gameState = gameState;
            end
            GS_INIT: begin      // ? ///// Initialization
                next_gameState = GS_GEN_E;
                for (i=0; i<16; i=i+1) begin
                    next_Enemy_Instance[i] = 56'd0;
                    next_Army_Instance[i] = 56'd0;
                end
                next_money = 15'd0;
                next_money_Max = INIT_MONEY_MAX;
                next_purse_level = 3'd0;
                next_enemyGenPtr = 6'd0;
                next_counter1 = 6'd0;       // Finding Space ptr
                next_counter2 = 6'd0;       // Been Generated
            end
            GS_GEN_E: begin     // ? ///// generate Enemy
                if (enemyGenPtr == 6'd63 ||             // All Enemy Been Generated
                    enemyQueueObj[14:3]>game_cnt ||     // Not Yet to Generate
                    counter2 ||                         // Already Find Space, generate and to the next gameState
                    counter1==6'd16) begin              // No Space
                    next_gameState = GS_GEN_A_D;
                    if (counter2) begin
                        next_Enemy_Instance[counter1] = {1'b1, enemy_type_addr, ENEMY_SPAWN_X, SPAWN_Y-enemy_pixel_value[11:5], enemy_stats_value[37:26], 4'd1, 4'd0, 12'd0};
                    end
                end else begin
                    if (Enemy_Instance[counter1][55]==1'b0) begin   // Found A Space
                        enemy_type_addr = enemyQueueObj[1:0];       // Record the Enemy Type, to get the right data in next clk
                        next_counter2 = 6'd1;
                    end else next_counter1 = counter1 + 1'b1;       // This Addr No Space, find the next one
                end
            end
            GS_GEN_A_D: begin   // ? ///// generate Army - Detect
                next_gameState = GS_GEN_A_G;
                army_type_addr = genArmy;
                next_counter1 = 6'd0;       // Finding Space ptr
            end
            GS_GEN_A_G: begin   // ? ///// generate Army - Find Space to gen
                if (counter1==6'd16) begin              // No Space
                    next_gameState = GS_ATK_E;
                end else begin
                    if (Army_Instance[counter1][55]==1'b0) begin    // Found A Space
                        next_gameState = GS_ATK_E;
                        next_Army_Instance[counter1] = {1'b1, army_type_addr, ARMY_SPAWN_X, SPAWN_Y-army_pixel_value[11:5], army_stats_value[37:26], 4'd1, 4'd0, 12'd0};
                    end else next_counter1 = counter1 + 1'b1;       // This Addr No Space, find the next one
                end
            end
            GS_ATK_E: begin     // ? ///// atk or move Enemy
                // CAN LEAVE IT BLANK FOR ROGER TO DO, OR IF YOU FINISH ALL OTHER PARTS, CAN DO THIS
            end
            GS_ATK_A: begin     // ? ///// atk or move Army
                // CAN LEAVE IT BLANK FOR ROGER TO DO, OR IF YOU FINISH ALL OTHER PARTS, CAN DO THIS
            end
            GS_TOWER: begin     // ? ///// Tower fire
                next_gameState = GS_PURSE;
                // TODO: If finished this part, remove this section of TODO, other TODO also.
                // TODO: Remember when need counter(s) initialize it in the the "READY TO TRANS-STATE" part in the previous state.
                // TODO: 
                // TODO: TOWER WILL NOT NEED COUNTER1/2/3, but need an independent timer which need to be a reg on output for render to render
                // TODO: can reference to Purse below.
            end
            GS_PURSE: begin     // ? ///// Purse Upgrade
                next_gameState = GS_MONEY;
                if (purse_level != 3'd7 && ableToUpgrade) begin
                    next_money = money - purseUpgradeNeedMoney;
                    next_purse_level = purse_level + 1'b1;
                end 
            end
            GS_MONEY: begin     // ? ///// Money Add with Time
                next_gameState = GS_HURT_E;
                if (clk_6) begin
                    if (purse_level==3'd0)      next_money = ((money + 1'b1 > money_Max) ? money_Max : money + 1'b1);
                    else if (purse_level<3'd3)  next_money = ((money + 2'b2 > money_Max) ? money_Max : money + 2'b2);
                    else if (purse_level==3'd3) next_money = ((money + 2'b3 > money_Max) ? money_Max : money + 2'b3);
                    else if (purse_level==3'd4) next_money = ((money + 3'b4 > money_Max) ? money_Max : money + 3'b4);
                    else                        next_money = ((money + 3'b5 > money_Max) ? money_Max : money + 3'b5);
                end else                        next_money = money;
            end
            GS_HURT_E: begin    // ? ///// beDamaged Enemy
                // TODO
            end
            GS_HURT_A: begin    // ? ///// beDamaged Army
                // TODO
            end
            default: begin
                next_gameState = GS_REST;
            end
        endcase
    end
endmodule