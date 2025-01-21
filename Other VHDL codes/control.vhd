library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
port (
	-- addresses
	x_ram_address: out std_logic_vector(9 downto 0);
	w2_ram_address: out std_logic_vector(20 downto 0);
	L2_ram_address: out std_logic_vector(10 downto 0);
	-- L3 ram addresses
	w3_ram_address: out std_logic_vector(21 downto 0);
	L3_ram_address: out std_logic_vector(9 downto 0);
	-- L4 ram addresses
	w4_ram_address: out std_logic_vector(19 downto 0);
	L4_ram_address: out std_logic_vector(8 downto 0);
	-- L5 ram addresses
	w5_ram_address: out std_logic_vector(12 downto 0);
	L5_ram_address: out std_logic_vector(3 downto 0);
	
	-- w/r controls
	L2_rden: out std_logic;
	L2_wren: out std_logic;
	----L3 ram control signals
	L3_rden: out std_logic;
	L3_wren: out std_logic;
	----L4 ram control signals
	L4_rden: out std_logic;
	L4_wren: out std_logic;
	---- L5 ram control signals
	L5_rden: out std_logic;
	L5_wren: out std_logic;
	
	-- input from counter
	count_in: in unsigned(31 downto 0);
	-- rst for MAC
	rst_mac_2: out std_logic;
	rst_mac_3: out std_logic;
	rst_mac_4: out std_logic;
	rst_mac_5: out std_logic;
	
	-- reset for start_L2
	start_L2: in std_logic
	
	-- constants
);
end control;

architecture behavior of control is
signal w2_address : unsigned(20 downto 0) := to_unsigned(0,21);
signal x_address : unsigned(9 downto 0) := to_unsigned(0,10);
signal L2_address : unsigned(10 downto 0) := to_unsigned(0,11);
signal w3_address : unsigned(21 downto 0) := to_unsigned(0,22);
signal L3_address : unsigned(9 downto 0) := to_unsigned(0,10);
signal w4_address : unsigned(19 downto 0) := to_unsigned(0,20);
signal L4_address : unsigned(8 downto 0) := to_unsigned(0,9);
signal w5_address : unsigned(12 downto 0) := to_unsigned(0,13);
signal L5_address : unsigned(3 downto 0) := to_unsigned(0,4);

constant end_L2_count: integer := 1607680;
constant end_L3_count: integer := 3705856;-- change these +1 and -1 for different results
constant end_L4_count: integer := 4230655;
constant end_L5_count: integer := 4235786;
constant L2_x_reset_value : integer := 785;
constant L2_ram_total_entries: integer := 2048;
constant L3_ram_total_entries: integer := 1024;
constant L4_ram_total_entries: integer := 512;

constant L3_neuron_count_end: integer := 2049; ---
constant L4_neuron_count_end: integer := 1025; -- change due to problems 
constant L5_neuron_count_end: integer := 513;

begin

w2_ram_address <= std_logic_vector(w2_address);
x_ram_address <= std_logic_vector(x_address);
L2_ram_address <= std_logic_vector(L2_address);
L3_ram_address <= std_logic_vector(L3_address);
w3_ram_address <= std_logic_vector(w3_address);
L4_ram_address <= std_logic_vector(L4_address);
w4_ram_address <= std_logic_vector(w4_address);
L5_ram_address <= std_logic_vector(L5_address);
w5_ram_address <= std_logic_vector(w5_address);

-- setting rdens
L2_rden <= '1';
L3_rden <= '1';
L4_rden <= '1';
L5_rden <= '1';

read_write_update: process (count_in)
begin
	if count_in > (end_L2_count-1) and count_in < (end_L3_count-1) then
		L2_wren <= '0';
		L3_wren <= '1';
		L4_wren <= '0';
		L5_wren <= '0';
	elsif count_in >= (end_L3_count-1) and count_in < (end_L4_count-1) then
		L2_wren <= '0';
		L3_wren <= '0';
		L4_wren <= '1';
		L5_wren <= '0';
	elsif count_in > (end_L4_count-1) then
		L2_wren <= '0';
		L3_wren <= '0';
		L4_wren <= '0';
		L5_wren <= '1';
	else 
		L5_wren <= '0';
		L4_wren <= '0';
		L3_wren <= '0';
		L2_wren <= '1';
	end if;
