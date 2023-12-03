library IEEE;
use IEEE.std_logic_1164.all;

entity cpu is 
  port (
	  clock: in std_logic; 
    c, z, print: out std_logic;
    mem_out: out std_logic_vector(15 downto 0)
  );
end entity cpu; 

architecture bhv of cpu is 
	component datapath is
		port (
			clock: in std_logic;
			control: in std_logic_vector(19 downto 0);  
			print: in std_logic;
			c, z: out std_logic;
			opcode: out std_logic_vector(3 downto 0);
			mem_out: out std_logic_vector(15 downto 0)
		);
	end component datapath;
		
	component controller is
		port (
			clock, z: in std_logic;
			opcode: in std_logic_vector(3 downto 0);
			control: out std_logic_vector(19 downto 0) := x"00000";
			print: out std_logic := '0'
		);
	end component controller;
  
	signal m_z: std_logic;
  signal control: std_logic_vector(19 downto 0);
  signal opcode: std_logic_vector(3 downto 0);
  signal program_load: std_logic := '0';
  signal m_print: std_logic;
begin
	print <= m_print;
	z <= m_z;
	ctrl: controller port map (
    clock, m_z, 
    opcode,
    control,
    m_print
  );

  dp: datapath port map (
    clock,
    control,
    m_print,
    c, m_z,
    opcode,
    mem_out
  );
end bhv;