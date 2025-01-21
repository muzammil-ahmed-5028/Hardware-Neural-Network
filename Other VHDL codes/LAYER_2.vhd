library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LAYER_2 is
--	port(
--	begin_LAYER_3: out std_logic;
--	layer_output: out std_logic_vector(15 downto 0)
--);
end LAYER_2;

architecture behavior of LAYER_2 is

signal rden_sys : std_logic := '1';
signal wren_sys : std_logic := '0';
signal count_X : std_logic_vector(9 downto 0);
signal count_W1 : std_logic_vector(20 downto 0);
signal x_out : std_logic_vector(15 downto 0);
signal w_out : std_logic_vector(15 downto 0);
signal acc_out : std_logic_vector(31 downto 0);
signal mac_out : signed(31 downto 0);
constant period : TIME := 6 ns;
signal clk_sys : std_logic; 
signal rst_sys: std_logic;
signal rst_acc: std_logic := '1';
constant reset_value : unsigned(9 downto 0) := to_unsigned(784,10);
signal output_ram_address : std_logic_vector(10 downto 0);
signal rden_output : std_logic := '1';
signal wren_output : std_logic := '1';
signal q_layer_2_out : std_logic_vector(15 downto 0);
signal one : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(1,16));
signal zero : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(0,16));
signal sel_mux : std_logic_vector(1 downto 0) := std_logic_vector(to_unsigned(2,2));
signal mux_out : std_logic_vector(15 downto 0);
signal update_en_OUTPUT_RAM: std_logic;
signal start_LAYER_3: std_logic := '0';
signal update_en_X: std_logic := '1'; 
signal update_en_W1: std_logic := '1'; 
signal layer_3_output: std_logic_vector(15 downto 0);
signal layer_2_output: std_logic_vector(15 downto 0);
begin
-- CLK PROCESS

clk_process : process
	begin 
	clk_sys <= '0';
	wait for period/2;
	clk_sys <= '1';
	wait for period/2;
end process;


OUTPUT_RAM_ADDRESS_UPDATE_OUTPUT_SELECT: process
	begin
	wait for period;
	if start_LAYER_3 = '1' then
		if output_ram_address = std_logic_vector(to_unsigned(2047,11)) then
			update_en_OUTPUT_RAM <= '0';
			layer_2_output <= q_layer_2_out;
			wait for period;
			layer_2_output <= q_layer_2_out;
			update_en_OUTPUT_RAM <= '1';
			wait for period;
			layer_2_output <= std_logic_vector(to_unsigned(1,16));
			
		else
			update_en_OUTPUT_RAM <= '1';
			layer_2_output <= q_layer_2_out;
		end if;
	else
		if (count_X = std_logic_vector(to_unsigned(784,10))) or (count_W1 = std_logic_vector(to_unsigned(1607680,21))) then
			update_en_OUTPUT_RAM <= '1';
			layer_2_output <= q_layer_2_out;
		else
			update_en_OUTPUT_RAM <= '0';
			layer_2_output <= q_layer_2_out;
		end if;
	end if;
end process;

RESET_ACCUMULATOR: process
	begin
	wait for period;
	if count_X = std_logic_vector(to_unsigned(784,10)) then
		wait for period/2;
		rst_acc <= '1';
	else
		rst_acc <= '0';
	end if;
end process;

CHECKING_SUB_PROCESS : process
	begin
	wait for 9646083 ns;
	-- at this point the values in the ram are saved to the desired outputs
	wren_output <= '0';
	sel_mux <= "10";
	start_LAYER_3 <= '1';
end process;

-- RAM instantiation
RAM_INPUT_X : entity work.X_INPUT_RAM 
	port map(
	address => count_X,
	clock => clk_sys,
	data => std_logic_vector(to_unsigned(0,16)),
	rden => rden_sys,
	wren => wren_sys,
	q => x_out
); 

RAM_INPUT_W : entity work.W_RAM_LAYER_2 
	port map(
	address => count_W1,
	clock => clk_sys,
	data => std_logic_vector(to_unsigned(0,16)),
	rden => rden_sys,
	wren => wren_sys,
	q => w_out
); 

-- Counter instantiation
COUNTER_X : entity work.counter_X 
port map(
	clk => clk_sys,
	rst => rst_sys,
	count => count_X,
	update_en => update_en_X
);


COUNTER_W : entity work.counter_W1 
port map(
	clk => clk_sys,
	rst => rst_sys,
	count => count_W1,
	update_en => update_en_W1

);

-- multiply and add instantiation
MAC_unit : entity work.signed_multiplier_add_comb 
port map(
	a => signed(x_out),
	b => signed(w_out),
	add_in => signed(acc_out),
	result => mac_out 
);

-- accumulator instantiation (just a flip flop)
ACC_unit : entity work.flip_flop_32bit 
port map(
	clk => clk_sys,
	reset => rst_acc,
	d => std_logic_vector(mac_out),
	q => acc_out
);
mux2ram_output : entity work.mux_3to1 
port map(
	in0 => zero,
	in1 => one,
	in2 => acc_out(31 downto 16),
	sel => sel_mux,
	output => mux_out
);
-- OUTPUT_RAM

RAM_OUTPUT_LAYER_2 : entity work.RAM_OUTPUT 
	port map(
	address => output_ram_address,
	clock => clk_sys,
	data =>mux_out,
	rden => rden_output,
	wren => wren_output,
	q => q_layer_2_out
); 

COUNTER_RAM_OUTPUT_LAYER_2 : entity work.counter_LAYER_2_OUTPUT
	port map(
	count => output_ram_address,
	clk => clk_sys,
	rst => rst_sys,
	update_en => update_en_OUTPUT_RAM
);

LAYER_3 : entity work.LAYER_3
port map(
	input_in_from_layer_2 => layer_2_output,
	clk_sys => clk_sys,
	rst_sys => rst_sys,
	start_computation => start_LAYER_3,
	out_LAYER_3 => layer_3_output 
);
	
process begin

	rst_sys <= '1';
	wait for 6 ns;
	rst_sys <= '0';
	wait for 9646080 ns;
	rst_sys <= '1';
	wait for 6 ns;
	rst_sys <= '0';
	wait;
	
end process;
end behavior;
-- remember this value 9,646,080
