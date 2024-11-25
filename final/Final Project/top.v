module Top (
    input clk,
    input rst,
    input button_in_U,
    input button_in_D,
    input button_in_L,
    input button_in_R,
    input button_in_M,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync,
    inout PS2_CLK,
    inout PS2_DATA
);

    wire button_U, button_D, button_L, button_R, button_M;
    Debounce DB_U (clk, button_in_U, button_U);
    Debounce DB_D (clk, button_in_D, button_D);
    Debounce DB_L (clk, button_in_L, button_L);
    Debounce DB_R (clk, button_in_R, button_R);
    Debounce DB_M (clk, button_in_M, button_M);

    wire clk_25MHz;
    Clk_Divisor_4 Clk_Div_4 (clk, clk_25MHz);

    wire valid;
    wire clk_frame;
    wire [9:0] h_cnt;  //640
    wire [9:0] v_cnt;  //480

    wire enable_mouse_display;
    wire [9:0] mouseX, mouseY;
    wire mouseL;
    wire [3:0] MOUSE_RED, MOUSE_GREEN, MOUSE_BLUE;
    wire [11:0] MOUSE_PIXEL = {MOUSE_RED, MOUSE_GREEN, MOUSE_BLUE};

    parameter S_MENU = 3'd0;
    parameter S_PLAY1 = 3'd1;
    parameter S_PLAY2 = 3'd2;
    parameter S_PLAY3 = 3'd3;
    parameter S_PAUSE = 3'd4;
    parameter S_UPGRADE = 3'd5;
    parameter S_WIN = 3'd6;
    parameter S_LOSE = 3'd7;
    reg [2:0] scene;

    parameter W_GUN = 2'd0;
    parameter W_SHOTGUN = 2'd1;
    parameter W_BAT = 2'd2;
    reg [1:0] main_weapon;



    Pixel_Gen Pixel_Gen (
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .mouseX(mouseX),
        .mouseY(mouseY),
        .valid(valid),
        .enable_mouse_display(enable_mouse_display),
        .mouse_pixel(MOUSE_PIXEL),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );

    VGA_Control VGA_Ctrl (
        .pclk(clk_25MHz),
        .reset(rst),
        .hsync(hsync),
        .vsync(vsync),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .clk_frame(clk_frame)
    );

    Mouse Mouse_Ctrl (
        .clk(clk),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .enable_mouse_display(enable_mouse_display),
        .MOUSE_X_POS(mouseX),
        .MOUSE_Y_POS(mouseY),
        .MOUSE_LEFT(mouseL),
        .red(MOUSE_RED),
        .green(MOUSE_GREEN),
        .blue(MOUSE_BLUE),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA)
    );
endmodule

module Debounce(clk, pb, pb_d);
    input clk, pb;
    output pb_d;
    reg [8-1:0] DFF;

    assign pb_d = &DFF;
    always @(posedge clk) DFF[7:0] <= {DFF[6:0], pb};
endmodule

module One_Palse (clk, pb_d, pb_1p);
    input clk, pb_d;
    output reg pb_1p;

    reg pb_delay;
    always @(posedge clk) pb_delay <= pb_d;
    always @(posedge clk) pb_1p <= pb_d & ~pb_delay;
endmodule

/*

enemy: 
[
    [1]: exist
    [12]: y
    [12]: x
    [7]: hp
    [3]: type
    [2]: speed_counter
]
bullet:
[
    [1]: exist
    [12]: y
    [12]: x
    [7]: radius
    [7]: hp
    [7]: atk
]
dead_effect:
[
    [1]: exist
    [12]: y
    [12]: x
    [7]: radius
    [5]: counter
    [2]: type
]
gas_bomb:       // follow clk_frame
[
    [1]: exist
    [12]: y
    [12]: x
    [7]: radius
    [8]: counter
]

HP:100      radius:15
            atk     cd      radius  speed   num
GUN1:       8       30                      1
GUN2:       10      20                      1
GUN3:       13      20                      2
SHOTGUN1:    
SHOTGUN2:
SHOTGUN3:
BAT1:    
BAT2:
BAT3:

        hp      atk     speed   radius  color
Enemy1: 8       4       3       10      
Enemy2: 12      4       3       10      
Enemy3: 30      6       4       12      
Enemy4: 15      10      2       8       
Enemy5: 50      10      4       15      
Enemy6: 50      10      3       15         
Enemy7: 12      15      1       8       

reg [?:0] MEM [?]

*/