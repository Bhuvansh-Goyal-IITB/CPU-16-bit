library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_sub_16bit is
  port (
    a, b: in std_logic_vector(15 downto 0);
    operation: in std_logic; -- 0 for add and 1 for subtract
    output: out std_logic_vector(15 downto 0);
    carry_out: out std_logic
  );
end entity add_sub_16bit;

architecture bhv of add_sub_16bit is
  component full_adder is
    port (
      a, b, c_in: in std_logic;
      sum, c_out: out std_logic
    );
  end component full_adder;

  signal a_mod: std_logic_vector(15 downto 0);
  signal carry_array: std_logic_vector(15 downto 0);
begin
  mod_gen: for i in 0 to 15 generate
    a_mod(i) <= a(i) xor operation;
  end generate mod_gen;

  fa_0: full_adder port map (a_mod(0), b(0), operation, output(0), carry_array(0));

  fa_gen: for i in 1 to 14 generate
    fa_i: full_adder port map (a_mod(i), b(i), carry_array(i-1), output(i), carry_array(i));
  end generate fa_gen;

   fa_l: full_adder port map (a_mod(15), b(15), carry_array(14), output(15), carry_out);
end architecture bhv;
