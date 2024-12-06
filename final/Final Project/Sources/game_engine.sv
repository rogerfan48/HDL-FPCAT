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
`define  GS_TOWER_D 4'd7
`define  GS_TOWER_O 4'd8
`define    GS_PURSE 4'd9
`define    GS_MONEY 4'd10
`define   GS_HURT_E 4'd11
`define   GS_HURT_A 4'd12

`define ENEMY_SPAWN_X 10'd10
`define ARMY_SPAWN_X  10'd570
`define SPAWN_Y       10'd210
`define TOWER_E_X     10'd70
`define TOWER_A_X     10'd570

`define REPEL_CD 4'd10
`define REPEL_SPEED 2'd3

`define TOWER_CNT_MAX 8'd150

`define  ST_NONE  3'd0
`define  ST_MOVE  3'd1
`define ST_ATK_0  3'd2
`define ST_ATK_1  3'd3
`define ST_ATK_2  3'd4
`define ST_ATK_3  3'd5
`define ST_REPEL  3'd6

// `define       EXIST_P  55
// `define        TYPE_P  54:52
// `define           X_P  51:42
// `define           Y_P  41:32
// `define          HP_P  31:20
// `define       STATE_P  19:16
// `define   STATE_CNT_P  15:12
// `define  BE_DAMAGED_P  11:0

// `define     HP_SP 37:26
// `define    atk_SP 25:17
// `define atk_cd_SP 16:13
// `define  speed_SP 12:8
// `define  range_SP 7:0

`define Killer_Bird 3'd0
`define  White_Bear 3'd1
`define  Metal_Duck 3'd2
`define  Black_Bear 3'd3

module Game_Engine (
    input clk_25MHz,
    input [9:0] h_cnt,   //640
    input [9:0] v_cnt,   //480
    input clk_6,
    input clk_frame,
    input [9:0] effectiveClick,
    input [2:0] scene,
    input gameInit_OP,
    output ableToUpgrade,
    output reg [2:0] purse_level,
    output reg [7:0] tower_cnt,
    output reg [14:0] money,
    output reg [55:0] Enemy_Instance [7:0],
    output reg [55:0] Army_Instance [7:0],
    output wire game_win,
    output wire game_lose
);
    integer i;

// ? //////////     IP: Enemy Queue     //////////////
    reg [5:0] enemyGenPtr;      // only can have 63 enemy, remaining: {12{1}, 3{0}}
    reg [5:0] next_enemyGenPtr;
    reg [14:0] enemyQueueObj, enemyQueueObj1, enemyQueueObj2, enemyQueueObj3;
    mem_Enemy_Queue_1 mem_EQ1 (.clka(clk_25MHz), .wea(0), .addra(enemyGenPtr), .dina(0), .douta(enemyQueueObj1));
    mem_Enemy_Queue_2 mem_EQ2 (.clka(clk_25MHz), .wea(0), .addra(enemyGenPtr), .dina(0), .douta(enemyQueueObj2));
    mem_Enemy_Queue_3 mem_EQ3 (.clka(clk_25MHz), .wea(0), .addra(enemyGenPtr), .dina(0), .douta(enemyQueueObj3));
    
    always @(*) begin
        if (scene==`S_PLAY1)         enemyQueueObj = enemyQueueObj1;
        else if (scene==`S_PLAY2)    enemyQueueObj = enemyQueueObj2;
        else if (scene==`S_PLAY3)    enemyQueueObj = enemyQueueObj3;
        else                         enemyQueueObj = 15'b111111111111000;
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
    reg [14:0] army_cost_value;
    Army_Stats ArmyStats0 (army_type_addr, army_stats_value);
    Army_Pixel ArmyPixel0 (army_type_addr, army_pixel_value);
    Army_Cost ArmyCost0 (army_type_addr, army_cost_value);

// ? //////////     reg: Enemy/Army Instance     //////////////
    reg [55:0] next_Enemy_Instance [7:0];
    reg [55:0] next_Army_Instance [7:0];

// ? //////////     reg: Game State     //////////////
    reg [4:0] gameState;
    reg [4:0] next_gameState;

    always @(posedge clk_25MHz) begin
        if (scene!=`S_PLAY1&&scene!=`S_PLAY2&&scene!=`S_PLAY3) gameState <= `GS_REST;
        else gameState <= next_gameState;
    end

// ? //////////     reg: Game Cnt = GAME TIME     //////////////
    reg [11:0] game_cnt;

    always @(posedge clk_frame) begin
        if (gameState==`GS_INIT) game_cnt <= 12'd0;
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

