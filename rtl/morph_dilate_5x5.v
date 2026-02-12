module morph_dilate_5x5(
    input wire [7:0] w0, w1, w2, w3, w4,
    input wire [7:0] w5, w6, w7, w8, w9,
    input wire [7:0] w10,w11,w12,w13,w14,
    input wire [7:0] w15,w16,w17,w18,w19,
    input wire [7:0] w20,w21,w22,w23,w24,
    output reg [7:0] out
);
    always @(*) begin
        out = w0;
        if(w1>out)out=w1; if(w2>out)out=w2; if(w3>out)out=w3; if(w4>out)out=w4;
        if(w5>out)out=w5; if(w6>out)out=w6; if(w7>out)out=w7; if(w8>out)out=w8; if(w9>out)out=w9;
        if(w10>out)out=w10; if(w11>out)out=w11; if(w12>out)out=w12; if(w13>out)out=w13; if(w14>out)out=w14;
        if(w15>out)out=w15; if(w16>out)out=w16; if(w17>out)out=w17; if(w18>out)out=w18; if(w19>out)out=w19;
        if(w20>out)out=w20; if(w21>out)out=w21; if(w22>out)out=w22; if(w23>out)out=w23; if(w24>out)out=w24;
    end
endmodule
