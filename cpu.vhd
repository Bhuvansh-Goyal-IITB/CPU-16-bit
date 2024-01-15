library IEEE;
use IEEE.std_logic_1164.all;

entity cpu is 
  port (
	  clock, reset, output_select, flag_select: in std_logic; 
    output: out std_logic_vector(7 downto 0)
  );
end entity cpu; 

architecture bhv of cpu is 
	component datapath is
		port (
			clock, reset, output_select, flag_select: in std_logic;
			control: in std_logic_vector(23 downto 0);  
			z: out std_logic;
			opcode: out std_logic_vector(3 downto 0);
			output: out std_logic_vector(7 downto 0)
		);
	end component datapath;
		
	component clock_div is
		port (clock_in, reset: std_logic; clock_out: out std_logic);
	end component clock_div;
		
	component controller is
		port (
			clock, reset, z: in std_logic;
			opcode: in std_logic_vector(3 downto 0);
			control: out std_logic_vector(23 downto 0) := x"000000"
		);
	end component controller;
  
	signal z, clock_out: std_logic;
  signal control: std_logic_vector(23 downto 0);
  signal opcode: std_logic_vector(3 downto 0);
begin
	ctrl: controller port map (
    clock_out, reset, z, 
    opcode,
    control
  );

	clk: clock_div port map (
		clock, reset, clock_out
	);
	
  dp: datapath port map (
    clock_out, reset, output_select, flag_select, 
    control,
		z,
    opcode,
    output
  );
end bhv;