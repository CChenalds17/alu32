module mux2x1_32b
    (
        input logic [31:0] D0, [31:0] D1,
        input logic S,
        output logic [31:0] Y
    );
    
    genvar i;
    // 2:1 mux layers
    generate
        for (i=0; i<32; i++) begin: mux2x1_1b_layer
            mux2x1_1b gen_mux (
                .D0(D0[i]),
                .D1(D1[i]),
                .S(S),
                .Y(Y[i])
            );
        end
    endgenerate
    
endmodule
