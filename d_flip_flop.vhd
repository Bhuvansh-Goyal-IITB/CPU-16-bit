library IEEE;
use IEEE.std_logic_1164.all;

entity d_flip_flop is
  port (
    clock, enable, reset, d: in std_logic;
    q, q_not: out std_logic 
  );
end entity d_flip_flop;

architecture bhv of d_flip_flop is
	signal m_q: std_logic := '0';
begin
  q <= m_q;
  q_not <= not m_q;
  clock_process: process(clock, enable, reset)
  begin
		if (reset = '1') then
			m_q <= '0';		
    elsif (clock'event and clock = '1' and enable = '1') then
			m_q <= d;
    end if;
  end process clock_process;
end architecture bhv;
