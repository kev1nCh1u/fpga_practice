                               // create module
module uart (input wire clk,   // 50MHz input clock
             output wire LED); // LED ouput
    
                    // create a binary counter[31:0] cnt;                 // 32-bit counter
    reg [31:0] cnt; // 32-bit counter
    
    initial begin
        cnt <= 32'h00000000; // start at zero
    end
    
    always @(posedge clk) begin
        cnt <= cnt + 1; // count up
    end
    
    //assign LED to 25th bit of the counter to blink the LED at a few Hz
    assign LED = cnt[24];
    
    rs232uart u0 (
    .clk        (<connected-to-clk>),        //                clk.clk
    .reset      (<connected-to-reset>),      //              reset.reset
    .address    (<connected-to-address>),    // avalon_rs232_slave.address
    .chipselect (<connected-to-chipselect>), //                   .chipselect
    .byteenable (<connected-to-byteenable>), //                   .byteenable
    .read       (<connected-to-read>),       //                   .read
    .write      (<connected-to-write>),      //                   .write
    .writedata  (<connected-to-writedata>),  //                   .writedata
    .readdata   (<connected-to-readdata>),   //                   .readdata
    .irq        (<connected-to-irq>),        //          interrupt.irq
    .UART_RXD   (<connected-to-UART_RXD>),   // external_interface.RXD
    .UART_TXD   (<connected-to-UART_TXD>)    //                   .TXD
    );
    
endmodule
