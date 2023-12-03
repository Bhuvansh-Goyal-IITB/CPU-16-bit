library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity im_memory is
  port (
    address_in: in std_logic_vector(15 downto 0);
    output: out std_logic_vector(15 downto 0)
  );
end entity im_memory;

architecture bhv of im_memory is
  type reg_arr is array(65535 downto 0) of std_logic_vector(15 downto 0);
  signal mem_arr: reg_arr := (
		0 => "0001000000000111",
1 => "1011000001000000",
2 => "0001001001000001",
3 => "1011001001000000",
4 => "1010000010000000",
5 => "0001000000111111",
6 => "1011000010000000",
7 => "1010000010000001",
8 => "1010001010000010",
9 => "0000000001000000",
10 => "1011000010000011",
11 => "1010000010000001",
12 => "1011000010000010",
13 => "1110000000000010",
14 => "1010000010000011",
15 => "1011000010000001",
16 => "1010000010000000",
17 => "1100000010000001",
18 => "1101011111110001",
19 => "0111000000000000",

		others => x"0000"
	);
begin
  output <= mem_arr(to_integer(unsigned(address_in))); 
end architecture bhv;
