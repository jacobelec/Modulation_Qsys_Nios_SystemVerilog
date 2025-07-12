module sig_to_vga (
    input  logic         sampler_clk,
    input  logic [3:0]   modulation_selector,
    input  logic [7:0]   signal_selector,

    input  logic [11:0]  ask_sin,
    input  logic signed [11:0]  sin_fsk_out,
    input  logic [11:0]  bpsk_sin,
    input  logic         lfsr,
    input  logic [11:0]  sin_out,
    input  logic [11:0]  cos_out,
    input  logic [11:0]  saw_out,
    input  logic [11:0]  squ_out,
    input  logic [11:0]  cos_fsk_out,
    input  logic [11:0]  saw_fsk_out,
    input  logic [11:0]  squ_fsk_out,


    output logic [11:0]  actual_selected_modulation,
    output logic [11:0]  actual_selected_signal
);

    logic [11:0] sampled_ask, sampled_fsk, sampled_bpsk, sampled_lfsr;
    logic [11:0] sampled_sin, sampled_cos, sampled_squ, sampled_saw;
    logic is_fsk_selected;  // flag to indicate whether it's selected or not

    always_ff @(posedge sampler_clk) begin
        sampled_ask  <= ask_sin;
        sampled_fsk  <= sin_fsk_out;
        sampled_bpsk <= bpsk_sin;
        sampled_lfsr <= {lfsr, 11'b0};  // zero-extend to 12-bits for VGA
        sampled_sin  <= sin_out;
        sampled_cos  <= cos_out;
        sampled_saw  <= saw_out;
        sampled_squ  <= squ_out;
    end

    always_comb begin
        is_fsk_selected = 1'b0;

        case (modulation_selector[1:0])
            2'd0: actual_selected_modulation = sampled_ask;
            2'd1: begin
            actual_selected_modulation = sampled_fsk;
            is_fsk_selected = 1'b1;
            end
            2'd2: actual_selected_modulation = sampled_bpsk;
            2'd3: actual_selected_modulation = sampled_lfsr;
            default: actual_selected_modulation = 12'd0;
        endcase
    end

    

    always_comb begin
        if(is_fsk_selected) begin
            case(signal_selector[1:0])
                2'd0: actual_selected_signal = sin_fsk_out;  
                2'd1: actual_selected_signal = cos_fsk_out;  
                2'd2: actual_selected_signal = saw_fsk_out;  
                2'd3: actual_selected_signal = squ_fsk_out;  
                default: actual_selected_signal = sin_fsk_out;
            endcase

        end 
        else begin
            // Normal behavior: sin, cos, saw, squ
            case (signal_selector[1:0])
                2'd0: actual_selected_signal = sampled_sin;
                2'd1: actual_selected_signal = sampled_cos;
                2'd2: actual_selected_signal = sampled_saw;
                2'd3: actual_selected_signal = sampled_squ;
                default: actual_selected_signal = 12'd0;
            endcase
        end



    end


endmodule
// one thing to care about is that clk domain crossing. I am unsure about the 
// if 50Mhz is successfully converted to sampler_clk.
// should we input 50Mhz? 
// the thing is lfsr module is run in 1hz

/*always_comb begin
        case (signal_selector[1:0])
            2'd0: actual_selected_signal = sampled_sin;
            2'd1: actual_selected_signal = sampled_cos;
            2'd2: actual_selected_signal = sampled_saw;
            2'd3: actual_selected_signal = sampled_squ;
            default: actual_selected_signal = 12'd0;
        endcase
    end*/