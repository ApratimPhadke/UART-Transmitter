`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: --- 
// Engineer: Apratim Phadke 
// 
// Create Date: 08/12/2025 11:33:10 PM
// Design Name: 
// Module Name: uart_transmitter
// Project Name: UART_TX
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module baudrate_gen#(parameter CLK_FREQ = 50000000 , parameter BAUD_RATE = 9600 )(
input wire clk ,
output reg baud_tick
);
localparam integer DIV_COUNT = CLK_FREQ / BAUD_RATE ;
integer counter =0;
always @(posedge clk ) begin 
if (counter>= DIV_COUNT -1 ) begin 
counter <=0;
baud_tick <= 1;
end else begin 
counter <=counter +1;
baud_tick<=0;
end 
end 
endmodule

module uart_transmitter(
    input wire clk,
    input wire tx_start,
    input wire [7:0] data_in,
    input wire baud_tick,
    output reg txd = 1'b1,  // idle high
    output reg tx_done = 0
);
    reg [3:0] bit_index = 0;
    reg [9:0] shift_reg = 10'b1111111111;
    reg sending = 0;

    always @(posedge clk) begin
        if (!sending && tx_start) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // stop, data, start
            bit_index <= 0;
            sending <= 1;  // ✅ Start sending
            tx_done <= 0;
        end 
        else if (sending && baud_tick) begin
            txd <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_index <= bit_index + 1;

            if (bit_index == 9) begin
                sending <= 0;
                tx_done <= 1;
                txd <= 1'b1; // idle high after stop
            end
        end
    end
endmodule

module top_uart(
input wire clk,
input wire tx_start,
input wire [7:0] data_in ,
output wire txd ,
output wire  tx_done 
);
wire baud_tick;
baudrate_gen #(50000000 ,9600) bg (
.clk(clk),
.baud_tick(baud_tick)
);
uart_transmitter tx (
.clk(clk),
.tx_start(tx_start) ,
.data_in(data_in),
.baud_tick(baud_tick),
.txd(txd),
.tx_done(tx_done)
);
endmodule
