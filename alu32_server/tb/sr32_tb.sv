module sr32_tb;
    // Inputs
    logic [31:0] in;
    logic [4:0] shamt;
    logic arithmetic;
    
    // Outputs
    logic [31:0] out;
    
    // UUT
    sr32 uut(
        .in(in),
        .shamt(shamt),
        .arithmetic(arithmetic),
        .out(out)
    );
    
    int error;
    logic [31:0] logical_part, fill_mask, arith_part, exp;
    
    
    initial begin
        error = 0;
        in = '0; shamt = '0; arithmetic = '0; #2;
        
        // +/- LOGICAL
        
        in = 32'h1234_5678; arithmetic = '0;
        for (int i=0; i<32; i++) begin
            shamt = i; #2;
        end
        
        in = 32'hFEDC_BA98; arithmetic = '0;
        for (int i=0; i<32; i++) begin
            shamt = i; #2;
        end
        
        // +/- ARITHMETIC
        
        in = 32'h1234_5678; arithmetic = '1;
        for (int i=0; i<32; i++) begin
            shamt = i; #2;
        end
        
        in = 32'hFEDC_BA98; arithmetic = '1;
        for (int i=0; i<32; i++) begin
            shamt = i; #2;
        end
        
        // RANDOM
        for (int k = 0; k < 50; k++) begin
          in = $urandom; shamt = $urandom_range(31,0); arithmetic = $urandom_range(1,0); #2;
        end
    
        // REPORT
        if (error == 0)
            $display("PASS: SR32 TB finished with no errors.");
        else
            $display("FAIL: SR32 TB found %0d errors.", error);
                
        $finish;
    end
    
	always @(in, shamt, arithmetic) begin
		#1;
		// systemverilog isn't computing arithmetic shift for some reason
		logical_part = in >> shamt;
		fill_mask = (shamt == 0) ? 32'h0000_0000 : ~(32'hFFFF_FFFF >> shamt);
		arith_part = in[31] ? (logical_part | fill_mask) : logical_part;
		exp = arithmetic ? arith_part : logical_part;
        
        if (out !== (exp)) begin
				$display("ERROR: SR32:  in = %h, shamt = %h, arithmetic = %b, out = %h, exp = %h", in, shamt, arithmetic, out, exp);
				error = error + 1;
		end
		
	end

endmodule
