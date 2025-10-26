module cla_adder16
    (
        input logic [15:0] A, B,
        input logic C0,
        output logic C16,
        output logic [15:0] sum
    );
    logic [3:0] G4, P4;
    logic C4, C8, C12;
    
    // Slice 0 -- [3:0]
    cla_adder4 u0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .C0(C0),
        .sum(sum[3:0]),
        .G_G(G4[0]),
        .P_G(P4[0])
    );
    // Slice 1 -- [7:4]
    cla_adder4 u1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .C0(C4),
        .sum(sum[7:4]),
        .G_G(G4[1]),
        .P_G(P4[1])
    );
    // Slice 2 -- [11:8]
    cla_adder4 u2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .C0(C8),
        .sum(sum[11:8]),
        .G_G(G4[2]),
        .P_G(P4[2])
    );
    // Slice 3 -- [15:12]
    cla_adder4 u3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .C0(C12),
        .sum(sum[15:12]),
        .G_G(G4[3]),
        .P_G(P4[3])
    );
    
    // Hierarchical Unit
    cla_unit4 bottom(
        .G(G4),
        .P(P4),
        .C0(C0),
        .C1(C4),
        .C2(C8),
        .C3(C12),
        .C4(C16)
    );
    
endmodule
