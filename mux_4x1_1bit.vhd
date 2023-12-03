library IEEE;
use IEEE.std_logic_1164.all;
 
entity mux_4x1_1bit is
  port (
    input: in std_logic_vector(3 downto 0);
    s: in std_logic_vector(1 downto 0);
    y: out std_logic
  );
end entity mux_4x1_1bit;

architecture bhv of mux_4x1_1bit is
  component mux_2x1_1bit is
    port (
      input: in std_logic_vector(1 downto 0);
      s: in std_logic;
      y: out std_logic
    );
  end component mux_2x1_1bit;
  
  signal mx1_out, mx2_out: std_logic;
	signal test_signal: std_logic_vector(1 downto 0);
begin
  mx1: mux_2x1_1bit port map (input(1 downto 0), s(0), mx1_out);
  mx2: mux_2x1_1bit port map (input(3 downto 2), s(0), mx2_out);
  test_signal <= mx2_out & mx1_out;
  mx3: mux_2x1_1bit port map (test_signal, s(1), y);
end architecture bhv;
