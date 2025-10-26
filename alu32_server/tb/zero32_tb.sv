module zero32_tb;
    // Inputs
    logic [31:0] z;
    
    // Outputs
    logic zero;
    
    // UUT
    zero32 uut (.z(z), .zero(zero));
    
    int error;
    
    initial begin
        error = 0;
        z = '0; #2;
        
        // All zeros / ones / edges / mixed
        z = 32'h0000_0000; #2; // expect 1
        z = 32'h0000_0001; #2; // expect 0
        z = 32'h8000_0000; #2; // expect 0
        z = 32'hFFFF_FFFF; #2; // expect 0
        z = 32'h0000_F000; #2; // expect 0
        z = 32'h0000_0000; #2; // expect 1 (return to zero)
    
        // Alternating / nibble masks
        z = 32'hAAAA_AAAA; #2; // 0
        z = 32'h5555_5555; #2; // 0
        z = 32'hF0F0_F0F0; #2; // 0
        z = 32'h0F0F_0F0F; #2; // 0
    
        // Walking 1's across the word
        for (int i = 0; i < 32; i++) begin
          z = 32'(1 << i); #2;  // expect 0
        end
    
        // Random
        for (int k = 0; k < 200; k++) begin
          z = $urandom; #2;     // usually 0, rarely 1 if z==0
        end
        
        // REPORT
        if (error == 0)
            $display("PASS: zero32 TB finished with no errors.");
        else
            $display("FAIL: zero32 TB found %0d errors.", error);
				
        $finish;
        
    end
    
    always @(z) begin
        #1;
        
        if (zero !== (z == 32'h0000_0000)) begin
			$display("ERROR: zero32:  z = %h, zero = %b", z, zero);
			error = error + 1;
		end
    end


endmodule
