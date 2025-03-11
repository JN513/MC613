all:
	quartus_sh --flow compile Lab02
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab02.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd

sim_alu: buildFolder
	iverilog -o build/sim_alu -s alu_tb alu_tb.v alu.v
	vvp build/sim_alu

sim_hex: buildFolder
	iverilog -o build/sim_hex -s bin2hex_tb bin2hex_tb.v bin2hex.v
	vvp build/sim_hex

sim_dec: buildFolder
	iverilog -o build/sim_dec -s bin2dec_tb bin2dec_tb.v bin2dec.v
	vvp build/sim_dec

buildFolder:
	mkdir -p build
