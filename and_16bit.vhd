library IEEE;
use IEEE.std_logic_1164.all;

entity and_16bit is
  port (
    a, b: in std_logic_vector(15 downto 0);
    output: out std_logic_vector(15 downto 0)
  );
end entity and_16bit;

architecture bhv of and_16bit is
begin
  add_gen: for i in 0 to 15 generate
    output(i) <= a(i) and b(i);
  end generate add_gen;
end architecture bhv;
