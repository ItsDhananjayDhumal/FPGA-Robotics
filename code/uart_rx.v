
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

initial begin
    rx_msg = 8'b0;
    rx_parity = 1'b0;
    rx_complete = 1'b0;
end

reg [5:0]   counter = 0;
reg [3:0] bit_count = 0;
reg  complete_state = 0;

reg [10:0]  rx_data = 0;

// all counters logic
always @(posedge clk_3125) begin

    if (counter == 6'd27) begin
        counter <= 6'd1;
        if (bit_count == 4'd10) begin
            bit_count <= 4'd0;
            rx_complete <= 1'b1;
        end
        else begin
            bit_count <= bit_count + 1;
            rx_complete <= 1'b0;
        end
    end

    else begin
        counter <= counter + 1;
        rx_complete <= 1'b0;
    end

    // store data from rx signal in rx_data registers
    if (counter == 6'd20) begin
        rx_data[bit_count] <= rx;
    end

    // update all output lines at the end of 11th bit
    else if (counter == 6'd27 && bit_count == 4'd10) begin
        
        rx_msg[0] <= rx_data[8];
        rx_msg[1] <= rx_data[7];
        rx_msg[2] <= rx_data[6];
        rx_msg[3] <= rx_data[5];
        rx_msg[4] <= rx_data[4];
        rx_msg[5] <= rx_data[3];
        rx_msg[6] <= rx_data[2];
        rx_msg[7] <= rx_data[1];

        rx_parity <= (^(rx_data[8:1]));

    end

end

endmodule
