module Pixel_Gen (
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [9:0] mouseX,
    input [9:0] mouseY,
    input valid,
    input enable_mouse_display,
    input [11:0] mouse_pixel,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
);

    always@(*) begin
        if(!valid)                     {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        else if (enable_mouse_display) {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
        else begin
            // TODO
        end
    end
endmodule
