library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity testbench;

architecture bhv of testbench is

  component cpu is 
    port (
			clock: in std_logic; 
			c, z, print: out std_logic;
	    mem_out: out std_logic_vector(15 downto 0)
    );
  end component cpu; 

  signal clock: std_logic := '0';
  signal c, z, print: std_logic;
	signal mem_out: std_logic_vector(15 downto 0);
begin
  clock <= not clock after 10 ns;

  cpu_block: cpu port map (
		clock, 
		c, z, print,
		mem_out
  ); 
end architecture bhv;
