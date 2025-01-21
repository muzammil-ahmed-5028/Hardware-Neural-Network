library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_X_tb is
end counter_X_tb;

architecture behavior of counter_X_tb is
signal clk_tb : std_logic := '0';
signal rst_tb : std_logic := '1';
signal count_out : std_logic_vector(9 downto 0);
constant period : TIME := 10 ns;

begin

 Clk_process :process
  	begin
   	clk_tb <= '0';
    	wait for period/2;
   	clk_tb <= '1';
    	wait for period/2;

end process;    

uut: entity work.counter_X port map(
	clk => clk_tb,
	rst => rst_tb,
	count => count_out
);

process begin
	rst_tb <= '1';
	wait for 10 ns;
	rst_tb <= '0';
	wait;
end process;
end behavior;
