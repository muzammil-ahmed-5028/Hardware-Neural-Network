LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench_flip_flop_32bit IS
END testbench_flip_flop_32bit;

ARCHITECTURE behavior OF testbench_flip_flop_32bit IS
    SIGNAL clk_tb : STD_LOGIC := '0';  -- Clock signal
    SIGNAL reset_tb : STD_LOGIC := '0';  -- Reset signal
    SIGNAL d_tb : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');  -- Data input
    SIGNAL q_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Data output
    CONSTANT period : TIME := 10 ns;

-- Component declaration for the flip-flop under test
    BEGIN
    uut : entity work.flip_flop_32bit
    PORT MAP(
        clk => clk_tb,
        reset => reset_tb,
        d => d_tb,
        q => q_tb
    );
    
 -- Stimulus and clock process
    Clk_process :process
  	begin
   	clk_tb <= '0';
    	wait for period/2;
   	clk_tb <= '1';
    	wait for period/2;

	end process;    

    PROCESS
    BEGIN

	-- Reset assertion
        reset_tb <= '1';
        WAIT FOR 10 ns;
        reset_tb <= '0';

        -- Data input changes
        d_tb <= "01010101010101010101010101010101";  -- Example data input
        WAIT FOR 50 ns;

        d_tb <= "10101010101010101010101010101010";  -- Another example data input
        WAIT FOR 50 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;
