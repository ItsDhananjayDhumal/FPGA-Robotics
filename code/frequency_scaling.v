
module frequency_scaling (
    input clk_50M,
    output reg clk_3125KHz
);

initial begin
    clk_3125KHz = 0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [2:0] counter = 3'd0;

always @(posedge clk_50M) begin
	counter <= counter + 1;
	clk_3125KHz <= (counter == 3'd0) ? !clk_3125KHz : clk_3125KHz;
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
