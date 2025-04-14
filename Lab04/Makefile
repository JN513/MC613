all:
	quartus_sh --flow compile Lab04
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab04.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd

buildFolder:
	mkdir -p build

sim: buildFolder
	iverilog -o build/sim -s multiplier_tb -g2012 multiplier_tb.v multiplier.v
	vvp build/sim


