module sr32
    (
        input logic [31:0] in,
        input logic [4:0] shamt,
        input logic arithmetic,
        output logic [31:0] out
    );
    
    logic [31:0] shifted0, shifted1, shifted2, shifted3;
    logic fill; // fill bit: 0 if not arithmetic, otherwise MSB (in[31])
    and f (fill, arithmetic, in[31]); // gives us our fill bit so we can use it whenever
        
    // Note: I'm working on this too late to ask course staff if this adheres to the guidelines, but I'm doing it in a sort of roundabout way so that
    // the logic here only affects how I assign output wires of one stage to input wires of the next stage -- if needed, I could manually write out each 2:1 mux
    // input (that would just be tedious, and what this if statement aims to avoid); no extra gates get created by this.
    
    // if we will need to shift by 1
    right_stage1 shifter0 (
        .in(in),
        .en(shamt[0]),
        .fill(fill),
        .out(shifted0)
    );
    
    // if we need to shift by 2
    right_stage2 shifter1 (
        .in(shifted0),
        .en(shamt[1]),
        .fill(fill),
        .out(shifted1)
    );
    
    // shift by 4
    right_stage4 shifter2 (
        .in(shifted1),
        .en(shamt[2]),
        .fill(fill),
        .out(shifted2)
    );
    
    // shift by 8
    right_stage8 shifter3 (
        .in(shifted2),
        .en(shamt[3]),
        .fill(fill),
        .out(shifted3)
    );
     
    // shift by 16
    right_stage16 shifter4 (
        .in(shifted3),
        .en(shamt[4]),
        .fill(fill),
        .out(out)
    );

endmodule
