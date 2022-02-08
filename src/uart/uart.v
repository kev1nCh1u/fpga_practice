module uart (input wire clk,        // 50MHz input clock
             output wire LED,
             output wire LED2,
             input UART_RX,
             output UART_TX,
             output [7:0] TEST_IO);
    
    // 50,000,000 / 115,200 = 434...
    localparam BAUD_RATE = 435;
    
    reg [31:0] cnt; // led 32-bit counter

    reg [7:0] TX_BYTE;
    reg r_TX_DV;
    wire TX_ACTIVE;
    wire TX_DONE;
    wire [2:0] TX_STATE;

    wire [7:0] RX_BYTE;
    wire r_RX_DV;
    reg r_RX_FLAG;
    wire [2:0] RX_STATE; // kevin
    
    reg [7:0] DATA[10:0];
    reg [3:0] DATA_CNT;
    reg [15:0] BINARY_POINTS_H; // point_x
    reg [15:0] BINARY_POINTS_V; // point_y
    
    initial begin
        cnt <= 32'h00000000; // led start at zero
    end
    
    initial begin // set tx data
        BINARY_POINTS_H = 16'd640; // point_x
        BINARY_POINTS_V = 16'd480; // point_y

        DATA[0] = 8'h53; //S
        DATA[1] = 8'h54; //T

        DATA[2] = BINARY_POINTS_H[15:8]; // point_x H
        DATA[3] = BINARY_POINTS_H[7:0]; // point_x L
        DATA[4] = BINARY_POINTS_V[15:8];  // point_y H
        DATA[5] = BINARY_POINTS_V[7:0];  // point_y L

        DATA[6] = 8'h45; //E
        DATA[7] = 8'h4E; //N
        DATA[8] = 8'h44; //D
    end
    
    uart_tx #(.CLKS_PER_BIT(BAUD_RATE)) ut0 (
    .i_Clock(clk),
    .i_Tx_DV(r_TX_DV),
    .i_Tx_Byte(TX_BYTE),
    .o_Tx_Active(TX_ACTIVE),
    .o_Tx_Serial(UART_TX),
    .o_Tx_Done(TX_DONE),
    .o_Tx_State(TX_STATE)
    );
    
    uart_rx #(.CLKS_PER_BIT(BAUD_RATE)) ur0 (
    .i_Clock(clk),
    .i_Rx_Serial(UART_RX),
    .o_Rx_DV(r_RX_DV),
    .o_Rx_Byte(RX_BYTE),
    .o_Rx_State(RX_STATE)
    );
    
    always @(posedge clk) begin
        cnt <= cnt + 1; // led count up
        r_TX_DV = 1'b1;
    end

    always @(posedge TX_DONE) begin
        TX_BYTE <= DATA[DATA_CNT];
        if (DATA_CNT < 8)
        begin
            DATA_CNT <= DATA_CNT + 1;
        end
        else
        begin
            DATA_CNT <= 0;
        end
    end

    always @(posedge r_RX_DV) begin
        if (RX_BYTE == 8'h01)
        begin
            r_RX_FLAG <= 1;
        end
        else if(RX_BYTE == 8'h00)
        begin
            r_RX_FLAG <= 0;
        end
    end
    
    //assign LED to 25th bit of the counter to blink the LED at a few Hz
    assign LED = r_RX_FLAG ? cnt[24] : 0;
    assign LED2 = r_RX_FLAG;
    
    assign TEST_IO[0] = LED;
    assign TEST_IO[1] = UART_TX;
    assign TEST_IO[2] = UART_RX;
    // assign TEST_IO[3] = RX_STATE[0];
    // assign TEST_IO[4] = RX_STATE[1];
    assign TEST_IO[5] = r_RX_DV;
    assign TEST_IO[6] = RX_BYTE[0];
    assign TEST_IO[7] = r_RX_FLAG;
    
endmodule
