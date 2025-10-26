module equal32
    (
        input logic [31:0] x, [31:0] y,
        output logic equal
    );
    logic [31:0] l0; // XNOR layer
    logic [15:0] l1; // AND layers
    logic [7:0] l2;
    logic [3:0] l3;
    logic [1:0] l4;
    
    genvar i;
    
    // XNOR layer
    generate
        for (i=0; i<32; i=i+1) begin: xnor_layer0
            xnor gen_l0(l0[i], x[i], y[i]);
        end
    endgenerate
    
    // AND layer 1: 32 --> 16
    generate
        for (i=0; i<16; i=i+1) begin: and_layer1
            and gen_l1(l1[i], l0[2*i], l0[2*i+1]);
        end
    endgenerate
    
    // AND layer 2: 16 --> 8
    generate
        for(i=0; i<8; i=i+1) begin: and_layer2
            and gen_l2(l2[i], l1[2*i], l1[2*i+1]);
        end
    endgenerate
    
    // AND layer 3: 8 --> 4
    generate
        for(i=0; i<4; i=i+1) begin: and_layer3
            and gen_l3(l3[i], l2[2*i], l2[2*i+1]);
        end
    endgenerate
    
    // AND layer 4: 4 --> 2
    generate
        for(i=0; i<2; i=i+1) begin: and_layer4
            and gen_l4(l4[i], l3[2*i], l3[2*i+1]);
        end
    endgenerate
    
    // AND layer 5: 2 --> 1
    and and_l5(equal, l4[0], l4[1]);

endmodule
