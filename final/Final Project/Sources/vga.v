`timescale 1ns / 1ps

module VGA_Control (
    input clk,
    input pclk, reset,
    output hsync, vsync, valid,
    output reg [9:0] line_cnt,
    output [9:0] h_cnt,
    output [9:0] v_cnt,
    output reg [9:0] h_cnt_1,
    output reg [9:0] h_cnt_2,
    output reg [9:0] h_cnt_3,
    output reg [9:0] h_cnt_4,
    output reg [9:0] h_cnt_5,
    output reg [9:0] h_cnt_6,
    output reg [9:0] v_cnt_1,
    output reg [9:0] v_cnt_2,
    output reg [9:0] v_cnt_3,
    output reg [9:0] v_cnt_4,
    output reg [9:0] v_cnt_5,
    output reg [9:0] v_cnt_6,
    output reg clk_frame
    );
    
    reg [9:0] pixel_cnt;
    reg hsync_i,vsync_i;
    wire hsync_default, vsync_default;
    wire [9:0] HD, HF, HS, HB, HT, VD, VF, VS, VB, VT;

    assign HD = 640;
    assign HF = 16;
    assign HS = 96;
    assign HB = 48;
    assign HT = 800; 
    assign VD = 480;
    assign VF = 10;
    assign VS = 2;
    assign VB = 33;
    assign VT = 525;
    assign hsync_default = 1'b1;
    assign vsync_default = 1'b1;

    always @(posedge pclk) begin
        if (reset)                      pixel_cnt <= 0;
        else if (pixel_cnt < (HT - 1))  pixel_cnt <= pixel_cnt + 1;
        else                            pixel_cnt <= 0;
    end

    always @(posedge pclk) begin
        if (reset)                      hsync_i <= hsync_default;
        else if ((pixel_cnt >= (HD + HF - 1))&&(pixel_cnt < (HD + HF + HS - 1)))
                                        hsync_i <= ~hsync_default;
        else                            hsync_i <= hsync_default; 
    end

    always @(posedge pclk) begin
        if (reset)                      line_cnt <= 0;
        else if (pixel_cnt == (HT -1)) begin
            if (line_cnt < (VT - 1))    line_cnt <= line_cnt + 1;
            else                        line_cnt <= 0;
        end
    end

    always @(posedge pclk) begin
        if (reset)                      vsync_i <= vsync_default; 
        else if ((line_cnt >= (VD + VF - 1))&&(line_cnt < (VD + VF + VS - 1)))
                                        vsync_i <= ~vsync_default; 
        else                            vsync_i <= vsync_default; 
    end

    always @(posedge pclk) begin
        if (reset)              clk_frame <= 1'b0;
        else if (line_cnt>VD)   clk_frame <= 1'b1;
        else                    clk_frame <= 1'b0;
    end

    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD));
    
    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt : 10'd0;
    assign v_cnt = (line_cnt < VD) ? line_cnt : 10'd0;

    reg [9:0] next_h_cnt_1, next_h_cnt_2, next_h_cnt_3, next_h_cnt_4, next_h_cnt_5, next_h_cnt_6;
    reg [9:0] next_v_cnt_1, next_v_cnt_2, next_v_cnt_3, next_v_cnt_4, next_v_cnt_5, next_v_cnt_6;
    always @(negedge clk) begin
        h_cnt_1 <= next_h_cnt_1;
        h_cnt_2 <= next_h_cnt_2;
        h_cnt_3 <= next_h_cnt_3;
        h_cnt_4 <= next_h_cnt_4;
        h_cnt_5 <= next_h_cnt_6;
        h_cnt_6 <= next_h_cnt_5;
        v_cnt_1 <= next_v_cnt_1;
        v_cnt_2 <= next_v_cnt_2;
        v_cnt_3 <= next_v_cnt_3;
        v_cnt_4 <= next_v_cnt_4;
        v_cnt_5 <= next_v_cnt_5;
        v_cnt_6 <= next_v_cnt_6;
    end
    always @(*) begin
        if (pixel_cnt < 640) begin
            next_h_cnt_1 = pixel_cnt + 1;
            next_v_cnt_1 = line_cnt;
        end else if (pixel_cnt == 799) begin
            next_h_cnt_1 = 10'd0;
            next_v_cnt_1 = line_cnt + 1;
        end else begin
            next_h_cnt_1 = 10'd0;
            next_v_cnt_1 = line_cnt;
        end
    end
    always @(*) begin
        if (pixel_cnt < 639) begin
            next_h_cnt_2 = pixel_cnt + 2;
            next_v_cnt_2 = line_cnt;
        end else if (pixel_cnt == 798) begin
            next_h_cnt_2 = 10'd0;
            next_v_cnt_2 = line_cnt + 1;
        end else if (pixel_cnt == 799) begin
            next_h_cnt_2 = 10'd1;
            next_v_cnt_2 = line_cnt + 1;
        end else begin
            next_h_cnt_2 = 10'd0;
            next_v_cnt_2 = line_cnt;
        end
    end
    always @(*) begin
        if (pixel_cnt < 638) begin
            next_h_cnt_3 = pixel_cnt + 3;
            next_v_cnt_3 = line_cnt;
        end else if (pixel_cnt == 797) begin
            next_h_cnt_3 = 10'd0;
            next_v_cnt_3 = line_cnt + 1;
        end else if (pixel_cnt == 798) begin
            next_h_cnt_3 = 10'd1;
            next_v_cnt_3 = line_cnt + 1;
        end else if (pixel_cnt == 799) begin
            next_h_cnt_3 = 10'd2;
            next_v_cnt_3 = line_cnt + 1;
        end else begin
            next_h_cnt_3 = 10'd0;
            next_v_cnt_3 = line_cnt;
        end
    end
    always @(*) begin
        if (pixel_cnt < 637) begin
            next_h_cnt_4 = pixel_cnt + 4;
            next_v_cnt_4 = line_cnt;
        end else if (pixel_cnt == 796) begin
            next_h_cnt_4 = 10'd0;
            next_v_cnt_4 = line_cnt + 1;
        end else if (pixel_cnt == 797) begin
            next_h_cnt_4 = 10'd1;
            next_v_cnt_4 = line_cnt + 1;
        end else if (pixel_cnt == 798) begin
            next_h_cnt_4 = 10'd2;
            next_v_cnt_4 = line_cnt + 1;
        end else if (pixel_cnt == 799) begin
            next_h_cnt_4 = 10'd3;
            next_v_cnt_4 = line_cnt + 1;
        end else begin
            next_h_cnt_4 = 10'd0;
            next_v_cnt_4 = line_cnt;
        end
    end
    always @(*) begin
        if (pixel_cnt < 636) begin
            next_h_cnt_5 = pixel_cnt + 5;
            next_v_cnt_5 = line_cnt;
        end else if (pixel_cnt == 795) begin
            next_h_cnt_5 = 10'd0;
            next_v_cnt_5 = line_cnt + 1;
        end else if (pixel_cnt == 796) begin
            next_h_cnt_5 = 10'd1;
            next_v_cnt_5 = line_cnt + 1;
        end else if (pixel_cnt == 797) begin
            next_h_cnt_5 = 10'd2;
            next_v_cnt_5 = line_cnt + 1;
        end else if (pixel_cnt == 798) begin
            next_h_cnt_5 = 10'd3;
            next_v_cnt_5 = line_cnt + 1;
        end else if (pixel_cnt == 799) begin
            next_h_cnt_5 = 10'd4;
            next_v_cnt_5 = line_cnt + 1;
        end else begin
            next_h_cnt_5 = 10'd0;
            next_v_cnt_5 = line_cnt;
        end
    end
    always @(*) begin
        if (pixel_cnt < 635) begin
            next_h_cnt_6 = pixel_cnt + 6;
            next_v_cnt_6 = line_cnt;
        end else if (pixel_cnt == 794) begin
            next_h_cnt_6 = 10'd0;
            next_v_cnt_6 = line_cnt + 1;
        end else if (pixel_cnt == 795) begin
            next_h_cnt_6 = 10'd1;
            next_v_cnt_6 = line_cnt + 1;
        end else if (pixel_cnt == 796) begin
            next_h_cnt_6 = 10'd2;
            next_v_cnt_6 = line_cnt + 1;
        end else if (pixel_cnt == 797) begin
            next_h_cnt_6 = 10'd3;
            next_v_cnt_6 = line_cnt + 1;
        end else if (pixel_cnt == 798) begin
            next_h_cnt_6 = 10'd4;
            next_v_cnt_6 = line_cnt + 1;
        end else if (pixel_cnt == 799) begin
            next_h_cnt_6 = 10'd5;
            next_v_cnt_6 = line_cnt + 1;
        end else begin
            next_h_cnt_6 = 10'd0;
            next_v_cnt_6 = line_cnt;
        end
    end
endmodule
