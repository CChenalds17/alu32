module full_adder_tb;
    // Inputs
    logic a, b, cin;
    
    // Outputs
    logic s, cout;
    
    // UUT
    full_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );
    
    int error;
    logic [1:0] exp;
    
    initial begin
        error = 0;
        a = '0; b = '0; cin = '0; #2;
        
        // loop through all combinations
        for (int A=0; A<2; A++) begin
            for (int B=0; B<2; B++) begin
                for (int Cin=0; Cin<2; Cin++) begin
                    a=A; b=B; cin=Cin; #2;
                end
            end
        end
        
        // REPORT
        if (error == 0)
            $display("PASS: full_adder TB finished with no errors.");
        else
            $display("FAIL: full_adder TB found %0d errors.", error);
				
        $finish;
    
    end
    
    always @(a, b, cin) begin
		#1;
		exp = {1'b0,a} + {1'b0,b} + {1'b0,cin}; // widen before add
        
        if ((s !== exp[0]) || (cout !== exp[1]) ) begin
			$display("ERROR: full_adder:  a = %b, b = %b, cin = %b, s = %b, cout = %b", a, b, cin, s, cout);
			error = error + 1;
		end
	end

endmodule
