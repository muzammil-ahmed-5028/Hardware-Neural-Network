library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAC is 
port(
	a_in: in signed(15 downto 0);
	b_in: in signed(15 downto 0);
	mult_add_out: out signed(31 downto 0);
	ff_out: out signed(31 downto 0);
	clk: in std_logic;
	reset: in std_logic
);
end entity MAC;

architecture behavior of MAC is
signal ff2mult : std_logic_vector(31 downto 0);
signal mult2ff : signed(31 downto 0);

begin

mult_add_out <= mult2ff;
ff_out <= signed(ff2mult);

computational_unit: entity work.signed_multiplier_add_comb 
port map(
	a=> a_in,
	b => b_in,
	add_in => signed(ff2mult),
	result => mult2ff
);

ACC : entity work.flip_flop_32bit
port map(
	clk=> clk,
	reset => reset,
	d => std_logic_vector(mult2ff),
	q => ff2mult
);

end behavior;
