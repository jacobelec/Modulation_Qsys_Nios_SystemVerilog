module clk_div_1hz (
    input  logic clk_50,       // 50 MHz clock input
    output logic clk_1hz       // output 1 Hz clock
);

    logic [24:0] counter = 0;  // 25-bit counter (initialized to 0)
    logic clk_1hz_reg = 0;     // Internal register for output clock

    assign clk_1hz = clk_1hz_reg;

    always_ff @(posedge clk_50) begin
        if (counter == 24_999_999) begin
            counter     <= 0;
            clk_1hz_reg <= ~clk_1hz_reg; // Toggle every 25 million cycles (i.e., every 0.5 sec)
        end else begin
            counter <= counter + 1;
        end
    end

endmodule

