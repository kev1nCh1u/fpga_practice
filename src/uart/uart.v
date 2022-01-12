module uart (input wire clk,        // 50MHz input clock
             output wire LED,
             output UART_TX,
             output [7:0] TEST_IO);
    
    reg [31:0] cnt; // 32-bit counter
    reg [7:0] TX_BYTE = 8'h0E;
    reg r_TX_DV         = 1'b1;
    wire TX_ACTIVE;
    wire TX_DONE;
    wire [2:0] TX_STATE;
    
    // 50,000,000 / 115,200 = 434...
    localparam BAUD_RATE = 435;
    
    initial begin
        cnt <= 32'h00000000; // start at zero
    end
    
    always @(posedge clk) begin
        cnt <= cnt + 1; // count up
        r_TX_DV = 1'b1;
    end
    
    //assign LED to 25th bit of the counter to blink the LED at a few Hz
    assign LED = cnt[24];
    
    // rs232uart u0 (
    // .clk        (<connected-to-clk>),        //                clk.clk
    // .reset      (<connected-to-reset>),      //              reset.reset
    // .address    (<connected-to-address>),    // avalon_rs232_slave.address
    // .chipselect (<connected-to-chipselect>), //                   .chipselect
    // .byteenable (<connected-to-byteenable>), //                   .byteenable
    // .read       (<connected-to-read>),       //                   .read
    // .write      (<connected-to-write>),      //                   .write
    // .writedata  (<connected-to-writedata>),  //                   .writedata
    // .readdata   (<connected-to-readdata>),   //                   .readdata
    // .irq        (<connected-to-irq>),        //          interrupt.irq
    // .UART_RXD   (<connected-to-UART_RXD>),   // external_interface.RXD
    // .UART_TXD   (<connected-to-UART_TXD>)    //                   .TXD
    // );
    
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
      TX_BYTE <= TX_BYTE + 1;
    end

    
    // initial
    // begin
    //     // Tell UART to send a command (exercise TX)
    //     @(posedge clk);
    //     @(posedge clk);
    //     r_TX_DV   <= 1'b1;
    //     TX_BYTE <= 8'h3F;
    //     @(posedge clk);
    //     r_TX_DV <= 1'b0;
    // end
    
    assign TEST_IO[0] = UART_TX;
    assign TEST_IO[1] = LED;
    assign TEST_IO[2] = TX_BYTE[0];
    assign TEST_IO[3] = TX_ACTIVE;
    assign TEST_IO[4] = TX_DONE;
    assign TEST_IO[5] = TX_STATE[0];
    assign TEST_IO[6] = TX_STATE[1];
    
endmodule
