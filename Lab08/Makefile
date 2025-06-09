all:
	quartus_sh --flow compile Lab08
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab08.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd


sim: buildFolder
	iverilog -o build/controller -s controller_tb -g2012 controller_tb.sv controller.sv
	vvp build/controller


buildFolder:
	mkdir -p build
