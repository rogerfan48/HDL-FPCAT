`define ST_NONE 3'b000
`define  MOVE_0 3'b001
`define  MOVE_1 3'b010
`define  MOVE_2 3'b011
`define  ATT_CD 3'b100
`define   ATT_0 3'b101
`define   ATT_1 3'b110
`define   ATT_2 3'b111

`define     CH_None 3'b000
`define Killer_Bird 3'b001
`define  White_Bear 3'b010
`define  Metal_Duck 3'b011 
`define  Black_Bear 3'b100

`define Killer_Bird_Height 15
`define  White_Bear_Height 30
`define  Metal_Duck_Height 20
`define  Black_Bear_Height 30

module mem_enemy_0_addr_gen(
    input [9:0] v_cnt,
    input [9:0] h_cnt,
    input [9:0] av_cnt,
    input [9:0] ah_cnt,
    input [2:0] type,
    input [2:0] state,
    input [9:0] x_pos,
    input [9:0] y_pos,

    output [11:0] enemy_0_addr 
);
    
    always @(*) begin
        case (state)
            `MOVE_0: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
            `MOVE_1: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
            `MOVE_2: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
            `ATT_CD: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
            `ATT_0: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
            `ATT_1: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
            `ATT_2: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
            default: begin
                if(type == `Killer_Bird) begin
                    
                end else if(type == `White_Bear) begin
                
                end else if(type == `Metal_Duck) begin
                
                end else if(type == `Black_Bear) begin
                
                end else begin

                end
            end
        endcase
    end

endmodule