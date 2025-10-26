module mux2x1_32b_tb;
    // Inputs
    logic [31:0] D0, D1;
    logic S;
    
    // Outputs
    logic [31:0] Y;

    // Instantiate UUT
    mux2x1_32b uut (
        .D0(D0),
        .D1(D1),
        .S(S),
        .Y(Y)
    );
    
    int error;
    
    initial begin
        error = 0;
        S = '0; D0 = '0; D1 = '0; #2;
        
        // ALL 0's / 1's
        S = 0; D0 = 32'h0000_0000; D1 = 32'hFFFF_FFFF; #2;
        S = 1; D0 = 32'h0000_0000; D1 = 32'hFFFF_FFFF; #2;
        
        // ALTERNATING
        S = 0; D0 = 32'hAAAA_AAAA; D1 = 32'h5555_5555; #2;
        S = 1; D0 = 32'hAAAA_AAAA; D1 = 32'h5555_5555; #2;
        S = 0; D0 = 32'hF0F0_F0F0; D1 = 32'h0F0F_0F0F; #2;
        
        // EDGE
        S = 0; D0 = 32'h8000_0001; D1 = 32'h7FFF_FFFE; #2;
        S = 1; D0 = 32'h7FFF_FFFE; D1 = 32'h8000_0001; #2;
        
        // WALKING 1's / 0's
        for (int i = 0; i < 32; i++) begin
          S = 0; D0 = 32'(1 << i);      D1 = ~32'(1 << i); #2; // select D0
          S = 1; D0 = ~32'(1 << i);     D1 = 32'(1 << i);  #2; // select D1
        end
        
        // RANDOM
        for (int k = 0; k < 200; k++) begin
          S  = $urandom_range(1,0);
          D0 = $urandom;
          D1 = $urandom;
          #2;
        end
        
        // REPORT
        if (error == 0)
            $display("PASS: mux2x1_32b TB finished with no errors.");
        else
            $display("FAIL: mux2x1_32b TB found %0d errors.", error);
				
        $finish;
    
    end
    
	always @(D0, D1, S) begin
		#1;
        
        if (Y !== (S ? D1 : D0)) begin
			$display("ERROR: mux2x1_32b:  S = %b, D0 = %h, D1 = %h, Y = %h, exp = %h", S, D0, D1, Y, (S ? D1 : D0));
			error = error + 1;
		end
	end
    
endmodule
