module rca_32_tb;
    // Inputs
    logic [31:0] a, b;
    logic sub;
    
    // Outputs
    logic [31:0] s;
    logic c32, of;
    
    // UUT
    rca_32 uut(
        .a(a),
        .b(b),
        .sub(sub),
        .s(s),
        .c32(c32),
        .of(of)
    );
    
    int error;
    logic [31:0] exp_bprime;
    logic [32:0] exp_sum33;
    logic [31:0] exp_s;
    logic exp_c32, exp_of;
    
    initial begin
        error = 0;
        a='0; b='0; sub='0; #2;
        
        // BASIC ADD
        sub=0; a=32'h0000_0001; b=32'h0000_0001; #2; // 1 + 1
        sub=0; a=32'h0000_0000; b=32'hFFFF_FFFF; #2; // 0 + (-1)
        
        // OVERFLOW ADD
        sub=0; a=32'h7FFF_FFFF; b=32'h0000_0001; #2; // +max + 1  -> of=1
        sub=0; a=32'h8000_0000; b=32'h8000_0000; #2; // -min + -min -> of=1
        
        // BASIC SUB
        sub=1; a=32'h0000_0003; b=32'h0000_0001; #2; // 3 - 1
        sub=1; a=32'h0000_0000; b=32'h0000_0001; #2; // 0 - 1 (borrow case)
        sub=1; a=32'hFFFF_FFFF; b=32'hFFFF_FFFF; #2; // -1 - (-1) = 0
        
        // OVERFLOW SUB
        sub=1; a=32'h7FFF_FFFF; b=32'hFFFF_FFFF; #2; // +max - (-1) -> of=1
        sub=1; a=32'h8000_0000; b=32'h0000_0001; #2; // -min - 1   -> of=1
        
        // MIXED
        sub=0; a=32'hAAAA_AAAA; b=32'h5555_5555; #2; // add alternating
        sub=1; a=32'hAAAA_AAAA; b=32'h5555_5555; #2; // sub alternating
        sub=0; a=32'hF0F0_F0F0; b=32'h0F0F_0F0F; #2; // add nibbles
        sub=1; a=32'h8000_0001; b=32'h7FFF_FFFE; #2; // sub edges
        
        // RANDOM
        for (int k=0; k<200; k++) begin
            sub = $urandom_range(1,0);
            a = $urandom;
            b = $urandom;
            #2;
        end
        
        // REPORT
        if (error == 0)
            $display("PASS: rca TB finished with no errors.");
        else
            $display("FAIL: rca TB found %0d errors.", error);
				
        $finish;
    
    end

    always @(a, b, sub) begin
		#1;
		
		exp_bprime = (sub) ? ~b : b;
		exp_sum33 = {1'b0, a} + {1'b0, exp_bprime} + sub;
		exp_s = exp_sum33[31:0];
		exp_c32 = exp_sum33[32];
		// signed overflow: inputs are same sign, results different sign
		exp_of = ((a[31] == exp_bprime[31]) && ((exp_s[31]) != a[31]));
        
        if (s !== exp_s || c32 !== exp_c32 || of !== exp_of) begin
			$display("ERROR: rca: sub = %b,  a = %h, b = %h, s = %h, c32 = %b, of = %b | Expected: s = %h, c32 = %b, of = %b", sub, a, b, s, c32, of, exp_s, exp_c32, exp_of);
			error = error + 1;
		end
	end

endmodule