// ? //////////     reg:TowerFire     //////////////
    reg [7:0] next_tower_cnt;

// ? //////////     reg:TowerBlood     //////////////
    reg [11:0] towerBlood_E, towerBlood_A;
    reg [11:0] next_towerBlood_E, next_towerBlood_A;
    assign game_win = (towerBlood_E == 12'd0);
    assign game_lose = (towerBlood_A == 12'd0);

// ? //////////     reg: Screen Buttons     //////////////
    reg [7:0] genArmy;
    wire genArmyValid = (genArmy!=8'd0);
    wire [3:0] genArmyType;
    Priority_Encoder_8x3 PE83_0 (genArmy, genArmyType);
    reg [7:0] next_genArmy;
    wire timeToGenArmy = (gameState == `GS_GEN_A_D);
    always @(*) begin
        for (i=0; i<8; i=i+1) begin
            if (effectiveClick[i+1])    next_genArmy[i] = 1'b1;
            else if (timeToGenArmy)     next_genArmy[i] = 1'b0;
            else                        next_genArmy[i] = genArmy[i];
        end
    end

    reg next_towerFire;
    reg towerFire;
    wire timeToFire = (gameState == `GS_TOWER_D);
    always @(*) begin
        if (effectiveClick[9])  next_towerFire = 1'b1;
        else if (timeToFire)    next_towerFire = 1'b0;
        else                    next_towerFire = towerFire;
    end

    reg purseUpgrade;
    reg next_purseUpgrade;
    wire timeToUpgradePurse = (gameState == `GS_PURSE);
    always @(*) begin
        if (effectiveClick[0])          next_purseUpgrade = 1'b1;
        else if (timeToUpgradePurse)    next_purseUpgrade = 1'b0;
        else                            next_purseUpgrade = purseUpgrade;
    end

    reg [5:0] counter1;
    reg [5:0] counter2;
    reg [5:0] counter3;
    reg [5:0] next_counter1;
    reg [5:0] next_counter2;
    reg [5:0] next_counter3;
    
    always @(posedge clk_25MHz) begin
        next_gameState = gameState;
        for (i=0; i<8; i=i+1) begin
            Enemy_Instance[i] <= next_Enemy_Instance[i];
            Army_Instance[i] <= next_Army_Instance[i];
        end
        enemyGenPtr <= next_enemyGenPtr;
        genArmy <= next_genArmy;
        purseUpgrade <= next_purseUpgrade;
        towerFire <= next_towerFire;
        money <= next_money;
        purse_level <= next_purse_level;
        tower_cnt <= next_tower_cnt;
        towerBlood_E <= next_towerBlood_E;
        towerBlood_A <= next_towerBlood_A;
        counter1 <= next_counter1;
        counter2 <= next_counter2;
        counter3 <= next_counter3;
    end

    always @(*) begin
        for (i=0; i<8; i=i+1) begin
            next_Enemy_Instance[i] = Enemy_Instance[i];
            next_Army_Instance[i] = Army_Instance[i];
        end
        next_enemyGenPtr = enemyGenPtr;
        next_money = money;
        next_purse_level = purse_level;
        next_tower_cnt = tower_cnt;
        next_towerBlood_E = towerBlood_E;
        next_towerBlood_A = towerBlood_A;
        enemy_type_addr = enemy_type_addr;    // just default
        army_type_addr = army_type_addr;      // just default
        next_counter1 = counter1;
        next_counter2 = counter2;
        next_counter3 = counter3;

        case (gameState)
            `GS_REST: begin
                if (v_cnt==10'd490 && h_cnt<10'd5) begin
                    if (gameInit_OP)   next_gameState = `GS_INIT;
                    else               next_gameState = `GS_GEN_E;
                end else               next_gameState = gameState;
            end
            `GS_INIT: begin      // ? ///// Initialization
                next_gameState = `GS_GEN_E;
                for (i=0; i<8; i=i+1) begin
                    next_Enemy_Instance[i] = 56'd0;
                    next_Army_Instance[i] = 56'd0;
                end
                next_money = 15'd0;
                next_purse_level = 3'd0;
                next_tower_cnt = 8'd0;
                next_towerBlood_E = 12'd4000;
                next_towerBlood_A = 12'd4000;
                next_enemyGenPtr = 6'd0;
                next_counter1 = 6'd0;       // Finding Space ptr
                next_counter2 = 6'd0;       // Been Generated
            end
            `GS_GEN_E: begin     // ? ///// generate Enemy
                if (enemyGenPtr == 6'd63 ||             // All Enemy Been Generated
                    enemyQueueObj[14:3]>game_cnt ||     // Not Yet to Generate
                    counter2 ||                         // Already Find Space, generate and to the next gameState
                    counter1==6'd8) begin              // No Space
                    next_gameState = `GS_GEN_A_D;
                    if (counter2) begin
                        next_Enemy_Instance[counter1] = {1'b1, enemy_type_addr, `ENEMY_SPAWN_X, `SPAWN_Y-enemy_pixel_value[11:5], enemy_stats_value[37:26], 4'd1, 4'd0, 12'd0};
                    end
                end else begin
                    if (Enemy_Instance[counter1][55]==1'b0) begin   // Found A Space
                        enemy_type_addr = enemyQueueObj[1:0];       // Record the Enemy Type, to get the right data in next clk
                        next_counter2 = 6'd1;
                    end else next_counter1 = counter1 + 1'b1;       // This Addr No Space, find the next one
                end
            end
            `GS_GEN_A_D: begin   // ? ///// generate Army - Detect
                next_gameState = `GS_GEN_A_G;
                army_type_addr = genArmyType;
                if (genArmyValid) next_money = money - army_cost_value;
                next_counter1 = 6'd0;       // Finding Space ptr
                next_counter2 = genArmyValid;
            end
            `GS_GEN_A_G: begin   // ? ///// generate Army - Find Space to gen
                if (counter1==6'd8 || counter2==1'b0) begin              // No Space
                    next_gameState = `GS_ATK_E;
                    next_counter1 = 6'd0;
                    next_counter2 = 6'd0;
                end else begin
                    if (Army_Instance[counter1][55]==1'b0) begin    // Found A Space
                        next_gameState = `GS_ATK_E;
                        next_Army_Instance[counter1] = {1'b1, army_type_addr, `ARMY_SPAWN_X, `SPAWN_Y-army_pixel_value[11:5], army_stats_value[37:26], 4'd1, 4'd0, 12'd0};
                    end else next_counter1 = counter1 + 1'b1;       // This Addr No Space, find the next one
                end
            end
            `GS_ATK_E: begin     // ? ///// atk or move Enemy
                if (counter1==6'd8) begin              // No Space
                    next_gameState = `GS_ATK_A;
                    next_counter1 = 6'd0;
                    next_counter2 = 6'd0;
                end else begin
                    if (clk_6 && Enemy_Instance[counter1][55]==1'b1) begin
                        enemy_type_addr = Enemy_Instance[counter1][54:52];
                        army_type_addr = Army_Instance[counter2][54:52];
    // --------------------------------------------
    case (Enemy_Instance[counter1][19:16])
        `ST_MOVE: begin
            if (counter2 == 6'd8) begin
                next_Enemy_Instance[counter1][51:42] = Enemy_Instance[counter1][51:42] + enemy_stats_value[12:8];
                next_counter1 = counter1 + 1'b1;
                next_counter2 = 6'd0;
            end else if (
                (Enemy_Instance[counter1][51:42]+enemy_pixel_value[4:0]+enemy_stats_value[7:0]-army_pixel_value[4:0]>=Army_Instance[counter2][51:42]) ||(Enemy_Instance[counter1][51:42]+enemy_stats_value[7:0]>=`TOWER_A_X)
            ) begin         // in atk range
                next_Enemy_Instance[counter1][19:16] = `ST_ATK_0;
                next_Enemy_Instance[counter1][15:12] = 4'd0;
                next_counter1 = counter1 + 1'b1;
                next_counter2 = 6'd0;
            end else begin
                next_counter2 = counter2 + 1'b1;
            end
        end
        `ST_ATK_0: begin
            if (Enemy_Instance[counter1][15:12]==enemy_stats_value[16:13]) begin
                next_Enemy_Instance[counter1][19:16] = `ST_ATK_1;
                next_Enemy_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Enemy_Instance[counter1][15:12] = Enemy_Instance[counter1][15:12] + 1'b1;
            end
            next_counter1 = counter1 + 1'b1;
        end
        `ST_ATK_1: begin
            if (counter2==6'd8) begin
                if (Enemy_Instance[counter1][51:42]+enemy_stats_value[7:0] >= `TOWER_A_X)
                    next_towerBlood_A = (enemy_stats_value[25:17]>towerBlood_A ? 12'd0 : towerBlood_A-enemy_stats_value[25:17]);
                next_Enemy_Instance[counter1][19:16] = `ST_ATK_2;
                next_Enemy_Instance[counter1][15:12] = 4'd0;
                next_counter1 = counter1 + 1'b1;
                next_counter2 = 6'd0;
            end else begin
                if (Enemy_Instance[counter1][51:42]+enemy_pixel_value[4:0]+enemy_stats_value[7:0]>=Army_Instance[counter2][51:42]+army_pixel_value[4:0]) begin
                    next_Army_Instance[counter2][11:0] = Army_Instance[counter2][11:0] + enemy_stats_value[25:17];
                end
                next_counter2 = counter2 + 1'b1;
            end
        end
        `ST_ATK_2: begin
            if (Enemy_Instance[counter1][15:12]==enemy_stats_value[16:13]) begin
                next_Enemy_Instance[counter1][19:16] = `ST_ATK_3;
                next_Enemy_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Enemy_Instance[counter1][15:12] = Enemy_Instance[counter1][15:12] + 1'b1;
            end
            next_counter1 = counter1 + 1'b1;
        end
        `ST_ATK_3: begin
            if (Enemy_Instance[counter1][15:12]==enemy_stats_value[16:13]) begin
                next_Enemy_Instance[counter1][19:16] = `ST_MOVE;
                next_Enemy_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Enemy_Instance[counter1][15:12] = Enemy_Instance[counter1][15:12] + 1'b1;
            end
            next_counter1 = counter1 + 1'b1;
        end
        `ST_REPEL: begin
            if (Enemy_Instance[counter1][15:12]==4'd10) begin
                next_Enemy_Instance[counter1][19:16] = `ST_MOVE;
                next_Enemy_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Enemy_Instance[counter1][15:12] = Enemy_Instance[counter1][15:12] + 1'b1;
                next_Enemy_Instance[counter1][51:42] = Enemy_Instance[counter1][51:42] - 10'd3;
            end
            next_counter1 = counter1 + 1'b1;
        end
        default: begin
            next_Enemy_Instance[counter1][19:16] = `ST_MOVE;
            next_Enemy_Instance[counter1][15:12] = 4'd0;
            next_counter1 = counter1 + 1'b1;
        end
    endcase
    // --------------------------------------------
                    end
                end
            end
            `GS_ATK_A: begin     // ? ///// atk or move Army
                if (counter1==6'd8) begin              // No Space
                    next_gameState = `GS_TOWER_D;
                    next_counter1 = 6'd0;
                    next_counter2 = 6'd0;
                end else begin
                    if (clk_6 && Army_Instance[counter1][55]==1'b1) begin
                        army_type_addr = Army_Instance[counter1][54:52];
                        enemy_type_addr = Enemy_Instance[counter2][54:52];
    // --------------------------------------------
    case (Army_Instance[counter1][19:16])
        `ST_MOVE: begin
            if (counter2 == 6'd8) begin
                next_Army_Instance[counter1][51:42] = Army_Instance[counter1][51:42] - army_stats_value[12:8];
                next_counter1 = counter1 + 1'b1;
                next_counter2 = 6'd0;
            end else if (
                (Army_Instance[counter1][51:42]+army_pixel_value[4:0]<=Enemy_Instance[counter2][51:42]+army_stats_value[7:0]+enemy_pixel_value[4:0]) ||
                (`TOWER_E_X+army_stats_value[7:0]>=Army_Instance[counter1][51:42])
            ) begin         // in atk range
                next_Army_Instance[counter1][19:16] = `ST_ATK_0;
                next_Army_Instance[counter1][15:12] = 4'd0;
                next_counter1 = counter1 + 1'b1;
                next_counter2 = 6'd0;
            end else begin
                next_counter2 = counter2 + 1'b1;
            end
        end
        `ST_ATK_0: begin
            if (Army_Instance[counter1][15:12]==army_stats_value[16:13]) begin
                next_Army_Instance[counter1][19:16] = `ST_ATK_1;
                next_Army_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Army_Instance[counter1][15:12] = Army_Instance[counter1][15:12] + 1'b1;
            end
            next_counter1 = counter1 + 1'b1;
        end
        `ST_ATK_1: begin
            if (counter2==6'd8) begin
                if (`TOWER_E_X+army_stats_value[7:0]>=Army_Instance[counter1][51:42])
                    next_towerBlood_E = (army_stats_value[25:17]>towerBlood_E ? 12'd0 : towerBlood_E-army_stats_value[25:17]);
                next_Army_Instance[counter1][19:16] = `ST_ATK_2;
                next_Army_Instance[counter1][15:12] = 4'd0;
                next_counter1 = counter1 + 1'b1;
                next_counter2 = 6'd0;
            end else begin
                if (Army_Instance[counter1][51:42]+army_pixel_value[4:0]<=Enemy_Instance[counter2][51:42]+army_stats_value[7:0]+enemy_pixel_value[4:0]) begin
                    next_Enemy_Instance[counter2][11:0] = Enemy_Instance[counter2][11:0] + army_stats_value[25:17];
                end
                next_counter2 = counter2 + 1'b1;
            end
        end
        `ST_ATK_2: begin
            if (Army_Instance[counter1][15:12]==army_stats_value[16:13]) begin
                next_Army_Instance[counter1][19:16] = `ST_ATK_3;
                next_Army_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Army_Instance[counter1][15:12] = Army_Instance[counter1][15:12] + 1'b1;
            end
            next_counter1 = counter1 + 1'b1;
        end
        `ST_ATK_3: begin
            if (Army_Instance[counter1][15:12]==army_stats_value[16:13]) begin
                next_Army_Instance[counter1][19:16] = `ST_MOVE;
                next_Army_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Army_Instance[counter1][15:12] = Army_Instance[counter1][15:12] + 1'b1;
            end
            next_counter1 = counter1 + 1'b1;
        end
        `ST_REPEL: begin
            if (Army_Instance[counter1][15:12]==4'd10) begin
                next_Army_Instance[counter1][19:16] = `ST_MOVE;
                next_Army_Instance[counter1][15:12] = 4'd0;
            end else begin
                next_Army_Instance[counter1][15:12] = Army_Instance[counter1][15:12] + 1'b1;
                next_Army_Instance[counter1][51:42] = Army_Instance[counter1][51:42] + 10'd3;
            end
            next_counter1 = counter1 + 1'b1;
        end
        default: begin
            next_Army_Instance[counter1][19:16] = `ST_MOVE;
            next_Army_Instance[counter1][15:12] = 4'd0;
            next_counter1 = counter1 + 1'b1;
        end
    endcase
    // --------------------------------------------
                    end
                end
            end
            `GS_TOWER_D: begin   // ? ///// Tower fire Detect
                next_gameState = `GS_TOWER_O;
                if (towerFire) begin
                    next_tower_cnt = 8'd0;
                    next_counter1 = 6'd0;
                end else begin
                    if (clk_6 && tower_cnt < `TOWER_CNT_MAX) next_tower_cnt = tower_cnt + 1'b1;
                    next_counter1 = 6'd63;
                end
            end
            `GS_TOWER_O: begin   // ? ///// Tower fire Operate
                if (counter1 >= 6'd8) next_gameState = `GS_PURSE;
                else begin
                    if (Enemy_Instance[counter1][51:42] > 10'd250) begin
                        next_Enemy_Instance[counter1][19:16] = `ST_REPEL;
                        next_Enemy_Instance[counter1][15:12] = 4'd0;
                        next_Enemy_Instance[counter1][11:0] = Enemy_Instance[counter1][11:0] + 12'd300;
                    end
                    next_counter1 = counter1 + 1'b1;
                end
            end
            `GS_PURSE: begin     // ? ///// Purse Upgrade
                next_gameState = `GS_MONEY;
                if (purse_level != 3'd7 && ableToUpgrade) begin
                    next_money = money - purseUpgradeNeedMoney;
                    next_purse_level = purse_level + 1'b1;
                end 
            end
            `GS_MONEY: begin     // ? ///// Money Add with Time
                next_gameState = `GS_HURT_E;
                next_counter1 = 6'd0;
                if (clk_6) begin
                    if (purse_level==3'd0)      next_money = ((money + 1'b1 > money_Max) ? money_Max : money + 1'd1);
                    else if (purse_level<3'd3)  next_money = ((money + 2'd2 > money_Max) ? money_Max : money + 2'd2);
                    else if (purse_level==3'd3) next_money = ((money + 2'd3 > money_Max) ? money_Max : money + 2'd3);
                    else if (purse_level==3'd4) next_money = ((money + 3'd4 > money_Max) ? money_Max : money + 3'd4);
                    else                        next_money = ((money + 3'd5 > money_Max) ? money_Max : money + 3'd5);
                end else                        next_money = money;
            end
            `GS_HURT_E: begin    // ? ///// Enemy Update HP
                if (counter1==6'd8) begin
                    next_gameState = `GS_HURT_A;
                    next_counter1 = 6'd0;
                end else begin
                    if (Enemy_Instance[counter1][55] == 1'b1) begin
                        if (Enemy_Instance[counter1][11:0] >= Enemy_Instance[counter1][31:20]) next_Enemy_Instance[counter1][55] = 1'b0;
                        else next_Enemy_Instance[counter1][31:20] = Enemy_Instance[counter1][31:20] - Enemy_Instance[counter1][11:0];
                    end
                    next_counter1 = counter1 + 1'b1;
                end
            end
            `GS_HURT_A: begin    // ? ///// Army Update HP
                if (counter1==6'd8) begin
                    next_gameState = `GS_REST;
                end else begin
                    if (Army_Instance[counter1][55] == 1'b1) begin
                        if (Army_Instance[counter1][11:0] >= Army_Instance[counter1][31:20]) next_Army_Instance[counter1][55] = 1'b0;
                        else next_Army_Instance[counter1][31:20] = Army_Instance[counter1][31:20] - Army_Instance[counter1][11:0];
                    end
                    next_counter1 = counter1 + 1'b1;
                end
            end
            default: begin
                next_gameState = `GS_REST;
            end
        endcase
    end
endmodule