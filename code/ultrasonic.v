/*
Module HC_SR04 Ultrasonic Sensor

This module will detect objects present in front of the range, and give the distance in mm.

Input:  clk_50M - 50 MHz clock
        reset   - reset input signal (Use negative reset)
        echo_rx - receive echo from the sensor

Output: trig    - trigger sensor for the sensor
        op     -  output signal to indicate object is present.
        distance_out - distance in mm, if object is present.
*/

// module Declaration
module ultrasonic(
    input clk_50M, reset, echo_rx,
    output reg trig,
    output op,
    output wire [15:0] distance_out
);

initial begin
    trig = 0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

parameter WAIT = 0,
			 HIGH = 1,
			 LOW = 2,
			 IDLE = 3;
			 

//integer counter, echo_counter;

reg [1:0] state;
reg [19:0] counter;
reg [19:0] echo_counter;
reg [15:0] distance;
reg present;

initial begin
	state <= WAIT;
	counter <= 0;
	echo_counter <= 0;
	present <= 0;
	distance <= 0;
end

always @(posedge clk_50M) begin
	if (!reset) begin
		counter <= 0;
	end 
	else begin
    if (counter > 600552) begin
        counter <= 0;
    end
    else begin
        counter <= counter + 1;
    end
	end
end

always @(posedge clk_50M) begin
	if (!reset) begin
		state <= WAIT;
		echo_counter <= 0;
		present <= 0;
		distance <= 0;
	end
	else begin
	case (state)
		
		WAIT: begin
			if (counter > 50) begin
				trig <= 1'b1;
				state <= HIGH;
			end
			else begin
				trig <= 1'b0;
			end
		end
		
		HIGH : begin
			if (counter > 550) begin
				trig <= 1'b0;
				state <= LOW;
			end
			else begin
				trig <= 1'b1;
			end
		end
		
		LOW : begin
			if (echo_counter == 0 && counter > 600000) begin // 12ms buffer for echo to go high
				state <= IDLE;
			end
			
			else if (echo_rx == 1'b1) begin
			echo_counter <= echo_counter + 1;
			end
			else if (echo_counter > 0) begin
			state <= IDLE;
			distance <= 34 * echo_counter / 10000;
			echo_counter <= 0;
			end
		end
				
		IDLE : begin
			if (counter == 0) begin
				state <= WAIT;
			end	
		end
		
		default : state <= WAIT;
		
	endcase
	end
	
end

assign distance_out = distance;
assign op = (distance_out < 71) ? 1'b1 : 1'b0;

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
