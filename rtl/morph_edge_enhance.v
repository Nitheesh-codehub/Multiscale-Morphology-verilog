module morph_edge_enhance(
    input  wire [7:0] pixel,
    input  wire [7:0] dilate,
    input  wire [7:0] erode,
    output wire [7:0] edge_out
);
    wire [7:0] yd, ye, emax, emin, diff;
    wire [8:0] sum;

    assign yd = (dilate > pixel) ? (dilate - pixel) : 8'd0;
    assign ye = (pixel > erode)  ? (pixel - erode)  : 8'd0;

    assign emax = (yd > ye) ? yd : ye;
    assign emin = (yd < ye) ? yd : ye;
    assign diff = emax - emin;

    // Reduced enhancement to avoid saturation
    assign sum = yd + ye + (diff >> 1);

    assign edge_out = (sum > 255) ? 8'hFF : sum[7:0];
endmodule
