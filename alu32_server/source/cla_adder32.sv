module cla_adder32
    (
        input logic [31:0] A, B,
        input logic sub,
        output logic C32, of,
        output logic [31:0] sum
    );
    logic C16;
    logic [31:0] notB, B_prime;
    logic same_input_sign, different_output_sign;
    
    // invert B if we are subtracting
    genvar i;
    generate
        for (i=0; i<32; i++) begin : invert_b
            not u1(notB[i], B[i]);
            mux2x1_1b u_inv_b (.D0(B[i]), .D1(notB[i]), .S(sub), .Y(B_prime[i]));
        end
    endgenerate   
    
    // lower 16 bits
    cla_adder16 lower (
        .A(A[15:0]),
        .B(B_prime[15:0]),
        .C0(sub),
        .C16(C16),
        .sum(sum[15:0])
    );
    
    // upper 16 bits
    cla_adder16 upper (
        .A(A[31:16]),
        .B(B_prime[31:16]),
        .C0(C16),
        .C16(C32),
        .sum(sum[31:16])
    );
    
    // calculate overflow
    xnor u2(same_input_sign, A[31], B_prime[31]);
    xor u3(different_output_sign, A[31], sum[31]);
    and u4(of, same_input_sign, different_output_sign);
    
endmodule
