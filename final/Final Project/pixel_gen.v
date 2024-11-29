module Pixel_Gen (
    input clk,
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    input [9:0] mouseX,
    input [9:0] mouseY,
    input valid,
    input enable_mouse_display,
    input [11:0] mouse_pixel,
    input [2:0] scene,
    input mouseInStart,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue
);

    parameter S_START = 3'd0;
    parameter S_MENU = 3'd1;
    parameter S_PLAY1 = 3'd2;
    parameter S_PLAY2 = 3'd3;
    parameter S_PLAY3 = 3'd4;
    parameter S_WIN = 3'd5;
    parameter S_LOSE = 3'd6;

    wire [10:0] FPCAT_addr = (((v_cnt-150)/5)*60 + ((h_cnt-170)/5)) % 1200;
    wire FPCAT_value;
    mem_FPCAT mem_FPCAT_0 (
        .clka(clk),    // input wire clka 輸入時鐘信號
        .wea(1'b0),      // input wire [0 : 0] wea 1位元的寫入使能信號
        .addra(FPCAT_addr),  // input wire [10 : 0] addra 11位元的位址信號[10:0]
        .dina(1'b0),    // input wire [0 : 0] dina 1位元的輸入資料
        .douta(FPCAT_value)   // output wire [0 : 0] douta 1位元的輸出資料
    );

    always@(*) begin
        if(!valid)                     {vgaRed, vgaGreen, vgaBlue} = 12'h0;
        else if (enable_mouse_display) {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
        else begin
            case(scene)
S_START: begin
    if (h_cnt>=10'd200 && h_cnt<10'd440 && v_cnt>=10'd270 && v_cnt<10'd320) begin
        if (mouseInStart) {vgaRed, vgaGreen, vgaBlue} = 12'h632;
        else              {vgaRed, vgaGreen, vgaBlue} = 12'h521;
    end else if (h_cnt>=10'd170 && h_cnt<10'd470 && v_cnt>=10'd150 && v_cnt<10'd250 && FPCAT_value==1'b1) begin
        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
    end else begin
        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
    end
end
S_MENU: begin
    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
end
S_PLAY1: begin
    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
end
S_PLAY2: begin
    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
end
S_PLAY3: begin
    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
end
S_WIN: begin
    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
end
S_LOSE: begin
    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
end
default: begin
    {vgaRed, vgaGreen, vgaBlue} = 12'h0;
end
            endcase
        end
    end

    
endmodule