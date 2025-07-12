module BPSK (
    input  logic        clk,
    input  logic        lfsr,
    input  logic [11:0] sin_in,      // NOTE: unsigned at interface
    output logic [11:0] bpsk_out     // NOTE: unsigned at interface
);

    // Internal signed wires for math
    logic signed [11:0] sin_internal;
    logic signed [11:0] modulated;

    // Cast to signed
    assign sin_internal = sin_in;

    // Perform signed modulation
    always_ff @(posedge clk) begin
        if (lfsr)
            modulated <= sin_internal;
        else
            modulated <= -sin_internal;
    end

    // Cast back to unsigned output
    assign bpsk_out = modulated;

endmodule
