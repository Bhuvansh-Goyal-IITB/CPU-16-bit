library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_file is
  port (
    clock, enable, reset: in std_logic;
    a, b, c: in std_logic_vector(2 downto 0);  
    data_in: in std_logic_vector(15 downto 0);
    da_out, db_out: out std_logic_vector(15 downto 0)
  );
end entity register_file;

architecture bhv of register_file is
  type reg_array is array(7 downto 0) of std_logic_vector(15 downto 0);
  signal reg_file: reg_array := (others => x"0000");
begin
  da_out <= reg_file(to_integer(unsigned(a)));
  db_out <= reg_file(to_integer(unsigned(b)));

  clock_proc: process (clock, enable, reset) 
  begin
		if (reset = '1') then
			reg_file <= (others => x"0000");
    elsif (clock'event and clock = '1' and enable = '1') then 
			reg_file(to_integer(unsigned(c))) <= data_in;
		end if;
  end process clock_proc;
end architecture bhv;
