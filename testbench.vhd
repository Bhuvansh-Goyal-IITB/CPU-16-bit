library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity testbench is
end entity testbench;

architecture bhv of testbench is

  component datapath is
    port (
      clock, program_load: in std_logic;
      control: in std_logic_vector(19 downto 0);  
      print: in std_logic;
      program_data_in, program_address_in: in std_logic_vector(15 downto 0);
      c, z: out std_logic;
      ready: out std_logic := '0';
      opcode: out std_logic_vector(3 downto 0);
      m_mem_out: out std_logic_vector(15 downto 0)
    );
  end component datapath;
  
  component controller is
    port (
      clock, z, ready: in std_logic;
      opcode: in std_logic_vector(3 downto 0);
      control: out std_logic_vector(19 downto 0) := x"00000";
      print: out std_logic := '0'
    );
  end component controller;

  signal clock: std_logic := '0';
  signal control: std_logic_vector(19 downto 0);
  signal program_data, program_address: std_logic_vector(15 downto 0) := x"0000";
  signal c, z, ready: std_logic; 
  signal opcode: std_logic_vector(3 downto 0);
  signal program_load: std_logic := '1';
  signal print: std_logic;
  signal mem_out: std_logic_vector(15 downto 0) := x"0000";

  file data_file: text open read_mode is "input.txt";
begin
  clock <= not clock after 10 ns;

  ctrl: controller port map (
    clock, z, ready, 
    opcode,
    control,
    print
  );

  dp: datapath port map (
    clock, program_load, 
    control,
    print,
    program_data, program_address,
    c, z,
    ready,
    opcode,
    mem_out
  );

  clock_proc: process (clock)
    file output_file : text open write_mode is "output.txt";
    variable line_buffer: line; 
    variable output_line: line; 
    variable bit_data: std_logic_vector(15 downto 0);
    variable out_bit_data: std_logic_vector(15 downto 0);
    variable index: INTEGER := 0;
  begin
    if (clock'event and clock = '1') then
      if (print = '1') then
        out_bit_data := mem_out;
        write(output_line, out_bit_data);
        writeline(output_file, output_line);
      end if;
      if not endfile(data_file) then
        readline(data_file, line_buffer);
        read(line_buffer, bit_data);
        program_data <= bit_data;

        if (index  > 0) then
          program_address <= std_logic_vector(unsigned(program_address) + 1);
        end if;

        index := index + 1;
      else 
        program_load <= '0';
      end if;
    end if;
  end process clock_proc;
end architecture bhv;
