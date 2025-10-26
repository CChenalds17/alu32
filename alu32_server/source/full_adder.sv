module full_adder
    (
        input logic a, b, // 1-bit inputs
        input logic cin, // 1-bit input carry-in
        output logic s, cout // 1-bit outputs sum, carry-out
    );
    
    logic xor_ab, and_ab, and_cin_xor_ab;
    
    xor u1 (xor_ab, a, b);
    xor u2 (s, cin, xor_ab);
    and u3 (and_ab, a, b);
    and u4 (and_cin_xor_ab, cin, xor_ab);
    or u5 (cout, and_ab, and_cin_xor_ab);
    
endmodule
