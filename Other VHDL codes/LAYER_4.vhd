library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LAYER_4 is
port(
	input_in_from_layer_3 : in std_logic_vector(15 downto 0);
	clk_sys : in std_logic; 
	rst_sys: in std_logic;
    rst_acc: in std_logic;
	acc_out_layer_4: out signed(15 downto 0)
);
end LAYER_4;

architecture behavior of LAYER_4 is
-- RAM input and control signals
signal rden_sys : std_logic := '1';
signal wren_sys : std_logic := '0';
signal count_W4 : std_logic_vector(19 downto 0);
signal w_out : std_logic_vector(15 downto 0);
-- math and acc signals
signal acc_out : std_logic_vector(31 downto 0);
signal mac_out : signed(31 downto 0);
-- constants and system resets
--constant period : TIME := 6 ns;
--output RAM Control signals
--constant reset_value : unsigned(9 downto 0) := to_unsigned(784,10);
--signal output_ram_address : unsigned(10 downto 0) := to_unsigned(0,11);
--signal rden_output : std_logic := '1';
--signal wren_output : std_logic := '1';
--signal q_layer_2_out : std_logic_vector(15 downto 0);

begin
acc_out_layer_4 <= signed(acc_out(31 downto 16));
-- CLK PROCESS
--clk_process : process
--	begin 
--	clk_sys <= '0';
--	wait for period/2;
--	clk_sys <= '1';
--	wait for period/2;
--end process;


--OUTPUT_RAM_ADDRESS_UPDATE: process
--	begin
--	wait for period;
--	if count_X = std_logic_vector(to_unsigned(2048,10)) then -- change value here based on cycles to calculate first output value
--		output_ram_address <= output_ram_address + 1;
--		rst_acc <= '1';
--	else
--		rst_acc <= '0'; 
--	end if;
--	
--end process;

-- RAM instantiation
--RAM_INPUT_FROM_LAYER_2 : entity work.X_INPUT_RAM 
--	port map(
--	address => count_X,
--	clock => clk_sys,
--	data => std_logic_vector(to_unsigned(0,16)),
--	rden => rden_sys,
--	wren => wren_sys,
--	q => x_out
--); 

RAM_INPUT_W4 : entity work.W_RAM_LAYER_4 
	port map(
	address => count_W4,
	clock => clk_sys,
	data => std_logic_vector(to_unsigned(0,16)),
	rden => rden_sys, -- 1
	wren => wren_sys, -- 0
	q => w_out
); 

 -- OUTPUT RAM  --
-- ******* IMPORTANT MAKE IT IN TOP FILE ****
--RAM_OUTPUT_LAYER_2 : entity work.RAM_OUTPUT 
--	port map(
--	address => std_logic_vector(output_ram_address),
--	clock => clk_sys,
--	data => acc_out(31 downto 16),
--	rden => rden_output,
--	wren => wren_output,
--	q => q_layer_2_out
--); 

-- Counter instantiation
--COUNTER_X : entity work.counter_X 
--port map(
--	clk => clk_sys,
--	rst => rst_sys,
--	count => count_X
--);


COUNTER_W3 : entity work.counter_W4 
port map(
	clk => clk_sys,
	rst => rst_sys,
	count => count_W4
);

-- multiply and add instantiation
MAC_unit_LAYER_3 : entity work.signed_multiplier_add_comb 
port map(
	a => signed(input_in_from_layer_3),
	b => signed(w_out),
	add_in => signed(acc_out),
	result => mac_out 
);

-- accumulator instantiation (just a flip flop)
ACC_unit_LAYER_3 : entity work.flip_flop_32bit 
port map(
	clk => clk_sys,
	reset => rst_acc,
	d => std_logic_vector(mac_out),
	q => acc_out
);

end behavior;
