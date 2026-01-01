module end_recog(
    input ir_up, ir_down,
    input op_left, op_right, op_front,
    output [1:0] end_signal
);

// end_signal 00 --> front clear
//            01 --> dead end
//            10 --> mpi

parameter CLEAR = 2'b00,
          DEADEND = 2'b01,
          MP = 2'b10;

assign end_signal = (ir_up & ~ir_down & op_front) ? MP : (op_front) ? DEADEND : CLEAR;

endmodule