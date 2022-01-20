module uart (input wire clk,        // 50MHz input clock
             output wire LED,
             output UART_TX,
             output [7:0] TEST_IO);
    
    // 50,000,000 / 115,200 = 434...
    localparam BAUD_RATE = 435;
    
    reg [31:0] cnt; // led 32-bit counter
    reg [7:0] TX_BYTE = 8'h0E;
    reg r_TX_DV       = 1'b1;
    wire TX_ACTIVE;
    wire TX_DONE;
    wire [2:0] TX_STATE;
    
    reg [7:0] DATA[10:0];
    reg [3:0] DATA_CNT = 0;
    reg [15:0] BINARY_POINTS_H; // point x
    reg [15:0] BINARY_POINTS_V; // point y
    
    initial begin
        cnt <= 32'h00000000; // led start at zero
    end
    
    initial begin // set tx data
        DATA[0] = 7'h53; //S
        DATA[1] = 7'h54; //T
        DATA[2] = 7'h87; //data
        DATA[3] = 7'h45; //E
        DATA[4] = 7'h4E; //N
        DATA[5] = 7'h44; //D
    end
    
    always @(posedge clk) begin
        cnt <= cnt + 1; // led count up
        r_TX_DV = 1'b1;
    end
    
    //assign LED to 25th bit of the counter to blink the LED at a few Hz
    assign LED = cnt[24];
    
    uart_tx #(.CLKS_PER_BIT(BAUD_RATE)) u0 (
    .i_Clock(clk),
    .i_Tx_DV(r_TX_DV),
    .i_Tx_Byte(TX_BYTE),
    .o_Tx_Active(TX_ACTIVE),
    .o_Tx_Serial(UART_TX),
    .o_Tx_Done(TX_DONE),
    .o_Tx_State(TX_STATE)
    );
    
    always @(posedge TX_DONE) begin
        TX_BYTE <= DATA[DATA_CNT];
        if (DATA_CNT < 5)
        begin
            DATA_CNT <= DATA_CNT + 1;
        end
        else
        begin
            DATA_CNT <= 0;
        end
    end
    
    assign TEST_IO[0] = UART_TX;
    assign TEST_IO[1] = LED;
    assign TEST_IO[2] = TX_BYTE[0];
    assign TEST_IO[3] = TX_ACTIVE;
    assign TEST_IO[4] = TX_DONE;
    assign TEST_IO[5] = TX_STATE[0];
    assign TEST_IO[6] = TX_STATE[1];
    
endmodule
