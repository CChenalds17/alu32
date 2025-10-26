`include "alu.svh"

module alu_tb;
	// Inputs
	logic signed [31:0] x;
	logic signed [31:0] y;
	logic [2:0] op;

	// Outputs
	logic signed [31:0] z;
	logic equal;
	logic overflow;
	logic zero;

	// Instantiate the Unit Under Test (UUT)
	STUDENT_alu uut (
		.x, 
		.y, 
		.z, 
		.op, 
		.equal, 
		.overflow, 
		.zero
	);

    int error;
    logic [31:0] exp_z;
    logic exp_zero, exp_equal, exp_overflow;
    logic not_reserved, add_over, sub_over;
    logic [31:0] rnd;


    initial begin
        error = 0;
		
		// AND
		op = `ALU_AND; x = 32'hAAAA_AAAA; y = 32'h5555_5555; #2; // alternating bits
		op = `ALU_AND; x = 32'hFFFF_FFFF; y = 32'h0F0F_0F0F; #2; // alternating nibbles
		op = `ALU_AND; x = 32'h1234_5678; y = 32'hFFFF_FFFF; #2; // passthrough
		op = `ALU_AND; x = 32'hF987_6543; y = 32'h0000_0000; #2; // none pass through
		op = `ALU_AND; x = 32'h1357_9BDF; y = x; #2; // same number
		// random cases
		for (int k=0; k<100; k++) begin
		  op = `ALU_AND; x = $urandom; y = $urandom; #2;
		end
		
		// ADD
		op = `ALU_ADD; x = 32'h0000_0001; y = 32'h0000_0001; #2; // pos + pos, no overflow
		op = `ALU_ADD; x = 32'h0000_0001; y = 32'h1111_1111; #2; // pos + neg, no overflow
		op = `ALU_ADD; x = 32'hFFFF_FFFF; y = 32'hFFFF_FFFF; #2; // neg + neg, no overflow
		op = `ALU_ADD; x = 32'h7FFF_FFFF; y = 32'h0000_0001; #2; // +max + 1, positive overflow
		op = `ALU_ADD; x = 32'h8000_0000; y = 32'h8000_0000; #2; // -min + -min, negative overflow
		// random cases
		for (int k=0; k<100; k++) begin
		  op = `ALU_ADD; x = $urandom; y = $urandom; #2;
		end
		
		// SUB
		op = `ALU_SUB; x = 32'h0000_0005; y = 32'h0000_0001; #2; // no overflow
		op = `ALU_SUB; x = 32'h0000_0000; y = 32'h0000_0001; #2; // borrow case, no overflow
		op = `ALU_SUB; x = 32'h8000_0000; y = 32'h0000_0001; #2; // -min - 1, negative overflow
		op = `ALU_SUB; x = 32'h7FFF_FFFF; y = 32'hFFFF_FFFF; #2; // +max - -1, positive overflow
		// random cases
		for (int k=0; k<100; k++) begin
		  op = `ALU_SUB; x = $urandom; y = $urandom; #2;
		end
		
		// SLT
		op = `ALU_SLT; x = 32'hFFFF_FFFF; y = 32'h0000_0000; #2; // x < y, no overflow
		op = `ALU_SLT; x = 32'h0000_0001; y = 32'hFFFF_FFFF; #2; // x > y, no overflow
		op = `ALU_SLT; x = 32'h1234_5678; y = x; #2; // x == y, no overflow
		op = `ALU_SLT; x = 32'h8000_0000; y = 32'h0000_000F; #2; // x < y, overflow
		op = `ALU_SLT; x = 32'h7FFF_FFFF; y = 32'hFFFF_FFFF; #2; // x > y, overflow
		// random cases
		for (int k=0; k<100; k++) begin
		  op = `ALU_SLT; x = $urandom; y = $urandom; #2;
		end
		
		// SRL
		op = `ALU_SRL; x = 32'h1357_9BDF; // positive
		for (int k=0; k<32; k++) begin
		  rnd = $urandom;
		  y = {rnd[31:5], k[4:0]}; #2;
		end
		op = `ALU_SRL; x = 32'h8AC3_FB75; // negative
		for (int k=0; k<32; k++) begin
		  rnd = $urandom;
		  y = {rnd[31:5], k[4:0]}; #2;
		end
		// random cases
		for (int k=0; k<100; k++) begin
		  op = `ALU_SRL; x = $urandom; y = $urandom; #2;
		end
		
		// SRA
		op = `ALU_SRA; x = 32'h1357_9BDF; // positive
		for (int k=0; k<32; k++) begin
		  rnd = $urandom;
		  y = {rnd[31:5], k[4:0]}; #2;
		end
		op = `ALU_SRA; x = 32'h8AC3_FB75; // negative
		for (int k=0; k<32; k++) begin
		  rnd = $urandom;
		  y = {rnd[31:5], k[4:0]}; #2;
		end
		// random cases
		for (int k=0; k<100; k++) begin
		  op = `ALU_SRA; x = $urandom; y = $urandom; #2;
		end
		
		// SLL
		op = `ALU_SLL; x = 32'h1357_9BDF; // positive
		for (int k=0; k<32; k++) begin
		  rnd = $urandom;
		  y = {rnd[31:5], k[4:0]}; #2;
		end
		op = `ALU_SLL; x = 32'h8AC3_FB75; // negative
		for (int k=0; k<32; k++) begin
		  rnd = $urandom;
		  y = {rnd[31:5], k[4:0]}; #2;
		end
		// random cases
		for (int k=0; k<100; k++) begin
		  op = `ALU_SLL; x = $urandom; y = $urandom; #2;
		end
		
		// RESERVED
        // random cases
		for (int k=0; k<100; k++) begin
		  op = 3'b111; x = $urandom; y = $urandom; #2;
		end		
		
        // REPORT
        if (error == 0)
            $display("PASS: STUDENT_alu TB finished with no errors.");
        else
            $display("FAIL: STUDENT_alu TB found %0d errors.", error);
				
        $finish;
	end
	

	always @(x, y, op) begin
		#1;
		case (op)
			`ALU_AND: begin
				if (z !== (x & y)) begin
					$display("ERROR: AND:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			`ALU_ADD: begin
			     if (z !== (x + y)) begin
					$display("ERROR: ADD:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
            end
			`ALU_SUB: begin
			     if (z !== (x - y)) begin
					$display("ERROR: SUB:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			`ALU_SLT: begin
			     if (z !== (x < y)) begin
					$display("ERROR: SLT:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			`ALU_SRL: begin
			     if (z !== (x >> y[4:0])) begin
					$display("ERROR: SRL:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			`ALU_SLL: begin
			     if (z !== (x << y[4:0])) begin
					$display("ERROR: SLL:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			`ALU_SRA: begin
			     if (z !== (x >>> y[4:0])) begin
					$display("ERROR: SRA:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
			default : begin
                 if (z !== (32'd0)) begin
					$display("ERROR: RESERVED:  op = %b, x = %h, y = %h, z = %h", op, x, y, z);
					error = error + 1;
				end
			end
		endcase
		
		// Flag checks
		not_reserved = ~(op[2] & op[1] & op[0]);
		
		// Expected z
		case (op)
		  `ALU_AND: exp_z = (x & y);
		  `ALU_ADD: exp_z = (x + y);
		  `ALU_SUB: exp_z = (x - y);
		  `ALU_SLT: exp_z = (x < y) ? 32'd1 : 32'd0;
		  `ALU_SRL: exp_z = (x >> y[4:0]);
		  `ALU_SLL: exp_z = (x << y[4:0]);
		  `ALU_SRA: exp_z = (x >>> y[4:0]);
		  default: exp_z = 32'd0;
		endcase
		
		// Expected flags
		exp_zero = (exp_z == 32'd0) & not_reserved;
		exp_equal = ((x === y) ? 1'b1 : 1'b0) & not_reserved;
		
		add_over = ((op == `ALU_ADD) && (x[31] == y[31]) && (exp_z[31] != x[31]));
        sub_over = ((op == `ALU_SUB) && (x[31] != y[31]) && (exp_z[31] != x[31]));
        exp_overflow  = (add_over || sub_over) & not_reserved;
        
        // Compare
        if (zero !== exp_zero) begin
          $display("ERROR FLAG: ZERO  op = %b z = %h zero = %b exp = %b", op, z, zero, exp_zero);
          error++;
        end
        if (equal !== exp_equal) begin
          $display("ERROR FLAG: EQUAL op = %b x = %h y = %h equal = %b exp = %b", op, x, y, equal, exp_equal);
          error++;
        end
        if (overflow !== exp_overflow) begin
        $display("ERROR FLAG: OVERFLOW op = %b x = %h y = %h overflow = %b exp = %b", op, x, y, overflow, exp_overflow);
          error++;
        end
	end
endmodule

