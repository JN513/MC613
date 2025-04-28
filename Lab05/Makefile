all:
	quartus_sh --flow compile lab05
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/lab05.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd


sim_time: buildFolder
	iverilog -o build/sim_time -s tb_Time time_tb.v time.v bin_to_bcd_7seg.v
	vvp build/sim_time

sim_stop: buildFolder
	iverilog -o build/sim_stop -s tb_StopWatch stopwatch_tb.v stopwatch.v bin_to_bcd_7seg.v
	vvp build/sim_stop

buildFolder:
	mkdir -p build
