library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
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
end entity datapath;

architecture bhv of datapath is
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

  component memory is
    port (
      address_in, data_in: in std_logic_vector(15 downto 0);
      enable, clock: in std_logic;
      output: out std_logic_vector(15 downto 0)
    );
  end component memory;

  component register_16bit is
    port (
      clock, enable: in std_logic;
      data_in: in std_logic_vector(15 downto 0);
      data_out: out std_logic_vector(15 downto 0)
    );
  end component register_16bit;

  component register_file is
    port (
      clock, enable: in std_logic;
      a, b, c: in std_logic_vector(2 downto 0);  
      data_in: in std_logic_vector(15 downto 0);
      da_out, db_out: out std_logic_vector(15 downto 0)
    );
  end component register_file;

  component signed_extender_9bit is
    port (
      input: in std_logic_vector(8 downto 0); 
      output: out std_logic_vector(15 downto 0)
    );
  end component signed_extender_9bit;

  component signed_extender_6bit is
    port (
      input: in std_logic_vector(5 downto 0); 
      output: out std_logic_vector(15 downto 0)
    );
  end component signed_extender_6bit;

  component padd_immediate_9bit is
    port (
      input: in std_logic_vector(8 downto 0);
      pdc: in std_logic;
      output: out std_logic_vector(15 downto 0)
    );
  end component padd_immediate_9bit;

  component alu_16bit is
    port (
      a, b: in std_logic_vector(15 downto 0);
      operation: in std_logic_vector(2 downto 0);
      output: out std_logic_vector(15 downto 0);
      c, z: out std_logic 
    );
  end component alu_16bit;

  component mux_4x1_3bit is
    port (
      i0, i1, i2, i3: in std_logic_vector(2 downto 0);
      s: in std_logic_vector(1 downto 0);
      y: out std_logic_vector(2 downto 0)
    );
  end component mux_4x1_3bit;

  signal pc_enable, ti_enable, ta_enable, tb_enable, rf_enable, mem_enable: std_logic;
  signal mp, mz, pdc: std_logic;
  signal mr, mdi, maa, mab: std_logic_vector(1 downto 0);
  signal aluc: std_logic_vector(2 downto 0);

  signal pc_mux_out, pc_out, im_mux_out, im_out: std_logic_vector(15 downto 0); 
  signal rf_data_mux_out: std_logic_vector(15 downto 0); 
  signal rf_address_mux_out: std_logic_vector(2 downto 0);
  signal rf_da_out, rf_db_out: std_logic_vector(15 downto 0); 
  signal se6_out, se9_out, pd_out: std_logic_vector(15 downto 0);
  signal mem_out: std_logic_vector(15 downto 0); 
  signal t0_out, t1_out, t2_out: std_logic_vector(15 downto 0); 
  signal alu_a_mux_out, alu_b_mux_out, zero_mux_out, alu_out, dm_mux_out: std_logic_vector(15 downto 0); 
begin
  pc_enable <= control(19); 
  ti_enable <= control(18); 
  ta_enable <= control(17); 
  tb_enable <= control(16); 
  rf_enable <= control(15); 
  mem_enable <= control(14); 
  
  mp <= control(13); 
  mz <= control(12); 
  pdc <= control(11); 

  mr <= control(10 downto 9);
  mdi <= control(8 downto 7);
  mab <= control(6 downto 5);
  maa <= control(4 downto 3);
  aluc <= control(2 downto 0);

  ready <= not program_load;

  opcode <= t0_out(15 downto 12);

  pc_reg: register_16bit port map (
    clock, 
    pc_enable, 
    pc_mux_out, 
    pc_out
  );

  im_mux: mux_2x1_16bit port map (
    pc_out, 
    program_address_in, 
    program_load, 
    im_mux_out
  );   

  im: memory port map (
    im_mux_out, 
    program_data_in,
    program_load, 
    clock,
    im_out
  );

  dm_mux: mux_2x1_16bit port map (
    alu_out, "0000" & t0_out(11 downto 0),
    print,
    dm_mux_out
  );

  dm: memory port map (
    dm_mux_out, -- add in
    t1_out, -- data in
    mem_enable, 
    clock, 
    mem_out
  );
  
  m_mem_out <= mem_out;

  se6: signed_extender_6bit port map (
    t0_out(5 downto 0),
    se6_out
  );

  se9: signed_extender_9bit port map (
    t0_out(8 downto 0),
    se9_out
  );

  pd: padd_immediate_9bit port map (
    t0_out(8 downto 0),
    pdc, 
    pd_out
  );
  
  t0_reg: register_16bit port map (
    clock, 
    ti_enable, 
    im_out, 
    t0_out
  );
  
  rf_address_mux: mux_4x1_3bit port map (
    t0_out(8 downto 6),
    t0_out(11 downto 9),
    t0_out(5 downto 3),
    "000",
    mr,
    rf_address_mux_out
  );

  rf_data_mux: mux_4x1_16bit port map (
    alu_out,
    pd_out,
    mem_out,
    pc_out,
    mdi,
    rf_data_mux_out
  );

  rf: register_file port map (
    clock, 
    rf_enable,
    t0_out(11 downto 9),
    t0_out(8 downto 6),
    rf_address_mux_out,
    rf_data_mux_out, --data in,
    rf_da_out,
    rf_db_out
  );

  t1_reg: register_16bit port map (
    clock,
    ta_enable,
    rf_da_out,
    t1_out
  );

  t2_reg: register_16bit port map (
    clock,
    tb_enable, 
    rf_db_out,
    t2_out
  );

  alu_b_mux: mux_4x1_16bit port map (
    pc_out, 
    t2_out,
    se6_out,
    x"0000",
    mab,
    alu_b_mux_out
  );  

  alu_a_mux: mux_4x1_16bit port map (
    x"0001",
    t1_out,
    se9_out,
    zero_mux_out,
    maa,
    alu_a_mux_out
  );

  zero_mux: mux_2x1_16bit port map (
    x"0000",
    se6_out,
    mz,
    zero_mux_out
  );  

  alu: alu_16bit port map (
    alu_a_mux_out,
    alu_b_mux_out,
    aluc,
    alu_out,
    c,
    z
  );

  pc_mux: mux_2x1_16bit port map (
    alu_out,
    t2_out,
    mp,
    pc_mux_out
  );
end architecture bhv;
