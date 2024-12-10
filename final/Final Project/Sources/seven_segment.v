module Seven_Segment(
    input rst,
    input clk,
    input [14:0] nums,
    output reg [6:0] display,
    output reg [3:0] digit
    );
    
    wire [1:0] display_clk;
    reg [3:0] display_num;

    Display_Clk_Gen DCG(clk, display_clk);

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            display_num <= 4'b0000;
            digit <= 4'b1111;
        end else begin
            case (display_clk)
                2'd0: begin
                    display_num <= nums % 10;
                    digit <= 4'b1110;
                end
                2'd1: begin
                    display_num <= (nums/10)%10;
                    digit <= 4'b1101;
                end
                2'd2: begin
                    display_num <= (nums/100)%10;
                    digit <= 4'b1011;
                end
                default: begin  // 2'd3
                    display_num <= (nums/1000)%10;
                    digit <= 4'b0111;
                end	
            endcase
        end
    end
    
    always @(*) begin
        case (display_num)
            4'd0: display = 7'b1000000;  // 0
            4'd1: display = 7'b1111001;  // 1
            4'd2: display = 7'b0100100;  // 2
            4'd3: display = 7'b0110000;  // 3
            4'd4: display = 7'b0011001;  // 4
            4'd5: display = 7'b0010010;  // 5
            4'd6: display = 7'b0000010;  // 6
            4'd7: display = 7'b1111000;  // 7
            4'd8: display = 7'b0000000;  // 8
            4'd9: display = 7'b0010000;  // 9
            default: display = 7'b1111111;
        endcase
    end
endmodule

module Display_Clk_Gen (clk, out);
    input clk;
    output [2-1:0] out;
    reg [19-1:0] cnt;

    assign out = cnt[18:17];
    always @(posedge clk) cnt <= cnt + 1'b1;
endmodule