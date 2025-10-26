module reverse32
    (
        input logic [31:0] in,
        output logic [31:0] out
    );
    
    // out[i] = in[31-i]  (pure wiring)
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_reverse
            assign out[i] = in[31 - i];
        end
    endgenerate
    
endmodule
