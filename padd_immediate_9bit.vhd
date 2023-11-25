library IEEE;
use IEEE.std_logic_1164.all;

entity padd_immediate_9bit is
  port (
    input: in std_logic_vector(8 downto 0);
    pdc: in std_logic;
    output: out std_logic_vector(15 downto 0)
  );
end entity padd_immediate_9bit;

architecture bhv of padd_immediate_9bit is
begin
  output <= "0000000" & input when (pdc = '0') else input & "0000000"; 
end architecture bhv;
