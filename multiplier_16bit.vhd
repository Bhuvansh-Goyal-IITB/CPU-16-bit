library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier_16bit is
  port (
    a, b: in std_logic_vector(15 downto 0);
    output: out std_logic_vector(15 downto 0)
  );
end entity multiplier_16bit;

architecture bhv of multiplier_16bit is
 signal mul_4_bit: std_logic_vector(7 downto 0); 
begin
  mul_4_bit <= std_logic_vector(unsigned(a(3 downto 0)) * unsigned(b(3 downto 0)));
  output <= x"00" & mul_4_bit;
end architecture bhv;
