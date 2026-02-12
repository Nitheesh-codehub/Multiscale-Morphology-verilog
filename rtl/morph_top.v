module morph_top_multiscale #(
    parameter IMG_W = 256
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  pixel_in,
    output reg  [7:0]  pixel_out
);

    // ============================================================
    // 3×3 PATH
    // ============================================================
    wire [7:0] w0,w1,w2,w3,w4,w5,w6,w7,w8;
    wire [7:0] dilate_3, erode_3, edge_3;

    line_buffer_3x3 u_lb3 (
        .clk(clk), .rst(rst), .pixel_in(pixel_in),
        .w0(w0), .w1(w1), .w2(w2),
        .w3(w3), .w4(w4), .w5(w5),
        .w6(w6), .w7(w7), .w8(w8)
    );

    morph_dilate_3x3 u_d3 (
        w0,w1,w2,w3,w4,w5,w6,w7,w8,
        dilate_3
    );

    morph_erode_3x3 u_e3 (
        w0,w1,w2,w3,w4,w5,w6,w7,w8,
        erode_3
    );

    morph_edge_enhance u_edge3 (
        .pixel(pixel_in),
        .dilate(dilate_3),
        .erode(erode_3),
        .edge_out(edge_3)
    );

    // ============================================================
    // 5×5 PATH
    // ============================================================
    wire [7:0]
        w50,w51,w52,w53,w54,
        w55,w56,w57,w58,w59,
        w510,w511,w512,w513,w514,
        w515,w516,w517,w518,w519,
        w520,w521,w522,w523,w524;

    wire [7:0] dilate_5, erode_5, edge_5;

    line_buffer_5x5 u_lb5 (
        .clk(clk), .rst(rst), .pixel_in(pixel_in),
        .w0(w50),  .w1(w51),  .w2(w52),  .w3(w53),  .w4(w54),
        .w5(w55),  .w6(w56),  .w7(w57),  .w8(w58),  .w9(w59),
        .w10(w510),.w11(w511),.w12(w512),.w13(w513),.w14(w514),
        .w15(w515),.w16(w516),.w17(w517),.w18(w518),.w19(w519),
        .w20(w520),.w21(w521),.w22(w522),.w23(w523),.w24(w524)
    );

    morph_dilate_5x5 u_d5 (
        w50,w51,w52,w53,w54,
        w55,w56,w57,w58,w59,
        w510,w511,w512,w513,w514,
        w515,w516,w517,w518,w519,
        w520,w521,w522,w523,w524,
        dilate_5
    );

    morph_erode_5x5 u_e5 (
        w50,w51,w52,w53,w54,
        w55,w56,w57,w58,w59,
        w510,w511,w512,w513,w514,
        w515,w516,w517,w518,w519,
        w520,w521,w522,w523,w524,
        erode_5
    );

    morph_edge_enhance u_edge5 (
        .pixel(pixel_in),
        .dilate(dilate_5),
        .erode(erode_5),
        .edge_out(edge_5)
    );

    // ============================================================
    // MULTI-SCALE FUSION (NO THRESHOLD)
    // ============================================================
    wire [8:0] fuse_sum;
    wire [7:0] edge_fused;

    assign fuse_sum   = edge_3 + edge_5;
    assign edge_fused = fuse_sum >> 1;   // average

    // ============================================================
    // PIPELINE VALID MASK (CRITICAL)
    // ============================================================
    reg [31:0] pix_cnt;
    wire       valid_pipe;

    assign valid_pipe = (pix_cnt > (IMG_W * 5)); // 5×5 warm-up

    initial begin
        pixel_out = 8'd0;
        pix_cnt   = 32'd0;
    end

    always @(posedge clk) begin
        if (rst) begin
            pixel_out <= 8'd0;
            pix_cnt   <= 32'd0;
        end else begin
            pix_cnt <= pix_cnt + 1;

            if (valid_pipe)
                pixel_out <= edge_fused;
            else
                pixel_out <= 8'd0;   // mask Xs
        end
    end

endmodule
