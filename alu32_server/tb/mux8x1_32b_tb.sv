module mux8x1_32b_tb;
    // Inputs
    logic [31:0] D0, D1, D2, D3, D4, D5, D6, D7;
    logic [2:0] S;
    
    // Outputs
    logic [31:0] Y;
    
    // Instantiate UUT
    mux8x1_32b uut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .D4(D4),
        .D5(D5),
        .D6(D6),
        .D7(D7),
        .S(S),
        .Y(Y)
    );
    
    int error;
    logic [31:0] exp; // expected value
    logic [31:0] w; // temp variable for testbench values
    
    initial begin
        error = 0;
        S = '0; D0 = '0; D1 = '0; D2 = '0; D3 = '0; D4 = '0; D5 = '0; D6 = '0; D7 = '0; #2;
        
        // Distinct, easy-to-spot patterns
        D0=32'h0000_0000; D1=32'h1111_1111; D2=32'h2222_2222; D3=32'h3333_3333;
        D4=32'h4444_4444; D5=32'h5555_5555; D6=32'h6666_6666; D7=32'h7777_7777;
        // Sweep S across all choices
        for (int s = 0; s < 8; s++) begin
          S = s[2:0]; #2;
        end
        
        // Alternate patterns + second sweep
        D0=32'hAAAA_AAAA; D1=32'h5555_5555; D2=32'hF0F0_F0F0; D3=32'h0F0F_0F0F;
        D4=32'hFFFF_0000; D5=32'h0000_FFFF; D6=32'h8000_0001; D7=32'h7FFF_FFFE;
        for (int s = 0; s < 8; s++) begin
          S = s[2:0]; #2;
        end
        
        // Walking-1 on each bit?select different inputs while it walks
        for (int i = 0; i < 32; i++) begin
          w = 32'(1 << i);
          D0=w; D1=~w; D2=w; D3=~w; D4=w; D5=~w; D6=w; D7=~w;
          S = i % 8; #2;
        end
        
        // Random
        for (int k = 0; k < 200; k++) begin
            D0=$urandom; D1=$urandom; D2=$urandom; D3=$urandom;
            D4=$urandom; D5=$urandom; D6=$urandom; D7=$urandom;
            S = $urandom_range(7,0); #2;
        end
        
        // REPORT
        if (error == 0)
            $display("PASS: mux8x1_32b TB finished with no errors.");
        else
            $display("FAIL: mux8x1_32b TB found %0d errors.", error);
				
        $finish;
    
    end
    
	always @(D0, D1, D2, D3, D4, D5, D6, D7, S) begin
		#1;
				
		unique case (S)
            3'b000: exp = D0;
            3'b001: exp = D1;
            3'b010: exp = D2;
            3'b011: exp = D3;
            3'b100: exp = D4;
            3'b101: exp = D5;
            3'b110: exp = D6;
            3'b111: exp = D7;
        endcase
        
        if (Y !== exp) begin
			$display("ERROR: mux8x1_32b:  S = %b, Y = %h, exp = %h", S, Y, exp);
			error = error + 1;
		end
	end
    

endmodule
