module motor_driver (
    input clk_3125KHz,
    input wire [15:0] dist_left, dist_right,
    output ena, enb,
    output in1, in2, in3, in4
);

parameter [1:0] STOP = 2'b00,
                FORWARD = 2'b10,
                BACKWARD = 2'b01;

parameter AVERAGE_DISATNCE = 200;

wire [3:0] left_ds, right_ds;

assign left_ds = dist_left * 15/AVERAGE_DISATNCE;
assign right_ds = dist_right * 15/AVERAGE_DISATNCE;

pwm_generator left_speed_control (.clk_3125KHz(clk_3125KHz),
                                  .duty_cycle(left_ds),
                                  .pwm_signal(ena));
pwm_generator right_speed_control (.clk_3125KHz(clk_3125KHz),
                                   .duty_cycle(right_ds),
                                   .pwm_signal(enb));

assign {in1, in2, in3, in4} = 4'b1010;

endmodule