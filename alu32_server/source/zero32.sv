module zero32
    (
        input logic [31:0] z,
        output logic zero
    );
    logic [15:0] l0;
    logic [7:0] l1;
    logic [3:0] l2;
    logic [1:0] l3;
    

    genvar i;
    
    // 0th OR layer
    generate
        for (i=0; i<16; i++) begin: or_layer0
            or gen_l0(l0[i], z[2*i], z[2*i+1]);
        end
    endgenerate
    
    // 1st OR layer
    generate
        for (i=0; i<8; i++) begin: or_layer1
            or gen_l1(l1[i], l0[2*i], l0[2*i+1]);
        end
    endgenerate

    // 2nd OR layer
    generate
        for (i=0; i<4; i++) begin: or_layer2
            or gen_l2(l2[i], l1[2*i], l1[2*i+1]);
        end
    endgenerate

    // 3rd OR layer
    generate
        for (i=0; i<2; i++) begin: or_layer3
            or gen_l3(l3[i], l2[2*i], l2[2*i+1]);
        end
    endgenerate
    
    // Final NOR
    nor l4(zero, l3[0], l3[1]);

endmodule
