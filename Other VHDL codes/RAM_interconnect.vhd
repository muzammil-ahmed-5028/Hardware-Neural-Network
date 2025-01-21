LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RAM_interconnect IS
END RAM_interconnect;

ARCHITECTURE behavior OF tb_RAM_rw IS
    SIGNAL address_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Corrected typo: DONWTO to DOWNTO
    SIGNAL clk_tb : STD_LOGIC := '1';  -- Clock signal
    SIGNAL data_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Data input
    SIGNAL rden_tb : STD_LOGIC := '1';  -- Read enable signal
    SIGNAL wren_tb : STD_LOGIC := '1';  -- Write enable signal
    SIGNAL q_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Data output
    
    CONSTANT period : TIME := 10 ns;

BEGIN
    -- Component declaration for the RAM under test
    RAM_OUTPUT_LAYER_3 : entity work.RAM_OUTPUT_LAYER_3
    PORT MAP(
        address => address_tb,
        clock => clk_tb,
        data => data_tb,
        rden => rden_tb,
        wren => wren_tb,
	q => q_tb
    );

	
   
END behavior;
