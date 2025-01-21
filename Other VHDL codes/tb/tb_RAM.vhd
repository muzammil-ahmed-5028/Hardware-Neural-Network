LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_RAM IS
END tb_RAM;

ARCHITECTURE behavior OF tb_RAM IS
    SIGNAL address_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);  -- Corrected typo: DONWTO to DOWNTO
    SIGNAL clk_tb : STD_LOGIC := '1';  -- Clock signal
    SIGNAL data_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Data input
    SIGNAL rden_tb : STD_LOGIC := '1';  -- Read enable signal
    SIGNAL wren_tb : STD_LOGIC := '0';  -- Write enable signal
    SIGNAL q_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Data output
    
    CONSTANT period : TIME := 10 ns;

BEGIN
    -- Component declaration for the RAM under test
    uut : entity work.X_INPUT_RAM
    PORT MAP(
        address => address_tb,
        clock => clk_tb,
        data => data_tb,
        rden => rden_tb,
        wren => wren_tb,
	q => q_tb
    );

    -- Clock generation process
    Clk_process: PROCESS
    BEGIN
        clk_tb <= '1';
        WAIT FOR period/2;
        clk_tb <= '0';
        WAIT FOR period/2;
    END PROCESS;

    -- Stimulus process
    Stim_process: PROCESS
    BEGIN
        -- Data input changes
        address_tb <= "0000000000";  -- Example address input
        --data_tb <= "1111111101001001";
	WAIT FOR 50 ns;
	
        address_tb <= "0101101111";  -- Another example address input
        WAIT FOR 50 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;

