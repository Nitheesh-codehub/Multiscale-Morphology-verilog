`timescale 1ns / 1ps
module line_buffer_3x3 #(
    parameter IMG_W = 256
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  pixel_in,
    output wire [7:0]  w0,w1,w2,w3,w4,w5,w6,w7,w8
);

    reg [7:0] line1 [0:IMG_W-1];
    reg [7:0] line2 [0:IMG_W-1];
    reg [7:0] p0,p1,p2;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            p0<=0; p1<=0; p2<=0;
            for (i=0;i<IMG_W;i=i+1) begin
                line1[i]<=0; line2[i]<=0;
            end
        end else begin
            p2<=p1; p1<=p0; p0<=pixel_in;
            for (i=IMG_W-1;i>0;i=i-1) begin
                line2[i]<=line2[i-1];
                line1[i]<=line1[i-1];
            end
            line2[0]<=line1[0];
            line1[0]<=pixel_in;
        end
    end

    assign w0=line2[2]; assign w1=line2[1]; assign w2=line2[0];
    assign w3=line1[2]; assign w4=line1[1]; assign w5=line1[0];
    assign w6=p2;       assign w7=p1;       assign w8=p0;

endmodule

