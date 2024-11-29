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
    wire [9:0] h_cnt;   //640
    wire [9:0] ah_cnt;  //640
    wire [9:0] v_cnt;   //480
    wire [9:0] av_cnt;  //480

    wire enable_mouse_display;
    wire [9:0] mouseX, mouseY;
    wire mouseL;
    wire [3:0] MOUSE_RED, MOUSE_GREEN, MOUSE_BLUE;
    wire [11:0] MOUSE_PIXEL = {MOUSE_RED, MOUSE_GREEN, MOUSE_BLUE};

    parameter S_START = 3'd0;
    parameter S_MENU = 3'd1;
    parameter S_PLAY1 = 3'd2;
    parameter S_PLAY2 = 3'd3;
    parameter S_PLAY3 = 3'd4;
    parameter S_WIN = 3'd5;
    parameter S_LOSE = 3'd6;
    reg [2:0] scene;
    reg [2:0] next_scene;

    wire mouseInStart = (mouseX>=10'd200 && mouseX<10'd440 && mouseY>=10'd270 && mouseY<10'd330);
    Pixel_Gen Pixel_Gen (
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
        .ah_cnt(ah_cnt),
        .v_cnt(v_cnt),
        .av_cnt(av_cnt),
        .clk_frame(clk_frame)
    );

    Mouse Mouse_Ctrl (
        .clk(clk),
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
    always @(posedge clk) begin
        if (rst) scene <= S_START;
        else     scene <= next_scene;
    end
    always @(*) begin
        case (scene)
S_START: begin
    if (mouseL && mouseInStart)
        next_scene <= S_MENU;
    else next_scene <= S_START;
end
S_MENU: begin
    if (mouseL && mouseX>=10'd160 && mouseX<10'd480 && mouseY>=10'd80 && mouseY<10'd140)
        next_scene <= S_PLAY1;
    else if (mouseL && mouseX>=10'd160 && mouseX<10'd480 && mouseY>=10'd200 && mouseY<10'd260)
        next_scene <= S_PLAY2;
    else if (mouseL && mouseX>=10'd160 && mouseX<10'd480 && mouseY>=10'd320 && mouseY<10'd380)
        next_scene <= S_PLAY3;
    else next_scene <= S_MENU;
end
S_PLAY1: begin

end
S_PLAY2: begin

end
S_PLAY3: begin

end
S_WIN: begin

end
S_LOSE: begin

end
default: next_scene <= scene;
        endcase
    end
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

*/