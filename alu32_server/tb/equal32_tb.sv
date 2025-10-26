module equal32_tb;
	// Inputs
	logic signed [31:0] x;
	logic signed [31:0] y;

	// Outputs
	logic equal;

	// Instantiate the Unit Under Test (UUT)
	equal32 uut (
		.x(x), 
		.y(y), 
		.equal(equal)
	);

    int error;

    initial begin
        error = 0;
		x = '0; y = '0; #2;
		
        // EQUAL
        x = 32'h0000_0000; y = 32'h0000_0000; #2;
        x = 32'hFFFF_FFFF; y = 32'hFFFF_FFFF; #2;
        x = 32'hA5A5_A5A5; y = 32'hA5A5_A5A5; #2;
        x = 32'h8000_0000; y = 32'h8000_0000; #2;
    
        // NOT EQUAL
        x = 32'h0000_0000; y = 32'hFFFF_FFFF; #2;
        x = 32'h1234_5678; y = 32'h1234_5679; #2;
        x = 32'hAAAA_AAAA; y = 32'h5555_5555; #2;
        x = 32'h7FFF_FFFF; y = 32'h8000_0000; #2;
    
        // WALKING 1's: EQUAL
        for (int i = 0; i < 32; i++) begin
          x = 32'(1 << i); y = 32'(1 << i); #2; // equal
        end
    
        // WALKING 1's: 1-bit difference
        for (int i = 0; i < 32; i++) begin
          x = 32'(1 << i); y = 32'h0; #2; // differ by 1 bit
        end
    
        // RANDOM: half equal, half 1-bit different
        for (int k = 0; k < 100; k++) begin
          x = $urandom; y = x;                         #2; // equal
          x = $urandom; y = x ^ (32'(1 << (k % 32)));  #2; // differ by 1 bit
        end
		
        // REPORT
        if (error == 0)
            $display("PASS: equal32 TB finished with no errors.");
        else
            $display("FAIL: equal32 TB found %0d errors.", error);
				
        $finish;
	end
	
	always @(x, y) begin
		#1;
        
        if (equal !== (x === y)) begin
				$display("ERROR: AND32:  x = %h, y = %h, equal = %h, exp = %h", x, y, equal, (x===y));
				error = error + 1;
		end
		
	end
endmodule