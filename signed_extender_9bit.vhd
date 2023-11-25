library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity signed_extender_9bit is
  port (
    input: in std_logic_vector(8 downto 0); 
    output: out std_logic_vector(15 downto 0)
  );
end entity signed_extender_9bit;

architecture bhv of signed_extender_9bit is
begin
  output <= "0000000" & input when (input(8) = '0') else "1111111" & input; 
end architecture bhv;
