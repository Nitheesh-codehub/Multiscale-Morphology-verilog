`timescale 1ns/1ps

module tb_morph_multiscale;

    // ------------------------------------
    // Image parameters
    // ------------------------------------
    parameter IMG_W   = 256;
    parameter IMG_H   = 256;
    parameter PIXELS  = IMG_W * IMG_H;

    // ------------------------------------
    // Signals
    // ------------------------------------
    reg         clk;
    reg         rst;
    reg  [7:0]  pixel_in;
    wire [7:0]  pixel_out;

    reg  [7:0]  img [0:PIXELS-1];

    integer i;
    integer fout;

    // ------------------------------------
    // DUT
    // ------------------------------------
    morph_top_multiscale #(
        .IMG_W(IMG_W)
    ) dut (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .pixel_out(pixel_out)
    );

    // ------------------------------------
    // Clock: 100 MHz
    // ------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // ------------------------------------
    // Test sequence
    // ------------------------------------
    initial begin
        // ------------------------------
        // Initial conditions
        // ------------------------------
        rst      = 1'b1;
        pixel_in = 8'd0;

        // Load input image (256x256 = 65536 pixels)
        $readmemh("input1.hex", img);

        // Open output file
        fout = $fopen("output.hex", "w");
        if (fout == 0) begin
            $display("ERROR: Cannot open output file");
            $stop;
        end

        // ------------------------------
        // Hold reset
        // ------------------------------
        #100;
        rst = 1'b0;

        // ------------------------------
        // Feed EXACTLY 65536 pixels
        // ------------------------------
        for (i = 0; i < PIXELS; i = i + 1) begin
            pixel_in = img[i];
            #10;   // one pixel per clock

            // ALWAYS write output
            // Warm-up cycles already output 0 from RTL
            $fwrite(fout, "%h\n", pixel_out);
        end

        // ------------------------------
        // Finish
        // ------------------------------
        $fclose(fout);
        $display("DONE: edge_out_multiscale.hex has %0d pixels", PIXELS);
        $stop;
    end

endmodule
