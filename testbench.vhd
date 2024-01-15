library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity testbench;

architecture bhv of testbench is
  component cpu is 
		port (
			clock, reset, output_select, flag_select: in std_logic; 
			output: out std_logic_vector(7 downto 0)
		);
  end component cpu; 

  signal clock: std_logic := '0';
	signal reset: std_logic := '1';
  signal output_select, flag_select: std_logic := '0';
	signal output: std_logic_vector(7 downto 0);
begin
  clock <= not clock after 10 ns;
	reset <= '0' after 20 ns;
		
  cpu_block: cpu port map (
		clock, reset, output_select, flag_select, 
		output
  ); 
end architecture bhv;
