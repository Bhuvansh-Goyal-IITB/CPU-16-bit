library IEEE;
use IEEE.std_logic_1164.all;

entity controller is
  port (
    clock, reset, z: in std_logic;
    opcode: in std_logic_vector(3 downto 0);
    control: out std_logic_vector(23 downto 0) := x"000000"
  );
end entity controller;

architecture bhv of controller is
  type state is (s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20);
  signal present_state, next_state: state := s1; 
begin  
  clock_proc: process(clock, reset)
  begin
    if (clock'event and clock = '1') then 
			if (reset = '1') then
				present_state <= s1;
			else
				present_state <= next_state;
			end if;
    end if;
  end process clock_proc;
  
  state_transition: process(present_state, opcode)
  begin
    case present_state is 
      when s1 => 
        next_state <= s18;
			when s18 =>
				next_state <= s2;
      when s2 => 
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
          next_state <= s19;
        elsif (opcode = "1110") then
          next_state <= s20; 
        end if;
			when s19 => 
				next_state <= s19;
      when s14 => 
        next_state <= s15;
      when others =>
        next_state <= s1;
    end case;
  end process state_transition;

  output_proc: process(present_state)
  begin
    case present_state is
      when s1 =>
				control <= x"0C0000";
      when s2 =>
        control <= x"030000";
      when s3 =>
        control <= x"808428";
      when s4 => 
        control <= x"80842A";
      when s5 => 
        control <= x"80842C";
      when s6 => 
        control <= x"808429";
      when s7 => 
        control <= x"80842B";
      when s8 => 
        control <= x"80842D";
      when s9 => 
        control <= x"808048";
      when s10 => 
        control <= x"808280";
      when s11 => 
        control <= x"808A80";
      when s12 => 
        control <= x"809338";
      when s13 => 
        control <= x"005038";
      when s14 => 
        control <= x"00002A";
      when s15 => 
        if (z = '0') then
          control <= x"080018";
        else 
          control <= x"081018";
        end if;
      when s16 =>
        control <= x"088390";
      when s17 =>
        control <= x"08A380";
			when s18 =>
        control <= x"408180";
			when s19 => 
				control <= x"000000";
			when s20 => 
				control <= x"300000";
    end case;
  end process output_proc;
end architecture bhv;
