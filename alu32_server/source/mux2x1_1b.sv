module mux2x1_1b
    (
        input logic D0, D1, S,
        output logic Y
    );
    // Internal nets
    logic S_n; // S_n = ~S
    logic a0; // ~S & D0
    logic a1; // S & D1
    
    not u_inv(S_n, S); // S = ~S
    and u_and0(a0, S_n, D0); // a0 = ~S & D0
    and u_and1(a1, S, D1); // a1 = S & D1
    or u_or(Y, a0, a1); // Y = a0 | a1
    
endmodule
