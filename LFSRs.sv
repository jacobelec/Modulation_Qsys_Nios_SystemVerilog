module LFSRs (
    input  logic clk_1hz,
    output logic [4:0] lfsr
);

    // Internal signals
    logic feedback;
    logic [4:0] lfsr_out;
    logic initialized = 0;

    /* Clock divider instance
    clk_div_1hz clock_divider (
        .CLK_50  (clk_50),
        .clk_1hz (clk_1hz)
    );*/

    // Feedback logic using taps at bits 0 and 2
    assign feedback = lfsr_out[0] ^ lfsr_out[2];

    // Output assignment
    assign lfsr = lfsr_out;

    // Shift register logic with power-up initialization
    always_ff @(posedge clk_1hz) begin
        if (!initialized) begin
            lfsr_out   <= 5'b00001; 
            initialized <= 1;
        end else begin
            lfsr_out <= {feedback, lfsr_out[4:1]};
        end
    end

endmodule
