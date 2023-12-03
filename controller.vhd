library IEEE;
use IEEE.std_logic_1164.all;

entity controller is
  port (
    clock, z: in std_logic;
    opcode: in std_logic_vector(3 downto 0);
    control: out std_logic_vector(19 downto 0) := x"00000";
    print: out std_logic := '0'
  );
end entity controller;

architecture bhv of controller is
  type state is (s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17);
  signal present_state, next_state: state := s1; 
  signal halt: std_logic := '0';
begin  
  clock_proc: process(clock)
  begin
    if (clock'event and clock = '1') then 
      present_state <= next_state;
    end if;
  end process clock_proc;
  
  state_transition: process(present_state, opcode)
  begin
    case present_state is 
      when s1 => 
        print <= '0';
        next_state <= s2;
      when s2 => 
        print <= '0';
        if (opcode = "0000") then
          next_state <= s3;
        elsif (opcode = "0010") then
          next_state <= s4;
        elsif (opcode = "0011") then
          next_state <= s5;
        elsif (opcode = "0001") then
          next_state <= s9;
        elsif (opcode = "0100") then
          next_state <= s6;
        elsif (opcode = "0101") then
          next_state <= s7;
        elsif (opcode = "0110") then
          next_state <= s8;
        elsif (opcode = "1000") then
          next_state <= s11;
        elsif (opcode = "1001") then
          next_state <= s10;
        elsif (opcode = "1010") then
          next_state <= s12;
        elsif (opcode = "1011") then
          next_state <= s13;
        elsif (opcode = "1100") then
          next_state <= s14;
        elsif (opcode = "1101") then
          next_state <= s16;
        elsif (opcode = "1111") then
          next_state <= s17;
        elsif (opcode = "0111") then 
          halt <= '1';
          next_state <= s2;
        elsif (opcode = "1110") then
          print <= '1';
          next_state <= s1; 
        end if;
      when s14 => 
        next_state <= s15;
      when others =>
        next_state <= s1;
    end case;
  end process state_transition;

  output_proc: process(present_state, halt)
  begin
    case present_state is
      when s1 =>
				control <= x"C0000";
      when s2 =>
        if (halt <= '0') then
          control <= x"30000";
        else
          control <= x"00000";
        end if;
      when s3 =>
        control <= x"08428";
      when s4 => 
        control <= x"0842A";
      when s5 => 
        control <= x"0842C";
      when s6 => 
        control <= x"08429";
      when s7 => 
        control <= x"0842B";
      when s8 => 
        control <= x"0842D";
      when s9 => 
        control <= x"08048";
      when s10 => 
        control <= x"08280";
      when s11 => 
        control <= x"08A80";
      when s12 => 
        control <= x"09338";
      when s13 => 
        control <= x"05038";
      when s14 => 
        control <= x"0002A";
      when s15 => 
        if (z = '0') then
          control <= x"80018";
        else 
          control <= x"81018";
        end if;
      when s16 =>
        control <= x"88390";
      when s17 =>
        control <= x"8A380";
    end case;
  end process output_proc;
end architecture bhv;
