module cla_unit4
    (
        input logic [3:0] G, P,
        input logic C0,
        output logic C1, C2, C3, C4
    );
    
    // local generates & propagates, and group generate & propagate
    logic prop_in_1, prop_in_2, prop_in_3, prop_in_4;
    logic prop_0_2, prop_0_3, prop_0_4;
    logic prop_1_3, prop_1_4;
    logic prop_2_4;
    logic G_G, P_G;
    
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
    
endmodule
