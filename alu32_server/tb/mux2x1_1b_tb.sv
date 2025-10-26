module mux2x1_1b_tb;
    // Inputs
    logic D0, D1, S;
    
    // Outputs
    logic Y;

    // Instantiate UUT
    mux2x1_1b uut (
        .D0(D0),
        .D1(D1),
        .S(S),
        .Y(Y)
    );
    
    int error;
    
    initial begin
        error = 0;
        S = '0; D0 = '0; D1 = '0; #2;
        
        for (int s = 0; s < 2; s++) begin
            for (int d0 = 0; d0 < 2; d0++) begin
                for (int d1 = 0; d1 < 2; d1++) begin
                    S = s; D0 = d0; D1 = d1; #2;
                end
            end
        end
        
        // REPORT
        if (error == 0)
            $display("PASS: mux2x1_1b TB finished with no errors.");
        else
            $display("FAIL: mux2x1_1b TB found %0d errors.", error);
				
        $finish;
    
    end
    
	always @(D0, D1, S) begin
		#1;
        
        if (Y !== (S ? D1 : D0)) begin
			$display("ERROR: mux2x1_1b:  S = %b, D0 = %b, D1 = %b, Y = %b, exp = %b", S, D0, D1, Y, (S ? D1 : D0));
			error = error + 1;
		end
	end
    
endmodule
