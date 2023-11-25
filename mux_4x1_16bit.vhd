library IEEE;
use IEEE.std_logic_1164.all;

entity mux_4x1_16bit is
  port (
    i0, i1, i2, i3: in std_logic_vector(15 downto 0);
    s: in std_logic_vector(1 downto 0);
    y: out std_logic_vector(15 downto 0)
  );
end entity mux_4x1_16bit;

architecture bhv of mux_4x1_16bit is
  component mux_4x1_1bit is
    port (
      input: in std_logic_vector(3 downto 0);
      s: in std_logic_vector(1 downto 0);
      y: out std_logic
    );
  end component mux_4x1_1bit;
begin
  mux_gen: for i in 0 to 15 generate
    mux_4x1: mux_4x1_1bit port map (i3(i) & i2(i) & i1(i) & i0(i), s, y(i)); 
  end generate mux_gen;  
end architecture bhv;
