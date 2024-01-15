library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dm_memory is
  port (
    address_in: in std_logic_vector(5 downto 0);
		data_in: in std_logic_vector(15 downto 0);
    enable, clock, reset: in std_logic;
    output: out std_logic_vector(15 downto 0)
  );
end entity dm_memory;

architecture bhv of dm_memory is
  type reg_arr is array(63 downto 0) of std_logic_vector(15 downto 0);
  signal mem_arr: reg_arr := (others => x"0000");
begin
  output <= mem_arr(to_integer(unsigned(address_in))); 
  
  clock_proc: process(clock, enable, reset)
  begin
		if (reset = '1') then
			mem_arr <= (others => x"0000");
    elsif (clock'event and clock = '1' and enable = '1') then 
			mem_arr(to_integer(unsigned(address_in))) <= data_in; 
		end if;
  end process clock_proc;

end architecture bhv;
