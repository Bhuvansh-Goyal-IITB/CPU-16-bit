library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
  port (
    clock, reset, output_select, flag_select: in std_logic;
    control: in std_logic_vector(23 downto 0);  
    z: out std_logic;
    opcode: out std_logic_vector(3 downto 0);
		output: out std_logic_vector(7 downto 0)
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

	component dm_memory is
		port (
			address_in, data_in: in std_logic_vector(15 downto 0);
			enable, clock, reset: in std_logic;
			output: out std_logic_vector(15 downto 0)
		);
	end component dm_memory;
	
	component im_memory is
		port (
			address_in: in std_logic_vector(15 downto 0);
			output: out std_logic_vector(15 downto 0)
		);
	end component im_memory;

  component register_16bit is
    port (
      clock, enable, reset: in std_logic;
      data_in: in std_logic_vector(15 downto 0);
      data_out: out std_logic_vector(15 downto 0)
    );
  end component register_16bit;

  component register_file is
    port (
      clock, enable, reset: in std_logic;
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

	component mux_2x1_3bit is
		port (
			i0, i1: in std_logic_vector(2 downto 0);
			s: in std_logic;
			y: out std_logic_vector(2 downto 0)
		);
	end component mux_2x1_3bit;
	
	component output_module is
		port (
			clock, enable, reset, output_select, input_select: in std_logic;
			ra, dm: in std_logic_vector(15 downto 0);
			data_out: out std_logic_vector(7 downto 0)
		);
	end component output_module;

	component mux_2x1_8bit is
		port (
			i0, i1: in std_logic_vector(7 downto 0);
			s: in std_logic;
			y: out std_logic_vector(7 downto 0)
		);
	end component mux_2x1_8bit;

	
	signal pc_enable_input, rf_enable_input, c_out, z_out: std_logic;
	
  signal update_pc, update_r7, pc_enable, ti_enable, print_enable, ta_enable, tb_enable, rf_enable, mem_enable: std_logic;
  signal mp, mz, pdc, mdm: std_logic;
  signal mr, mdi, maa, mab: std_logic_vector(1 downto 0);
  signal aluc: std_logic_vector(2 downto 0);

  signal pc_mux_out, pc_update_mux_out, pc_out, im_out, dm_out: std_logic_vector(15 downto 0); 
  signal rf_data_mux_out: std_logic_vector(15 downto 0); 
  signal rf_address_mux_out, rf_address_update_mux_out: std_logic_vector(2 downto 0);
  signal rf_da_out, rf_db_out: std_logic_vector(15 downto 0); 
	signal flag_out, output_out: std_logic_vector(7 downto 0);
  signal se6_out, se9_out, pd_out: std_logic_vector(15 downto 0);
  signal ti_out, ta_out, tb_out: std_logic_vector(15 downto 0); 
  signal alu_a_mux_out, alu_b_mux_out, zero_mux_out, alu_out, dm_address_mux_out: std_logic_vector(15 downto 0); 
begin
	update_pc <= control(23); 
	update_r7 <= control(22); 
	print_enable <= control(21); 
	mdm <= control(20); 
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

  opcode <= ti_out(15 downto 12);

	pc_enable_input <= (update_pc and (rf_address_update_mux_out(0) and rf_address_update_mux_out(1) and rf_address_update_mux_out(2))) or ((not update_pc) and pc_enable);
	
	pc_update_mux: mux_2x1_16bit port map (
		pc_mux_out,
		rf_data_mux_out,
		update_pc,
		pc_update_mux_out
	);
	
  pc_reg: register_16bit port map (
    clock, 
    pc_enable_input, 
    reset,
		pc_update_mux_out, 
    pc_out
  );

  im: im_memory port map (
    pc_out, 
    im_out
  );

  dm_address_mux: mux_2x1_16bit port map (
    alu_out, 
		ta_out,
    mdm,
    dm_address_mux_out
	);

  dm: dm_memory port map (
    dm_address_mux_out, -- add in
    ta_out, -- data in
    mem_enable, 
    clock, 
		reset, 
    dm_out
  );

  se6: signed_extender_6bit port map (
    ti_out(5 downto 0),
    se6_out
  );

  se9: signed_extender_9bit port map (
    ti_out(8 downto 0),
    se9_out
  );

  pd: padd_immediate_9bit port map (
    ti_out(8 downto 0),
    pdc, 
    pd_out
  );
  
  ti_reg: register_16bit port map (
    clock, 
    ti_enable, 
		reset, 
    im_out, 
    ti_out
  );
  
  rf_address_mux: mux_4x1_3bit port map (
    ti_out(8 downto 6),
    ti_out(11 downto 9),
    ti_out(5 downto 3),
    "000",
    mr,
    rf_address_mux_out
  );

	rf_address_update_mux: mux_2x1_3bit port map (
		rf_address_mux_out,
		"111",
		update_r7,
		rf_address_update_mux_out
	);
	
  rf_data_mux: mux_4x1_16bit port map (
    alu_out,
    pd_out,
    dm_out,
    pc_out,
    mdi,
    rf_data_mux_out
  );
	
	rf_enable_input <= 	(update_r7 and ((ti_out(11) and ti_out(10) and ti_out(9)) or (ti_out(8) and ti_out(7) and ti_out(6)))) or ((not update_r7) and rf_enable);

  rf: register_file port map (
    clock, 
    rf_enable_input,
		reset,
    ti_out(11 downto 9),
    ti_out(8 downto 6),
    rf_address_update_mux_out,
    rf_data_mux_out, --data in,
    rf_da_out,
    rf_db_out
  );

  ta_reg: register_16bit port map (
    clock,
    ta_enable,
		reset,
    rf_da_out,
    ta_out
  );

  tb_reg: register_16bit port map (
    clock,
    tb_enable,
		reset, 
    rf_db_out,
    tb_out
  );

  alu_b_mux: mux_4x1_16bit port map (
    pc_out, 
    tb_out,
    se6_out,
    x"0000",
    mab,
    alu_b_mux_out
  );  

  alu_a_mux: mux_4x1_16bit port map (
    x"0001",
    ta_out,
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
    c_out,
    z_out
  );
	
	z <= z_out;	
	
	flag_out <= "000000" & c_out & z_out;
	
	output_controller: output_module port map (
		clock, print_enable, reset,
		output_select,
		ti_out(0),
		ta_out, dm_out,
		output_out
	);
		
	output_mux: mux_2x1_8bit port map (
		output_out,
		flag_out,
		flag_select,
		output
	);
		
  pc_mux: mux_2x1_16bit port map (
    alu_out,
    tb_out,
    mp,
    pc_mux_out
  );
end architecture bhv;