end process;


address_update: process(count_in,start_L2)
begin
	if start_L2 = '1' and count_in < end_L2_count then
		if count_in mod L2_x_reset_value = 0 and count_in /= 0 then	
			x_address <= (others => '0');
			L2_address<= L2_address + 1;
			rst_mac_2 <= '1';
			w2_address <= w2_address + 1;
		--elsif count_in mod L2_x_reset_value =  and count_in /= 0 then
			--x_address <= x_address +1;
			--w2_address <= w2_address + 1;
			--rst_mac_2 <= '1';
			
		else 
			x_address <= x_address +1;
			w2_address <= w2_address + 1;
			rst_mac_2 <= '0';
			
		end if;
	-- LAYER_3_computations
	elsif count_in > end_L2_count and count_in < end_L3_count then
		rst_mac_2 <= '0';
		
		if (count_in - end_L2_count) mod L3_neuron_count_end = 0 and (count_in - end_L2_count) /= 0 then
 			w3_address <= w3_address +1;
			L2_address <= L2_address +1;
			L3_address <= L3_address +1;
			rst_mac_3 <= '1';
		elsif (count_in - end_L2_count) mod L3_neuron_count_end = L2_ram_total_entries and (count_in - end_L2_count) /= 0 then 
			L2_address <= L2_address;
			rst_mac_3 <= '0';
			L3_address <= L3_address;
			w3_address <= w3_address + 1;
		else 
			w3_address <= w3_address +1;
			L2_address <= L2_address +1;
			rst_mac_3 <= '0';
		end if;
	-- Layer_4 computations
	elsif count_in > end_L3_count and count_in < end_L4_count then
		rst_mac_3 <= '0';
		-- add b value case
		-- here w4 and l3 addresses are similar to 
		if (count_in - end_L3_count) mod L4_neuron_count_end = 0 and (count_in - end_L3_count) /= 0 then
 			w4_address <= w4_address +1;
			L3_address <= L3_address +1;
			L4_address <= L4_address +1;
			rst_mac_4 <= '1';
		-- rst state
		elsif (count_in - end_L3_count) mod L4_neuron_count_end = L3_ram_total_entries and (count_in - end_L3_count) /= 0 then 
			L3_address <= L3_address;
			rst_mac_4 <= '0';
			L4_address <= L4_address;
			w4_address <= w4_address + 1;
		-- normal case
		else 
			w4_address <= w4_address +1;
			L3_address <= L3_address +1;
			rst_mac_4 <= '0';
		end if;
	-- Layer 5 computations
	elsif count_in > end_L4_count then
		rst_mac_4 <= '0';
		
		if (count_in - end_L4_count) mod L5_neuron_count_end = 0 and (count_in - end_L3_count) /= 0 then
 			w5_address <= w5_address +1;
			L4_address <= L4_address +1;
			L5_address <= L5_address +1;
			rst_mac_5 <= '1';
		-- rst state
		-- end of prev layer ram
		elsif (count_in - end_L3_count) mod L5_neuron_count_end = L4_ram_total_entries and (count_in - end_L3_count) /= 0 then 
			L4_address <= L4_address;
			rst_mac_5 <= '0';
			L5_address <= L5_address;
			w5_address <= w5_address + 1;
		-- normal case
		else 
			w5_address <= w5_address +1;
			L4_address <= L4_address +1;
			rst_mac_5 <= '0';
		end if;
	
	
	else 
		rst_mac_2 <= '1';
		rst_mac_3 <= '1';
		rst_mac_4 <= '1';
		rst_mac_5 <= '1';
		x_address <= (others => '0');
		L2_address <= (others => '0');
		w2_address <= (others => '0');
		w3_address <= (others => '0');
		L3_address <= (others => '0'); 
		w4_address <= (others => '0');
		L4_address <= (others => '0'); 
		w5_address <= (others => '0');
		L5_address <= (others => '0'); 
	end if;
end process;

end behavior;