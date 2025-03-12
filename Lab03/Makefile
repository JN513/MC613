all:
	quartus_sh --flow compile Lab03
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab03.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd

sim: buildFolder
	iverilog -o build/sim_fsm -s fsm_tb fsm_tb.v fsm.v
	vvp build/sim_fsm

buildFolder:
	mkdir -p build
