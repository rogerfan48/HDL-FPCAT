`define     CH_None 3'b000
`define Killer_Bird 3'b001
`define  White_Bear 2'b010
`define  Metal_Duck 2'b011 
`define  Black_Bear 2'b100

`define ST_NONE 3'b000
`define  MOVE_0 3'b001
`define  MOVE_1 3'b010
`define  MOVE_2 3'b011
`define  ATT_CD 3'b100
`define   ATT_0 3'b101
`define   ATT_1 3'b110
`define   ATT_2 3'b111

module Enemy_0_state(
    input clk,
    input clk_25MHz,
    input rst,
    input stop,
    
    input [39:0] damage,
    output [4:0] state,
    

);