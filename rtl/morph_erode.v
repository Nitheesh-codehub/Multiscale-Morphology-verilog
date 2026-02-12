module morph_erode_3x3(
    input  wire [7:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,
    output reg  [7:0] out
);
    always @(*) begin
        out=w0;
        if(w1<out)out=w1; if(w2<out)out=w2; if(w3<out)out=w3;
        if(w4<out)out=w4; if(w5<out)out=w5; if(w6<out)out=w6;
        if(w7<out)out=w7; if(w8<out)out=w8;
    end
endmodule
