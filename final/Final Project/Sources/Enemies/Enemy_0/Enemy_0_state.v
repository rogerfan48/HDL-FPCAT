`define     CH_None 3'b000
`define Killer_Bird 3'b001
`define  White_Bear 3'b010
`define  Metal_Duck 3'b011 
`define  Black_Bear 3'b100

`define ST_NONE 3'b000
`define  MOVE_0 3'b001
`define  MOVE_1 3'b010
`define  MOVE_2 3'b011
`define  ATT_CD 3'b100
`define   ATT_0 3'b101
`define   ATT_1 3'b110
`define   ATT_2 3'b111

`define Killer_Bird_y_pos 10'd100
`define  White_Bear_y_pos 10'd100
`define  Metal_Duck_y_pos 10'd120
`define  Black_Bear_y_pos 10'd100

`define Killer_Bird_speed 10'd10
`define  White_Bear_speed 10'd8
`define  Metal_Duck_speed 10'd2
`define  Black_Bear_speed 10'd50

`define Killer_Bird_MHP 12'd500
`define  White_Bear_MHP 12'd4000
`define  Metal_Duck_MHP 12'd200
`define  Black_Bear_MHP 12'd50

`define  Normal_ATT 1'b0
`define Special_ATT 1'b1

`define Killer_Bird_MOVE_CD 8'd8
`define  White_Bear_MOVE_CD 8'd8
`define  Metal_Duck_MOVE_CD 8'd8
`define  Black_Bear_MOVE_CD 8'd2

`define Killer_Bird_ATT_CD_0 8'd8
`define  White_Bear_ATT_CD_0 8'd12
`define  Metal_Duck_ATT_CD_0 8'd20
`define  Black_Bear_ATT_CD_0 8'd1

`define Killer_Bird_ATT_0_1 8'd7
`define  White_Bear_ATT_0_1 8'd2
`define  Metal_Duck_ATT_0_1 8'd19
`define  Black_Bear_ATT_0_1 8'd1

`define Killer_Bird_ATT_2_CD 8'd8
`define  White_Bear_ATT_2_CD 8'd2
`define  Metal_Duck_ATT_2_CD 8'd20
`define  Black_Bear_ATT_2_CD 8'd2

module Enemy_0_state(
    input clk,
    input rst,
    input stop,
    input gen,
    input [2:0] gen_type,
    input [3:0] damage_type,
    input [39:0] damage,
    input CTinFront,

    output reg [2:0] type,
    output reg [2:0] state,
    output reg [9:0] x_pos,
    output reg [9:0] y_pos
);
    wire [11:0] damage_Normal = damage[9:0] + damage[19:10] + damage[29:20] + damage[39:30];
    wire [11:0]  damage_Metal = ((damage_type[0] == `Normal_ATT) ? 10'd1 : damage[9:0]) + 
                                ((damage_type[1] == `Normal_ATT) ? 10'd1 : damage[19:10]) + 
                                ((damage_type[2] == `Normal_ATT) ? 10'd1 : damage[29:20]) + 
                                ((damage_type[3] == `Normal_ATT) ? 10'd1 : damage[39:30]);

    reg [11:0] hp;
    reg [11:0] next_hp;
    reg [7:0] state_cnt;
    reg [7:0] next_state_cnt;

    reg [2:0] next_type;
    reg [2:0] next_state;
    reg [9:0] next_x_pos;
    reg [9:0] next_y_pos;

    //FSM of Enemy_0
    always @(posedge clk) begin
        if (rst) begin
            hp <= 10'd0;
            type <= `CH_None;
            state_cnt <= 8'd0;
            state <= `ST_NONE;
            x_pos <= 10'd0;
            y_pos <= 10'd0;
        end else if (stop) begin
            hp <= hp;
            type <= type;
            state_cnt <= state_cnt;
            state <= state;
            x_pos <= x_pos;
            y_pos <= y_pos;
        end else begin
            hp <= next_hp;
            type <= next_type;
            state_cnt <= next_state_cnt;
            state <= next_state;
            x_pos <= next_x_pos;
            y_pos <= next_y_pos;
        end
    end

    //update hp and type
    always @(*) begin
        if (gen && gen_type == `Killer_Bird) begin
            next_hp = `Killer_Bird_MHP;
            next_type = `Killer_Bird;
        end else if (gen && gen_type == `White_Bear) begin
            next_hp = `White_Bear_MHP;
            next_type = `White_Bear;
        end else if (gen && gen_type == `Metal_Duck) begin
            next_hp = `Metal_Duck_MHP;
            next_type = `Metal_Duck;
        end else if (gen && gen_type == `Black_Bear) begin
            next_hp = `Black_Bear_MHP;
            next_type = `Black_Bear;
        end else begin
            case (type)
                `CH_None: begin
                    next_hp = 12'd0;
                    next_type = `CH_None;
                end
                `Metal_Duck: begin
                    if(damage_Metal < hp) begin
                        next_hp = hp - damage_Metal;
                        next_type = type;
                    end else begin
                        next_hp = 12'd0;
                        next_type = `CH_None;
                    end
                end
                default: begin
                    if(damage_Normal < hp) begin
                        next_hp = hp - damage_Normal;
                        next_type = type;
                    end else begin
                        next_hp = 12'd0;
                        next_type = `CH_None;
                    end
                end
            endcase
        end
    end

    //update state_cnt and state
    always @(*) begin
        if (gen) begin
            next_state_cnt = 8'd0;
            next_state = `MOVE_0;
        end else begin
            if(type != `CH_None) begin
                case (state)
                    `MOVE_0: begin
                        if(CTinFront) begin
                            next_state_cnt = 8'd0;
                            next_state = `ATT_0;
                        end else begin
                            if((type == `Killer_Bird && state_cnt == `Killer_Bird_MOVE_CD) || 
                               (type == `White_Bear && state_cnt == `White_Bear_MOVE_CD) || 
                               (type == `Metal_Duck && state_cnt == `Metal_Duck_MOVE_CD) || 
                               (type == `Black_Bear && state_cnt == `Black_Bear_MOVE_CD)) begin
                                next_state_cnt = 8'd0;
                                next_state = `MOVE_1;
                            end else begin
                                next_state_cnt = state_cnt + 8'd1;
                                next_state = `MOVE_0;
                            end
                        end
                    end
                    `MOVE_1: begin
                        if(CTinFront) begin
                            next_state_cnt = 8'd0;
                            next_state = `ATT_0;  
                        end else begin
                            if((type == `Killer_Bird && state_cnt == `Killer_Bird_MOVE_CD) || 
                               (type == `White_Bear && state_cnt == `White_Bear_MOVE_CD) || 
                               (type == `Metal_Duck && state_cnt == `Metal_Duck_MOVE_CD) || 
                               (type == `Black_Bear && state_cnt == `Black_Bear_MOVE_CD)) begin
                                next_state_cnt = 8'd0;
                                next_state = `MOVE_2;
                            end else begin
                                next_state_cnt = state_cnt + 8'd1;
                                next_state = `MOVE_1;
                            end
                        end
                    end
                    `MOVE_2: begin
                        if(CTinFront) begin
                            next_state_cnt = 8'd0;
                            next_state = `ATT_0;  
                        end else begin
                            if((type == `Killer_Bird && state_cnt == `Killer_Bird_MOVE_CD) || 
                               (type == `White_Bear && state_cnt == `White_Bear_MOVE_CD) || 
                               (type == `Metal_Duck && state_cnt == `Metal_Duck_MOVE_CD) || 
                               (type == `Black_Bear && state_cnt == `Black_Bear_MOVE_CD)) begin
                                next_state_cnt = 8'd0;
                                next_state = `MOVE_0;
                            end else begin
                                next_state_cnt = state_cnt + 8'd1;
                                next_state = `MOVE_2;
                            end
                        end
                    end
                    `ATT_CD: begin
                        if(!CTinFront) begin
                            next_state_cnt = 8'd0;
                            next_state = `MOVE_0;
                        end else begin
                            if((type == `Killer_Bird && state_cnt == `Killer_Bird_ATT_CD_0) || 
                               (type == `White_Bear && state_cnt == `White_Bear_ATT_CD_0) || 
                               (type == `Metal_Duck && state_cnt == `Metal_Duck_ATT_CD_0) || 
                               (type == `Black_Bear && state_cnt == `Black_Bear_ATT_CD_0)) begin
                                next_state_cnt = 8'd0;
                                next_state = `ATT_0;
                            end else begin
                                next_state_cnt = state_cnt + 8'd1;
                                next_state = `ATT_CD;
                            end
                        end
                    end
                    `ATT_0: begin
                        if((type == `Killer_Bird && state_cnt == `Killer_Bird_ATT_0_1) || 
                           (type == `White_Bear && state_cnt == `White_Bear_ATT_0_1) || 
                           (type == `Metal_Duck && state_cnt == `Metal_Duck_ATT_0_1) || 
                           (type == `Black_Bear && state_cnt == `Black_Bear_ATT_0_1)) begin
                            next_state_cnt = 8'd0;
                            next_state = `ATT_1;
                        end else begin
                            next_state_cnt = state_cnt + 8'd1;
                            next_state = `ATT_0;
                        end
                    end
                    `ATT_1: begin
                        next_state_cnt = 8'd0;
                        next_state = `ATT_2;
                    end
                    `ATT_2: begin
                        if((type == `Killer_Bird && state_cnt == `Killer_Bird_ATT_2_CD) || 
                           (type == `White_Bear && state_cnt == `White_Bear_ATT_2_CD) || 
                           (type == `Metal_Duck && state_cnt == `Metal_Duck_ATT_2_CD) || 
                           (type == `Black_Bear && state_cnt == `Black_Bear_ATT_2_CD)) begin
                            next_state_cnt = 8'd0;
                            next_state = `ATT_CD;
                        end else begin
                            next_state_cnt = state_cnt + 8'd1;
                            next_state = `ATT_2;
                        end
                    end
                    default: begin
                        next_state_cnt = 8'd0;
                        next_state = `ST_NONE;
                    end
                endcase
            end else begin
                next_state_cnt = 8'd0;
                next_state = `ST_NONE;
            end
        end
    end

    //update x_pos and y_pos
    always @(*) begin
        if (gen) begin
            next_x_pos = 10'd30;
            next_y_pos = (gen_type == `Killer_Bird) ? `Killer_Bird_y_pos : 
                         (gen_type == `White_Bear) ? `White_Bear_y_pos : 
                         (gen_type == `Metal_Duck) ? `Metal_Duck_y_pos : `Black_Bear_y_pos;
        end else begin
            if(type != `CH_None) begin
                case (state)
                    `MOVE_0, `MOVE_1, `MOVE_2: begin
                        next_x_pos = x_pos + ((type == `Killer_Bird) ? `Killer_Bird_speed : 
                                              (type == `White_Bear) ? `White_Bear_speed : 
                                              (type == `Metal_Duck) ? `Metal_Duck_speed : `Black_Bear_speed);
                        next_y_pos = y_pos;
                    end
                    `ATT_CD, `ATT_0, `ATT_1, `ATT_2: begin
                        next_x_pos = x_pos;
                        next_y_pos = y_pos;
                    end
                endcase
            end else begin
                next_x_pos = 10'd0;
                next_y_pos = 10'd0;
            end
        end
    end

endmodule