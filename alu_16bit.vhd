library IEEE;
use IEEE.std_logic_1164.all;

-- add -> 000, sub -> 010, mul -> 100
-- and -> 001, or -> 011, imp -> 101
entity alu_16bit is
  port (
    a, b: in std_logic_vector(15 downto 0);
    operation: in std_logic_vector(2 downto 0);
    output: out std_logic_vector(15 downto 0);
    c, z: out std_logic 
  );
end entity alu_16bit;

architecture bhv of alu_16bit is
  
  component multiplier_16bit is
    port (
      a, b: in std_logic_vector(15 downto 0);
      output: out std_logic_vector(15 downto 0)
    );
  end component multiplier_16bit;

  component add_sub_16bit is
    port (
      a, b: in std_logic_vector(15 downto 0);
      operation: in std_logic; -- 0 for add and 1 for subtract
      output: out std_logic_vector(15 downto 0);
      carry_out: out std_logic
    );
  end component add_sub_16bit;

  component implication_16bit is
    port (
      a, b: in std_logic_vector(15 downto 0);
      output: out std_logic_vector(15 downto 0)
    );
  end component implication_16bit;

  component or_16bit is
    port (
      a, b: in std_logic_vector(15 downto 0);
      output: out std_logic_vector(15 downto 0)
    );
  end component or_16bit;

  component and_16bit is
    port (
      a, b: in std_logic_vector(15 downto 0);
      output: out std_logic_vector(15 downto 0)
    );
  end component and_16bit;
  
  component mux_2x1_16bit is
    port (
      i0, i1: in std_logic_vector(15 downto 0);
      s: in std_logic;
      y: out std_logic_vector(15 downto 0)
    );
  end component mux_2x1_16bit;

  component mux_4x1_16bit is
    port (
      i0, i1, i2, i3: in std_logic_vector(15 downto 0);
      s: in std_logic_vector(1 downto 0);
      y: out std_logic_vector(15 downto 0)
    );
  end component mux_4x1_16bit;

  signal add_sub_out, mul_out, and_out, or_out, imp_out, arith_out, logical_out: std_logic_vector(15 downto 0);
  signal carry: std_logic;
	signal test_signal: std_logic_vector(1 downto 0);
	signal m_output: std_logic_vector(15 downto 0);
begin
  c <= carry and (not operation(2)) and (not operation(0));
	output <= m_output;
  z_proc: process(m_output)
  begin
    if (m_output = x"0000") then
      z <= '1';
    else 
      z <= '0';
    end if;
  end process z_proc;

  add_sub_both: add_sub_16bit port map (a, b, operation(1), add_sub_out, carry);
  mul_both: multiplier_16bit port map (a, b, mul_out);
  and_both: and_16bit port map (a, b, and_out);
  or_both: or_16bit port map (a, b, or_out);
  imp_both: implication_16bit port map (a, b, imp_out);

  arith_mux: mux_2x1_16bit port map (add_sub_out, mul_out, operation(2), arith_out);
	test_signal <= operation(2) & operation(1);
  logical_mux: mux_4x1_16bit port map (and_out, or_out, imp_out, imp_out, test_signal, logical_out);

  combined_mux: mux_2x1_16bit port map (arith_out, logical_out, operation(0), m_output);

end architecture bhv;
