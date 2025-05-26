all:
	quartus_sh --flow compile Lab07
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab07.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd


sim_inner: buildFolder
	iverilog -o build/sim_inner_cache -s cache_tb -g2012 cache_tb.sv inner_cache.sv
	vvp build/sim_inner_cache

sim_outer: buildFolder
	iverilog -o build/cache_hierarchy_tb -s cache_hierarchy_tb -g2012 cache_hierarchy_tb.sv outer_cache.sv
	vvp build/cache_hierarchy_tb
.PHONY: all load clean sim_inner sim_outer


buildFolder:
	mkdir -p build
