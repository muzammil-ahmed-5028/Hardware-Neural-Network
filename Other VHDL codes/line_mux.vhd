library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_16_2to1 is
port(
	a_in: in std_logic_vector(15 downto 0);
	b_in: in std_logic_vector(15 downto 0);
	sel: in std_logic;
	out_result: out std_logic_vector(15 downto 0)
);
end entity mux_16_2to1;

architecture syn of mux_16_2to1 is
signal result: std_logic_vector(15 downto 0);
begin
out_result <= result;
Selection_process: process(a_in,b_in,sel)
begin
	if sel = '0' then
		result <= a_in;
	elsif sel = '1' then
		result <= b_in;
	else 
		result <= std_logic_vector(to_unsigned(0,16));
	end if;
end process;
end syn;