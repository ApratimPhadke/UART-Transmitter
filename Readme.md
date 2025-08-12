
---

```markdown
# UART Transmitter (Verilog)

## 📌 Overview
This project implements a **UART (Universal Asynchronous Receiver/Transmitter) Transmitter** in Verilog.  
It converts **parallel 8-bit data** into a serial bitstream according to standard UART protocol.

Features:
- 8N1 UART format (1 start bit, 8 data bits, 1 stop bit)
- Parameterized **baud rate** and **system clock frequency**
- Separate **baud rate generator** and **transmitter logic**
- `tx_start` signal to begin transmission
- `tx_done` flag when transmission is complete

---

## 🖼 UART Frame Format

```

Idle (1) → Start Bit (0) → Data\[0] → Data\[1] → ... → Data\[7] → Stop Bit (1)

```

Example for `0x55` (binary `01010101`):

```

Idle: 1
Start: 0
Data: 1 0 1 0 1 0 1 0  (LSB first)
Stop:  1

```

---

## 📂 Project Structure

```

UART-Transmitter/
│
├── src/
│   ├── baudrate\_gen.v        # Baud rate generator
│   ├── uart\_transmitter.v    # UART TX logic
│   └── top\_uart.v            # Top module connecting baud generator + transmitter
│
├── tb/
│   └── tb\_uart.v             # Testbench
│
├── README.md                 # This file
└── .gitignore

````

---

## ⚙️ Parameters

### Baud Rate Generator
```verilog
parameter CLK_FREQ   = 50000000; // System clock frequency in Hz
parameter BAUD_RATE  = 9600;     // Baud rate
````

---

## ▶️ Simulation

### Testbench (`tb_uart.v`)

* Generates a **50 MHz clock**
* Sends two bytes over UART (`0x55` and `0xA3`)
* Monitors `txd` waveform

Run simulation (Icarus Verilog example):

```bash
# Compile
iverilog -o uart_tb tb/tb_uart.v src/uart_transmitter.v src/baudrate_gen.v src/top_uart.v

# Run
vvp uart_tb

# View waveform
gtkwave uart_tx_tb.vcd
```

---

## 📊 Block Diagram

```
           +-----------------+
           | Baudrate Gen    |
clk ------>|                 |------> baud_tick
           +-----------------+
                    |
                    v
           +-----------------+
           | UART TX Logic   |
tx_start ->| shift register  |--> txd
data_in -->| FSM control     |
           +-----------------+
                    |
                    v
                tx_done
```

---

## 📝 Usage Notes

* `txd` stays HIGH when idle.
* `tx_start` should be pulsed HIGH for one clock cycle to start transmission.
* `tx_done` will go HIGH for one cycle after sending the stop bit.
* Make sure the **receiver device** is set to the same baud rate, data length, and stop bits.

---

## 📜 License

This project is open-source under the [MIT License](LICENSE).

```


