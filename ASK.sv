module ASK(
    input logic lfsr,
    input logic clk_50,
    input logic [11:0] sin_out,
    output logic [11:0] ask_sin
);
always_ff @ (posedge clk_50)begin
// ASK = On if lfsr is 1, Off (0) if lfsr is 0
    ask_sin <= lfsr ? sin_out : 12'd0;  

end

endmodule