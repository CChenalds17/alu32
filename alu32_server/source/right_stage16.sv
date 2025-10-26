module right_stage16
    (
        input logic [31:0] in,
        input logic en, // shamt[4]: whether we want to shift
        input logic fill, // what value to fill with
        output logic [31:0] out
    );

    genvar i;
    generate
        for (i=0; i<32; i++) begin : shift1_gen
            if (i>15) begin : fill_mux
                mux2x1_1b shift1_mux (
                    .D0(in[i]),
                    .D1(fill),
                    .S(en),
                    .Y(out[i])
                );
            end else begin : shift_mux
                mux2x1_1b shift1_mux (
                    .D0(in[i]),
                    .D1(in[i+16]),
                    .S(en),
                    .Y(out[i])
                );
            end
        end
    endgenerate
    
endmodule