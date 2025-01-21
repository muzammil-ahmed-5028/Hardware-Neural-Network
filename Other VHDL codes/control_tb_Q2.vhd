library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_tb_Q2 is
end entity control_tb_Q2;

architecture sim of control_tb_Q2 is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;
    
    -- Signals for control module
    signal w2_ram_address : std_logic_vector(9 downto 0);
    signal x_ram_address : std_logic_vector(9 downto 0);
    signal L2_ram_address : std_logic_vector(10 downto 0);
    signal w3_ram_address : std_logic_vector(10 downto 0);
	signal L3_ram_address : std_logic_vector(9 downto 0);
	signal w4_ram_address : std_logic_vector(9 downto 0);
	signal L4_ram_address : std_logic_vector(8 downto 0);
	signal w5_ram_address : std_logic_vector(8 downto 0);
	signal L5_ram_address : std_logic_vector(3 downto 0);
	
	-- data lines
	signal w2_data: std_logic_vector(15 downto 0);
	signal x_data: std_logic_vector(15 downto 0);
	signal mac_out: signed(31 downto 0);
	signal ff_out_tb: signed(31 downto 0);
	signal L2_output: std_logic_vector(15 downto 0);
	----LAYER 3
	signal w3_data: std_logic_vector(15 downto 0);
	signal L2_output_after_RELU: signed(15 downto 0);
	signal mac_out_3: signed(31 downto 0);
	signal ff_out_tb_3: signed(31 downto 0);
	signal L3_output: std_logic_vector(15 downto 0);
	----Layer 4
	signal w4_data: std_logic_vector(15 downto 0);
	signal L3_output_after_RELU: signed(15 downto 0);
	signal mac_out_4: signed(31 downto 0);
	signal ff_out_tb_4: signed(31 downto 0);
	signal L4_output: std_logic_vector(15 downto 0);
	----Layer 5
	signal w5_data: std_logic_vector(15 downto 0);
	signal L4_output_after_RELU: signed(15 downto 0);
	signal mac_out_5: signed(31 downto 0);
	signal ff_out_tb_5: signed(31 downto 0);
	signal L5_output: std_logic_vector(15 downto 0);
	
	
	-- control signals
    signal L2_rden : std_logic := '1';
    signal L2_wren : std_logic := '1';
	----LAYER 3
    signal L3_rden : std_logic := '1';
    signal L3_wren : std_logic := '1';
	----Layer 4
    signal L4_rden : std_logic := '1';
    signal L4_wren : std_logic := '1';
	----Layer 5
	signal L5_rden : std_logic := '1';
    signal L5_wren : std_logic := '1';
	
	-- misc
	signal count_out : std_logic_vector(31 downto 0);  -- Added count_out signal
    signal update_en : std_logic := '1';  -- Example update_en signal
    signal rst_mac_2: std_logic;
	signal rst_mac_3: std_logic;
	signal rst_mac_4: std_logic;
	signal rst_mac_5: std_logic;
	
	-- start Layer Computation
	signal start_L2: std_logic;
	-- Clock process
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    
    -- Clock generation process
