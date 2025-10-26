module and32_tb;
	// Inputs
	logic signed [31:0] x;
	logic signed [31:0] y;

	// Outputs
	logic signed [31:0] z;

	// Instantiate the Unit Under Test (UUT)
	and32 uut (
		.x(x), 
		.y(y), 
		.z(z)
	);

    int error;

    initial begin
        error = 0;
		x = '0; y = '0; #2;
		
		// CORNER CASES
		x = 32'h0000_0000; y = 32'h0000_0000; #2;
		x = 32'hFFFF_FFFF; y = 32'hFFFF_FFFF; #2;
        x = 32'hFFFF_FFFF; y = 32'h0000_0000; #2;
        x = 32'h0000_0000; y = 32'hFFFF_FFFF; #2;
        
        // ALTERNATING PATTERNS
        x = 32'hAAAA_AAAA; y = 32'h5555_5555; #2; // cancel to 0s
        x = 32'hF0F0_F0F0; y = 32'h0F0F_0F0F; #2; // cancel to 0s
        x = 32'h1234_5678; y = 32'hFFFF_0000; #2; // 1234 (1st 4 bytes)
        x = 32'h8000_0001; y = 32'h7FFF_FFFF; #2; // cancels to 1

        // WALKING 1s ON x AND y
        for (int i = 0; i < 32; i++) begin
            x = 32'(1 << i); y = 32'hFFFF_FFFF; #2;
        end
        for (int i = 0; i < 32; i++) begin
            x = 32'hFFFF_FFFF; y = 32'(1 << i); #2;
        end
        
        // RANDOM NUMBERS
        for (int k = 0; k < 500; k++) begin
            x = $urandom; y = $urandom; #2;
        end
		
        // REPORT
        if (error == 0)
            $display("PASS: and32 TB finished with no errors.");
        else
            $display("FAIL: and32 TB found %0d errors.", error);
				
        $finish;
	end
	

	// an 'always' block is executed whenever any of the variables in the sensitivity
	// list are changed (x or y in this case)
    //** Use this block to check the outputs of your operations against the corresponding SystemVerilog constructs. **//
	always @(x, y) begin
		#1;
        
        if (z !== (x & y)) begin
			$display("ERROR: AND32:  x = %h, y = %h, z = %h, exp = %h", x, y, z, (x&y));
			error = error + 1;
		end
		
	end
endmodule