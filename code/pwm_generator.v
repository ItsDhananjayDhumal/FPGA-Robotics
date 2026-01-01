
module pwm_generator(
    input clk_3125KHz,
    input [3:0] duty_cycle,
    output reg clk_195KHz, pwm_signal
);

initial begin
    clk_195KHz = 0; pwm_signal = 1;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [3:0] counter = 4'd0;

always @(posedge clk_3125KHz) begin
	counter <= counter + 1;
	clk_195KHz <= (counter == 4'd0 || counter == 4'd8) ? !clk_195KHz : clk_195KHz;
end

always @(posedge clk_3125KHz) begin
	pwm_signal <= (counter < duty_cycle) ? 1'b1 : 1'b0;
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
