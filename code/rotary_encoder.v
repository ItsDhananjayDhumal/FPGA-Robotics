module rotary_encoder(
    input clk_50M, reset,
    input en1, en2,
    output reg [19:0] counter
);

    reg [3:0] state = 4'b1100;

    reg [1:0] en1_sync, en2_sync;
    always @(posedge clk_50M) begin
        en1_sync <= {en1_sync[0], en1};
        en2_sync <= {en2_sync[0], en2};
    end
    
    wire a = en1_sync[1];
    wire b = en2_sync[1];

    wire [3:0] lro, rro;
    assign lro = {state[2:0], state[3]};
    assign rro = {state[0], state[3:1]};

    always @(posedge clk_50M) begin
        if (~reset) begin
            counter <= 0;
        end
        else begin
            if ({a, b} == lro[1:0]) begin
                counter <= counter + 1;
                state <= lro;
            end
            else if ({a, b} == rro[1:0]) begin
                counter <= counter - 1;
                state <= rro;
            end
        end
    end

endmodule