begin



    process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Reset process
    process
    begin
        reset <= '1';
	start_L2 <= '0';
        wait for 10 ns;
        reset <= '0';
	wait for 10 ns;
	start_L2 <= '1';
        wait;
    end process;

    -- Stimulus process
    -- Instantiate the control module
    control_inst : entity work.control_Q2
        port map (
            w2_ram_address => w2_ram_address,
            x_ram_address => x_ram_address,
            L2_ram_address => L2_ram_address,
            w3_ram_address => w3_ram_address, 
			L3_ram_address => L3_ram_address,
			w4_ram_address => w4_ram_address,
			L4_ram_address => L4_ram_address,
            w5_ram_address => w5_ram_address,
			L5_ram_address => L5_ram_address,
			L2_rden => L2_rden, -- add control code for this to the control module
            L2_wren => L2_wren,  -- add control code for this to the control module
            L3_rden => L3_rden,
			L3_wren => L3_wren,
			L4_rden => L4_rden,
			L4_wren => L4_wren,
			L5_rden => L5_rden,
			L5_wren => L5_wren,
			
			count_in => unsigned(count_out),  -- Connect count_out to count_in
	    rst_mac_2 => rst_mac_2,
	    rst_mac_3 => rst_mac_3,
	    rst_mac_4 => rst_mac_4,
		rst_mac_5 => rst_mac_5,
		start_L2 => start_L2
		);

    -- Instantiate the counter module
    counter_inst : entity work.counter_32
        port map (
            clk => clk,
            reset => reset,
            update_en => update_en,  -- Pass update_en to counter module
            count_out => count_out  -- Output count_out from counter module
        );

	-- LAYER 2
	W2_RAM_inst: entity work.W_RAM_LAYER_2_Q
	port map(
		address => w2_ram_address,
		clock => clk,
		data => std_logic_vector(to_unsigned(0,16)),
		rden => '1',
		wren => '0',
		q => w2_data
	);
	
	X_RAM_inst: entity work.X_INPUT_RAM
	port map(
		address => x_ram_address,
		clock => clk,
		data => std_logic_vector(to_unsigned(0,16)),
		rden => '1',
		wren => '0',
		q => x_data
	);
	
	MAC_2: entity work.MAC
	port map(
		a_in => signed(w2_data),
		b_in => signed(x_data),
		mult_add_out => mac_out,
		ff_out => ff_out_tb,
		clk => clk,
		reset => rst_mac_2
	);
	
	L2_RAM_inst: entity work.RAM_OUTPUT
	port map(
		address => L2_ram_address,
		clock => clk,
		data => std_logic_vector(mac_out(31 downto 16)),
		rden => L2_rden,
		wren => L2_wren,
		q => L2_output
	);
	-- LAYER 3
	
	W3_RAM_inst: entity work.W_RAM_LAYER_3_Q
	port map(
		address => w3_ram_address,
		Clock => clk,
		data => std_logic_vector(to_unsigned(0,16)),
		rden => '1',
		wren => '0',
		q => w3_data
	);
	
	RELU: entity work.RELU
	port map(
		relu_IN => signed(L2_output),
		count_in => unsigned(count_out),
		relu_OUT => L2_output_after_RELU
	);
	
	MAC_3: entity work.MAC
	port map(
		a_in => signed(w3_data),
		b_in => signed(L2_output_after_RELU),
		mult_add_out => mac_out_3,
		ff_out => ff_out_tb_3,
		clk => clk,
		reset => rst_mac_3
	);
	
	L3_RAM_OUTPUT: entity work.RAM_OUTPUT_LAYER_3
	port map(
		address => L3_ram_address,
		clock => clk,
		data => std_logic_vector(mac_out_3(31 downto 16)),
		rden => L3_rden,
		wren => L3_wren,
		q => L3_output
	);
	
	-- LAYER 4
	
	W4_RAM_inst: entity work.W_RAM_LAYER_4_Q
	port map(
		address => w4_ram_address,
		Clock => clk,
		data => std_logic_vector(to_unsigned(0,16)),
		rden => '1',
		wren => '0',
		q => w4_data
	);
	
	RELU_4: entity work.RELU
	port map(
		relu_IN => signed(L3_output),
		count_in => unsigned(count_out),
		relu_OUT => L3_output_after_RELU
	);
	
	MAC_4: entity work.MAC
	port map(
		a_in => signed(w4_data),
		b_in => signed(L3_output_after_RELU),
		mult_add_out => mac_out_4,
		ff_out => ff_out_tb_4,
		clk => clk,
		reset => rst_mac_4
	);
	
	L4_RAM_OUTPUT: entity work.RAM_OUTPUT_LAYER_4 
	port map(
		address => L4_ram_address,
		clock => clk,
		data => std_logic_vector(mac_out_4(31 downto 16)),
		rden => L4_rden,
		wren => L4_wren,
		q => L4_output
	);
	
	-- LAYER 5
	
	W5_RAM_inst: entity work.W_RAM_LAYER_5_Q
	port map(
		address => w5_ram_address,
		Clock => clk,
		data => std_logic_vector(to_unsigned(0,16)),
		rden => '1',
		wren => '0',
		q => w5_data
	);
	
	RELU_5: entity work.RELU
	port map(
		relu_IN => signed(L4_output),
		count_in => unsigned(count_out),
		relu_OUT => L4_output_after_RELU
	);
	
	MAC_5: entity work.MAC
	port map(
		a_in => signed(w5_data),
		b_in => signed(L4_output_after_RELU),
		mult_add_out => mac_out_5,
		ff_out => ff_out_tb_5,
		clk => clk,
		reset => rst_mac_5
	);
	
	L5_RAM_OUTPUT: entity work.RAM_OUTPUT_LAYER_5 
	port map(
		address => L5_ram_address,
		clock => clk,
		data => std_logic_vector(mac_out_5(31 downto 16)),
		rden => L5_rden,
		wren => L5_wren,
		q => L5_output
	);
	
	
    -- Optional: Add assertions or checks here to verify functionality

end architecture sim;