library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is
	port (clock_in, reset: std_logic; clock_out: out std_logic);
end entity clock_div;

architecture bhv of clock_div is
	signal sign: std_logic := '1';
begin
clock_proc: process(clock_in, reset)
	variable count: INTEGER := 1;
begin
	if (reset = '0') then
		if (clock_in = '1' and clock_in'event and count < 2500001) then
			count := count + 1;
		elsif (clock_in = '1' and clock_in'event and count > 2500000) then
			count := 1;
			sign <= not(sign);
		end if;
	else
		count := 1;
		sign <= '1';
	end if;
end process clock_proc;
clock_out <= sign;

end bhv;
	
	
		
	

