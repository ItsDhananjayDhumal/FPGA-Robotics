module us_md(
    input rx_uart,
    input clk_50M, reset, echo1, echo2, echo3,
    input re_left_1, re_left_2, re_right_1, re_right_2,
    input ir_up, ir_down,
    output trig1, trig2, trig3, op_left, op_right, op_front,
    output in1, in2, in3, in4, ena, enb,
    output [1:0] end_signal,
    output [3:0] test_leds
);

wire clk_3125KHz;
wire [15:0] dist_left, dist_right, dist_front;
wire [19:0] left_counter, right_counter;
wire [7:0] rx_msg;

ultrasonic us_inst1 (.clk_50M(clk_50M),
                     .echo_rx(echo1),
                     .trig(trig1),
                     .reset(reset),
                     .op(op_left),
                     .distance_out(dist_left));

ultrasonic us_inst2 (.clk_50M(clk_50M),
                     .echo_rx(echo2),
                     .trig(trig2),
                     .reset(reset),
                     .op(op_right),
                     .distance_out(dist_right));

ultrasonic us_inst3 (.clk_50M(clk_50M),
                     .echo_rx(echo3),
                     .trig(trig3),
                     .reset(reset),
                     .op(op_front),
                     .distance_out(dist_front));

frequency_scaling clk_gen_inst (.clk_50M(clk_50M),
                                .clk_3125KHz(clk_3125KHz));

motor_driver driver_inst (.clk_3125KHz(clk_3125KHz),
                          .in1(in1),
                          .in2(in2),
                          .in3(in3),
                          .in4(in4),
                          .ena(ena),
                          .enb(enb),
                          .stop(op_front),
                          .dist_left(dist_left),
                          .dist_right(dist_right));

rotary_encoder left_re_inst (.clk_50M(clk_50M),
                             .en1(re_left_1),
                             .en2(re_left_2),
                             .reset(reset),
                             .counter(left_counter));

rotary_encoder right_re_inst (.clk_50M(clk_50M),
                              .en1(re_right_1),
                              .en2(re_right_2),
                              .reset(reset),
                              .counter(right_counter));

end_recog recog_inst (.ir_up(ir_up),
                      .ir_down(ir_down),
                      .op_left(op_left),
                      .op_right(op_right),
                      .op_front(op_front),
                      .end_signal(end_signal));
                    
uart_rx rx_inst (.clk_3125KHz(clk_3125KHz),
                 .rx(rx_uart),
                 .rx_msg(rx_msg));

assign test_leds = (rx_msg == 8'b01100001) ? 4'b1000 : (rx_msg == 8'b01100010) ? 4'b0100 : (rx_msg == 8'b01100011) ? 4'b0010 : 4'b0001;
// a OR b OR c OR else

endmodule