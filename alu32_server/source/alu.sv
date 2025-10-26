`include "alu.svh"

module alu
    (
        input logic [31:0] x,               // 1st input
        input logic [31:0] y,               // 2nd input
        input logic [2:0] op,               // 3-bit op code
        output logic [31:0] z,              // output
        output logic zero, equal, overflow  // flags
    );

    // submodule outputs
    logic [31:0] z_and, z_rca, z_sub, z_slt, z_srl, z_sra, z_sll, z_cla, z_reserved;
    logic c32, of;
    logic [31:0] s; // sum (output of adder)
    logic [31:0] shift_in; // intput of shifter
    logic [31:0] x_rev; // reversed input for left shift
    logic [31:0] shift_out; // output of shifter
    
    // compute sub as continuous assign tracking op[1]
    logic sub;
    assign sub = op[1];
    
    // slt intermediate output
    logic slt_bit;
    
    // flag intermediate outputs
    logic xor_op0op1, not_op2;
    logic z_flag, eq_flag, of_flag;
    logic not_reserved;
    
    assign z_reserved = '0;
    
    // AND
    and32 and_unit (.x(x), .y(y), .z(z_and));
    
    // RCA
//    rca_32 rca_unit(
//        .a(x),
//        .b(y),
//        .sub(sub),
//        .s(s),
//        .c32(c32),
//        .of(of)
//    );
//    // ADD (RCA)
//    assign z_rca = s;

    // CLA
    cla_adder32 cla(
        .A(x),
        .B(y),
        .sub(sub),
        .C32(c32),
        .of(of),
        .sum(s)
    );
    
    // ADD (RCA)
    assign z_cla = s;

    // SUB
    assign z_sub = s;

    // SLT
    xor slt_unit (slt_bit, s[31], of);
    assign z_slt = {31'b0, slt_bit};

    // FLAGS
    equal32 equal_unit (.x(x), .y(y), .equal(eq_flag));
    zero32 zero_unit (.z(z), .zero(z_flag));
    // check of op is reserved flag -- if not, then we let the flags through. otherwise, set all flags to 0
    nand check_reserved (not_reserved, op[0], op[1], op[2]);
    and equal_flag (equal, eq_flag, not_reserved);
    and zero_flag (zero, z_flag, not_reserved);
    
    // (make sure overflow only carries through on ADD and SUB)
    xor u_of_1 (xor_op0op1, op[0], op[1]);
    not u_of_2 (not_op2, op[2]);
    and u_of_3 (of_flag, xor_op0op1, not_op2, of);
    and overflow_flag (overflow, of_flag, not_reserved);


    // Part B -- SRL, SRA, SLL, ADD (with carry-lookahead adder)
    
    // shift left if op[1] == 1
    reverse32 input_reverse (
        .in(x),
        .out(x_rev)
    );
    // reverse x for shifter if we want to shift left
    mux2x1_32b sel_reverse (
        .D0(x),
        .D1(x_rev),
        .S(op[1]),
        .Y(shift_in)
    );
    
    
    sr32 shifter(
        .in(shift_in),
        .shamt(y[4:0]),
        .arithmetic(op[0]),
        .out(shift_out)
    );

    // SRL
    assign z_srl = shift_out;

    // SRA
    assign z_sra = shift_out;

    // SLL
    // reverses output of shifter; if op code is for sll, then this gives us our correctly left-shifted value (otherwise garbage)
    reverse32 sll_reverser (
        .in(shift_out),
        .out(z_sll)
    );


    // MUX 8:1 to select the output z from the submodule outputs
    mux8x1_32b output_mux (
        .D0(z_and),
//        .D1(z_rca),
        .D1(z_cla),
        .D2(z_sub),
        .D3(z_slt),
        .D4(z_srl),
        .D5(z_sra),
        .D6(z_sll),
        .D7(z_reserved),
        .S(op),
        .Y(z)
    );
    
endmodule
