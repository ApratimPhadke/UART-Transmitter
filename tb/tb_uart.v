`timescale 1ns / 1ps

module tb_uart();

    // Testbench signals
    reg clk_tb = 0;
    reg tx_start_tb = 0;
    reg [7:0] data_in_tb = 8'h00;
    wire txd_tb;
    wire tx_done_tb;

    // Clock generation: 50 MHz (20 ns period)
    always #10 clk_tb = ~clk_tb;

    // Instantiate top module
    top_uart uut (
        .clk(clk_tb),
        .tx_start(tx_start_tb),
        .data_in(data_in_tb),
        .txd(txd_tb),
        .tx_done(tx_done_tb)
    );

    initial begin
        // Dump waveforms (for GTKWave)
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, tb_uart);

        // Wait a few cycles before sending
        #100;
        
        // Send first byte (0x55)
        data_in_tb = 8'h55;  // 01010101
        tx_start_tb = 1;
        #20;                 // Hold tx_start for 1 clock
        tx_start_tb = 0;

        // Wait until done
        wait (tx_done_tb == 1);
        #200000; // Wait extra time

        // Send second byte (0xA3)
        data_in_tb = 8'hA3;  // 10100011
        tx_start_tb = 1;
        #20;
        tx_start_tb = 0;

        wait (tx_done_tb == 1);
        #200000;

        // End simulation
        $finish;
    end

endmodule
