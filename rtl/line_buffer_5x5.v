module line_buffer_5x5 #(
    parameter IMG_W = 256
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  pixel_in,

    output wire [7:0] w0,  w1,  w2,  w3,  w4,
    output wire [7:0] w5,  w6,  w7,  w8,  w9,
    output wire [7:0] w10, w11, w12, w13, w14,
    output wire [7:0] w15, w16, w17, w18, w19,
    output wire [7:0] w20, w21, w22, w23, w24
);

    reg [7:0] line [0:3][0:IMG_W-1];
    reg [7:0] p0,p1,p2,p3,p4;
    integer i,j;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            p0<=0; p1<=0; p2<=0; p3<=0; p4<=0;
            for (j=0;j<4;j=j+1)
                for (i=0;i<IMG_W;i=i+1)
                    line[j][i] <= 0;
        end else begin
            p4<=p3; p3<=p2; p2<=p1; p1<=p0; p0<=pixel_in;

            for (j=3;j>0;j=j-1)
                for (i=IMG_W-1;i>0;i=i-1)
                    line[j][i] <= line[j][i-1];

            for (i=IMG_W-1;i>0;i=i-1)
                line[0][i] <= line[0][i-1];

            line[3][0] <= line[2][0];
            line[2][0] <= line[1][0];
            line[1][0] <= line[0][0];
            line[0][0] <= pixel_in;
        end
    end

    assign w0=line[3][4];  assign w1=line[3][3];  assign w2=line[3][2];  assign w3=line[3][1];  assign w4=line[3][0];
    assign w5=line[2][4];  assign w6=line[2][3];  assign w7=line[2][2];  assign w8=line[2][1];  assign w9=line[2][0];
    assign w10=line[1][4]; assign w11=line[1][3]; assign w12=line[1][2]; assign w13=line[1][1]; assign w14=line[1][0];
    assign w15=line[0][4]; assign w16=line[0][3]; assign w17=line[0][2]; assign w18=line[0][1]; assign w19=line[0][0];
    assign w20=p4;         assign w21=p3;         assign w22=p2;         assign w23=p1;         assign w24=p0;

endmodule
