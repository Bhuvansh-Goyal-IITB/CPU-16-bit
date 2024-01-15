library IEEE;
use IEEE.std_logic_1164.all;

entity output_module is
  port (
    clock, enable, reset, output_select, input_select: in std_logic;
    ra, dm: in std_logic_vector(15 downto 0);
    data_out: out std_logic_vector(7 downto 0)
  );
end entity output_module;

architecture bhv of output_module is
	component mux_2x1_16bit is
		port (
			i0, i1: in std_logic_vector(15 downto 0);
			s: in std_logic;
			y: out std_logic_vector(15 downto 0)
		);
	end component mux_2x1_16bit;
	
	component mux_2x1_8bit is
		port (
			i0, i1: in std_logic_vector(7 downto 0);
			s: in std_logic;
			y: out std_logic_vector(7 downto 0)
		);
	end component mux_2x1_8bit;
	
	component register_16bit is
		port (
			clock, enable, reset: in std_logic;
			data_in: in std_logic_vector(15 downto 0);
			data_out: out std_logic_vector(15 downto 0)
		);
	end component register_16bit;
	
	signal input_mux_out, input_out: std_logic_vector(15 downto 0);
begin
  input_mux: mux_2x1_16bit port map (
		ra, 
		dm,
		input_select,
		input_mux_out
	);
	
	print_buffer: register_16bit port map (
		clock, enable, reset,
		input_mux_out,
		input_out
	);
	
	output_mux: mux_2x1_8bit port map (
		input_out(7 downto 0),
		input_out(15 downto 8),
		output_select,
		data_out
	);
end architecture bhv;
