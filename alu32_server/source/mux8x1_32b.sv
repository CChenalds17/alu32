module mux8x1_32b
    (
        input logic [31:0] D0, D1, D2, D3, D4, D5, D6, D7,
        input logic [2:0] S,
        output logic [31:0] Y
    );
    
    logic [31:0] y01, y23, y45, y67;
    logic [31:0] y0123, y4567;
    
    // Stage 0
    mux2x1_32b u0(.D0(D0), .D1(D1), .S(S[0]), .Y(y01));
    mux2x1_32b u1(.D0(D2), .D1(D3), .S(S[0]), .Y(y23));
    mux2x1_32b u2(.D0(D4), .D1(D5), .S(S[0]), .Y(y45));
    mux2x1_32b u3(.D0(D6), .D1(D7), .S(S[0]), .Y(y67));
    
    // Stage 1
    mux2x1_32b u4(.D0(y01), .D1(y23), .S(S[1]), .Y(y0123));
    mux2x1_32b u5(.D0(y45), .D1(y67), .S(S[1]), .Y(y4567));
    
    // Stage 2
    mux2x1_32b u6(.D0(y0123), .D1(y4567), .S(S[2]), .Y(Y));

endmodule
