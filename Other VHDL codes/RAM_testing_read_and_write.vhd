LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_RAM_rw IS
END tb_RAM_rw;

ARCHITECTURE behavior OF tb_RAM_rw IS
    SIGNAL address_tb : STD_LOGIC_VECTOR(10 DOWNTO 0);  -- Corrected typo: DONWTO to DOWNTO
    SIGNAL clk_tb : STD_LOGIC := '1';  -- Clock signal
    SIGNAL data_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Data input
    SIGNAL rden_tb : STD_LOGIC := '1';  -- Read enable signal
    SIGNAL wren_tb : STD_LOGIC := '1';  -- Write enable signal
    SIGNAL q_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Data output
    
    CONSTANT period : TIME := 10 ns;

BEGIN
    -- Component declaration for the RAM under test
    uut : entity work.RAM_OUTPUT
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
        -- at this point wren and rden are 1
		-- can both read and Write
		-- write to current address the value in data and then also read it
		address_tb <= "00000000000";  -- Example address input
        data_tb <= "1111111101000001";
		WAIT FOR 20 ns;
		address_tb <= "00000000001";
        data_tb <= "1111111101001000";
		-- Another example address input
        WAIT FOR 10 ns;
		-- 
		wren_tb <= '0';
		address_tb <= "00000000000";
        
		WAIT FOR 10 ns;
		rden_tb <= '0';
		wren_tb <= '1';
		address_tb <= "00000000000";
	 	WAIT FOR 10 ns;
		address_tb <= "00000000000";
		rden_tb <= '1';
		WAIT FOR 10 ns;
		address_tb <= "00000000001";
		rden_tb <= '0';
		  
     		WAIT FOR 10 ns;
		address_tb <= "00000000001";
		rden_tb <= '1';
		-- End simulation
        WAIT;
    END PROCESS;

END behavior;
