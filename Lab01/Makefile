all:
	quartus_sh --flow compile Lab01
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab01.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd

sim_xor: buildFolder
	iverilog -o build/sim_xor -s swxor_tb swxor_tb.v swxor.v
	vvp build/sim_xor

sim_key: buildFolder
	iverilog -o build/sim_key -s key2dec_tb key2dec_tb.v key2dec.v
	vvp build/sim_key

sim_shift: buildFolder
	iverilog -o build/sim_shift -s ledshift_tb ledshift_tb.v ledshift.v
	vvp build/sim_shift

buildFolder:
	mkdir -p build
