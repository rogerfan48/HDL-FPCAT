module Mouse (
    input clk,
    input clk_25MHz,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output enable_mouse_display,
    output [9:0] MOUSE_X_POS,
    output [9:0] MOUSE_Y_POS,
    output MOUSE_LEFT_OP,
    // output MOUSE_MIDDLE,
    // output MOUSE_RIGHT,
    // output MOUSE_NEW_EVENT,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    inout PS2_CLK,
    inout PS2_DATA
);

    wire [3:0] MOUSE_Z_POS;
    wire MOUSE_LEFT_DB;
    Debounce DB_L (clk_25MHz, MOUSE_LEFT_ORI, MOUSE_LEFT_DB);
    One_Palse OP_L (clk_25MHz, MOUSE_LEFT_DB, MOUSE_LEFT_OP);
    
    MouseCtl #(
        .SYSCLK_FREQUENCY_HZ(108000000),
        .CHECK_PERIOD_MS(500),
        .TIMEOUT_PERIOD_MS(100)
    ) MC1 (
        .clk(clk),
        .rst(1'b0),
        .xpos(MOUSE_X_POS),
        .ypos(MOUSE_Y_POS),
        .zpos(MOUSE_Z_POS),
        .left(MOUSE_LEFT_ORI),
        .middle(MOUSE_MIDDLE),
        .right(MOUSE_RIGHT),
        .new_event(MOUSE_NEW_EVENT),
        .value(12'd0),
        .setx(1'b0),
        .sety(1'b0),
        .setmax_x(1'b0),
        .setmax_y(1'b0),
        .ps2_clk(PS2_CLK),
        .ps2_data(PS2_DATA)
    );
    MouseDisplay MD1 (
        .pixel_clk(clk),
        .xpos(MOUSE_X_POS),
        .ypos(MOUSE_Y_POS),
        .hcount(h_cnt),
        .vcount(v_cnt),
        .enable_mouse_display_out(enable_mouse_display),
        .red_out(red),
        .green_out(green),
        .blue_out(blue)
    );
endmodule