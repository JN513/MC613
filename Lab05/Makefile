all:
	quartus_sh --flow compile Lab05
	
load:
	quartus_pgm -m jtag -c "DE-SoC " -o "p;output_files/Lab05.sof@2"

clean:
	rm -rf build/*
	rm -rf .env
	rm -rf output_files/*
	rm -rf db/*
	rm -rf *.o
	rm -rf *.vcd

sim:
	ghdl -a -fsynopsys --std=08 hexcode.vhd hexcode_tb.vhd
	ghdl -e -fsynopsys --std=08 hexcode_tb
	ghdl -r -fsynopsys --std=08 hexcode_tb --vcd=hexcode.vcd


