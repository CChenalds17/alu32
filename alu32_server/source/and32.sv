module and32
    (
        input logic [31:0] x, [31:0] y,
        output logic [31:0] z
    );

    // generate AND gate for each of the 32 x[i], y[i]
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin: and_layer
            and gen_a(z[i], x[i], y[i]);
        end
    endgenerate

endmodule
