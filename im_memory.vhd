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
		0 => "1001100000000010",
1 => "0001000000000111",
2 => "1011000001000000",
3 => "0001001001000001",
4 => "1011001001000000",
5 => "1010000010000000",
6 => "0001000000111111",
7 => "1011000010000000",
8 => "1010000010000001",
9 => "1010001010000010",
10 => "0000000001000000",
11 => "1011000010000011",
12 => "1010000010000001",
13 => "1011000010000010",
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
