library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LAYER_3 is
port(
	input_in_from_layer_2: in std_logic_vector(15 downto 0);
	clk_sys : in std_logic; 
	rst_sys: in std_logic;
	out_layer_3: out std_logic_vector(15 downto 0);
	start_computation: in std_logic
);
end LAYER_3;

architecture behavior of LAYER_3 is
-- RAM input and control signals
signal rden_sys : std_logic := '1';
signal wren_sys : std_logic := '0';
signal count_W3 : std_logic_vector(21 downto 0);
signal w_out : std_logic_vector(15 downto 0);
-- math and acc signals
signal acc_out : std_logic_vector(31 downto 0);
signal mac_out : signed(31 downto 0);
signal update_en_W3: std_logic;
signal input_after_RELU: std_logic_vector(15 downto 0);
signal update_en_OUT_RAM_COUNTER: std_logic := '0';
signal output_ram_address_3: std_logic_vector(9 downto 0);
-- values set for initially
signal wren_OUT_RAM: std_logic := '1';
signal rden_OUT_RAM: std_logic := '1';
signal internal_counter: std_logic_vector(11 downto 0);
signal rst_acc: std_logic := '0';

begin

input_after_RELU <= (others => '0') when signed(input_in_from_layer_2) < 0 else input_in_from_layer_2;


--UPDATE_OUTPUT_RAM_COUNTER: process
--begin
--	if start_computation = '1' and internal_counter = std_logic_vector(to_unsigned(2048,12)) then
--end process;

update_en_OUT_RAM_COUNTER <= '1' when (start_computation = '1' and internal_counter = std_logic_vector(to_unsigned(2048, 12))) else '0';

rst_acc_update: process(clk_sys)
begin
    if rising_edge(clk_sys) then
        if (start_computation = '1' and internal_counter = std_logic_vector(to_unsigned(0, 12))) then
            rst_acc <= '1';  -- Set rst_acc to '1' when condition is met
        else
            rst_acc <= '0';  -- Otherwise, set rst_acc to '0'
        end if;
    end if;
end process;

CHANGE_READ_WRITE: process (count_W3, start_computation)
begin
    if count_W3 >= std_logic_vector(to_unsigned(2098176, count_W3'length)) then
        update_en_W3 <= '0';
        wren_OUT_RAM <= '0';
        rden_OUT_RAM <= '1';
    else
        update_en_W3 <= start_computation;
        wren_OUT_RAM <= '1';
        rden_OUT_RAM <= '1';
    end if;
end process;

internal_count : entity work.counter_LAYER_3_internal 
port map(
	clk => clk_sys,
	rst => rst_sys,
	update_en => update_en_W3,
	count => internal_counter
);

RAM_INPUT_W3 : entity work.W_RAM_LAYER_3 
	port map(
	address => count_W3,
	clock => clk_sys,
	data => std_logic_vector(to_unsigned(0,16)),
	rden => rden_sys, -- 1
	wren => wren_sys, -- 0
	q => w_out
); 

COUNTER_W3 : entity work.counter_W3 
port map(
	clk => clk_sys,
	rst => rst_sys,
	count => count_W3,
	update_en => update_en_W3
);

-- multiply and add instantiation
MAC_unit_LAYER_3 : entity work.signed_multiplier_add_comb 
port map(
	a => signed(input_after_RELU),
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

COUNTER_RAM_OUTPUT_3: entity work.counter_OUT_LAYER_3 
port map(
	clk => clk_sys,
	rst => rst_sys,
	update_en => update_en_OUT_RAM_COUNTER,
	count => output_ram_address_3
);

RAM_OUTPUT_3: entity work.RAM_OUTPUT_LAYER_3
port map(
	address => output_ram_address_3,
	data => std_logic_vector(acc_out(31 downto 16)),
	clock => clk_sys,
	wren => wren_OUT_RAM,
	rden => rden_OUT_RAM,
	q => out_layer_3
);



end behavior;
