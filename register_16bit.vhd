library IEEE;
use IEEE.std_logic_1164.all;

entity register_16bit is
  port (
    clock, enable: in std_logic;
    data_in: in std_logic_vector(15 downto 0);
    data_out: out std_logic_vector(15 downto 0)
  );
end entity register_16bit;

architecture bhv of register_16bit is
  component d_flip_flop is
    port (
      clock, enable, d: in std_logic;
      q, q_not: out std_logic := '0'  
    );
  end component d_flip_flop;
begin
  dff_gen: for i in 0 to 15 generate
    dff: d_flip_flop port map (clock, enable, data_in(i), data_out(i));
  end generate dff_gen;
end architecture bhv;
