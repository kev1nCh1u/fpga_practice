
module blink (input wire clk,        // 50MHz input clock
              output wire LED,       // LED ouput
              output [7:0] TEST_IO); // TEST_IO ouput
    
    reg [31:0] cnt; // 32-bit counter
    
    wire clk_2; 
    wire clk_3; 
    reg [31:0] cnt_2; // 32-bit counter
    reg [31:0] cnt_3; // 32-bit counter

    initial begin
        cnt <= 32'h00000000; // start at zero
    end
    
    always @(posedge clk) begin
        cnt <= cnt + 1; // count up
    end

    always @(posedge clk_2) begin
        cnt_2 <= cnt_2 + 1; // count up
    end

    assign clk_2 = ~clk;
    
    //assign LED to 25th bit of the counter to blink the LED at a few Hz
    assign LED        = cnt[24];
    assign TEST_IO[0] = clk;
    assign TEST_IO[1] = clk_2;
    assign TEST_IO[2] = cnt[24];
    assign TEST_IO[3] = cnt_2[24];    

    pll pll_1 (
        .refclk   (clk),   //  refclk.clk
		.rst      (0),      //   reset.reset
		.outclk_0 (clk_3), // outclk0.clk
    );

    always @(posedge clk_3) begin
        cnt_3 <= cnt_3 + 1; // count up
    end
    
    assign TEST_IO[4] = clk_3;  
    assign TEST_IO[5] = cnt_3[24];  
    
endmodule
