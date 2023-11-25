library IEEE;
use IEEE.std_logic_1164.all;

entity implication_16bit is
  port (
    a, b: in std_logic_vector(15 downto 0);
    output: out std_logic_vector(15 downto 0)
  );
end entity implication_16bit;

architecture bhv of implication_16bit is
begin
  imp_gen: for i in 0 to 15 generate
    output(i) <= (not b(i)) or a(i);
  end generate imp_gen;
end architecture bhv;
