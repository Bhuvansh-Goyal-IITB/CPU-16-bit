library IEEE;
use IEEE.std_logic_1164.all;

entity d_flip_flop is
  port (
    clock, enable, d: in std_logic;
    q, q_not: out std_logic := '0'  
  );
end entity d_flip_flop;

architecture bhv of d_flip_flop is
begin
  q_not <= not q;
  clock_process: process(clock, enable)
  begin
    if (clock'event and clock = '1' and enable = '1') then
      q <= d;
    end if;
  end process clock_process;
end architecture bhv;
