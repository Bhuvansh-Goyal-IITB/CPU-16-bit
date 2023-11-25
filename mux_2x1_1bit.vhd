library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2x1_1bit is
  port (
    input: in std_logic_vector(1 downto 0);
    s: in std_logic;
    y: out std_logic
  );
end entity mux_2x1_1bit;

architecture bhv of mux_2x1_1bit is
begin
  y <= (input(1) and s) or (input(0) and (not s)); 
end architecture bhv;
