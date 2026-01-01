module us_md(
    input clk_50M, reset, echo1, echo2,
    input re_left_1, re_left_2, re_right_1, re_right_2,
    output trig1, trig2,
    output in1, in2, in3, in4, ena, enb,
    output wire [19:0] left_counter
);

wire clk_3125KHz;
wire [15:0] dist_left, dist_right;

ultrasonic us_inst1 (.clk_50M(clk_50M),
                     .echo_rx(echo1),
                     .trig(trig1),
                     .reset(reset),
                     .distance_out(dist_left));

ultrasonic us_inst2 (.clk_50M(clk_50M),
                     .echo_rx(echo2),
                     .trig(trig2),
                     .reset(reset),
                     .distance_out(dist_right));

frequency_scaling clk_gen_inst (.clk_50M(clk_50M),
                                .clk_3125KHz(clk_3125KHz));

motor_driver driver_inst (.clk_3125KHz(clk_3125KHz),
                          .in1(in1),
                          .in2(in2),
                          .in3(in3),
                          .in4(in4),
                          .ena(ena),
                          .enb(enb),
                          .dist_left(dist_left),
                          .dist_right(dist_right));

rotary_encoder left_re_inst (.clk_50M(clk_50M),
                             .en1(re_left_1),
                             .en2(re_left_2),
                             .reset(reset),
                             .counter(left_counter));

endmodule