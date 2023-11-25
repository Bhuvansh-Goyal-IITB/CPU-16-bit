FLAGS="--std=08"

all:
	python assembler/assembler.py
	ghdl -a $(FLAGS) *.vhd
	ghdl -e $(FLAGS) testbench
	ghdl -r $(FLAGS) testbench --wave=wave.ghw --stop-time=20us
