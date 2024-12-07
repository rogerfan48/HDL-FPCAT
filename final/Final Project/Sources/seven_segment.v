module Seven_Segment(
    input rst,
    input clk,
    input [14:0] nums,
    output reg [6:0] display,
    output reg [3:0] digit
    );
    
    wire [1:0] display_clk;
    reg [3:0] display_num;

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;

    Display_Clk_Gen DCG(clk, display_clk);

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            display_num <= 4'b0000;
            digit <= 4'b1111;
        end else begin
            case (display_clk)
                2'd0: begin
                    display_num <= nums[3:0];
                    digit <= 4'b1110;
                end
                2'd1: begin
                    display_num <= (nums/10);
                    digit <= 4'b1101;
                end
                2'd2: begin
                    display_num <= (nums/100);
                    digit <= 4'b1011;
                end
                default: begin  // 2'd3
                    display_num <= (nums/1000);
                    digit <= 4'b0111;
                end	
            endcase
        end
    end
    
    always @ (*) begin
        case (display_num)
            0 : display = 7'b1000000;	//0000
            1 : display = 7'b1111001;   //0001                                                
            2 : display = 7'b0100100;   //0010                                                
            3 : display = 7'b0110000;   //0011                                             
            4 : display = 7'b0011001;   //0100                                               
            5 : display = 7'b0010010;   //0101                                               
            6 : display = 7'b0000010;   //0110
            7 : display = 7'b1111000;   //0111
            8 : display = 7'b0000000;   //1000
            9 : display = 7'b0010000;	//1001
            default : display = 7'b1111111;
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