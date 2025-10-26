module rca_32
    (
        input logic [31:0] a, b, // 32-bit inputs a, b
        input logic sub, // subtract input bit
        output logic [31:0] s, // 32-bit output sum
        output logic c32, of // msb carry-out, overflow bit
    );
    
    logic [32:0] carry; // internal carry chain
    assign carry[0] = sub;
    logic [31:0] not_b; // internally store ~b
    logic [31:0] b_prime; // either b or ~b (if we add/subtract)
    
    genvar i;
        
    generate
        for (i=0; i<32; i++) begin: gen_fa_stage
            not u1 (not_b[i], b[i]);
            mux2x1_1b u_inv_b (.D0(b[i]), .D1(not_b[i]), .S(sub), .Y(b_prime[i]));
            full_adder fa (
                .a(a[i]),
                .b(b_prime[i]),
                .cin(carry[i]),
                .s(s[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate
    
    // calculate overflow
    xor u_of (of, carry[32], carry[31]);
    assign c32 = carry[32];
    
endmodule
