module cla_adder4
    (
        input logic [3:0] A, B,
        input logic C0,
        output logic [3:0] sum,
        output logic G_G, P_G
    );
    
    // local generates & propagates, and group generate & propagate
    logic [3:0] G, P;
    logic prop_in_1, prop_in_2, prop_in_3, prop_in_4;
    logic prop_0_2, prop_0_3, prop_0_4;
    logic prop_1_3, prop_1_4;
    logic prop_2_4;
    logic C1, C2, C3, C4;
    
    // G_i, P_i
    genvar i;
    generate
        for (i=0; i<4; i++) begin : gen_G_P
            and u_g (G[i], A[i], B[i]);
            xor u_p (P[i], A[i], B[i]);
        end
    endgenerate
    
    // minterms
    and u1(prop_in_1, C0, P[0]); // C0 & P0
    and u2(prop_in_2, C0, P[0], P[1]); // C0 & P0 & P1
    and u3(prop_0_2, G[0], P[1]); // G0 & P1
    and u4(prop_in_3, C0, P[0], P[1], P[2]); // C0 & P0 & P1 & P2
    and u5(prop_0_3, G[0], P[1], P[2]); // G0 & P1 & P2
    and u6(prop_1_3, G[1], P[2]); // G1 & P2
    and u7(prop_0_4, G[0], P[1], P[2], P[3]); // G0 & P1 & P2 & P3
    and u8(prop_1_4, G[1], P[2], P[3]); // G1 & P2 & P3
    and u9(prop_2_4, G[2], P[3]); // G2 & P3
    
    // group generate & propagate
    and u10(P_G, P[0], P[1], P[2], P[3]); // P_G
    or u11(G_G, prop_0_4, prop_1_4, prop_2_4, G[3]); // G_G
    and u12(prop_in_4, C0, P_G); // P_G & C0
    
    // carries
    or u13(C1, prop_in_1, G[0]); // C1
    or u14(C2, prop_in_2, prop_0_2, G[1]); // C2
    or u15(C3, prop_in_3, prop_0_3, prop_1_3, G[2]); // C3
    or u16(C4, prop_in_4, G_G); // C4
    
    // sums
    xor u17(sum[0], P[0], C0);
    xor u18(sum[1], P[1], C1);
    xor u19(sum[2], P[2], C2);
    xor u20(sum[3], P[3], C3);
    
endmodule
