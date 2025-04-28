all:
	quartus_sh --flow compile Lab06
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab06.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd


sim_rx: buildFolder
	iverilog -o build/uart_rx_tb -s uart_rx_tb -g2012  uart_rx.sv uart_rx_tb.sv
	vvp build/uart_rx_tb

sim_tx: buildFolder
	iverilog -o build/uart_tx_tb -s uart_tx_tb -g2012  uart_tx.sv uart_tx_tb.sv
	vvp build/uart_tx_tb

sim_uart: buildFolder
	iverilog -o build/uart_tb -s uart_tb -g2012  uart.sv uart_tb.sv uart_tx.sv uart_rx.sv
	vvp build/uart_tb

buildFolder:
	mkdir -p build
