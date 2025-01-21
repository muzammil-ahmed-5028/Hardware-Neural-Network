LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ROM_test_tb IS
END ROM_test_tb;

ARCHITECTURE behavior OF ROM_test_tb IS

    -- Constants
    CONSTANT CLOCK_PERIOD : TIME := 10 ns; -- Clock period in nanoseconds

    -- Signals for ROM_test entity
    SIGNAL clock_tb : STD_LOGIC := '0';
    SIGNAL address_tb : STD_LOGIC_VECTOR(9 DOWNTO 0) := (others => '0');
    SIGNAL q_tb : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- Instantiate the ROM_test entity
    uut : ENTITY work.ROM_test
        PORT MAP (
            address => address_tb,
            clock => clock_tb,
            q => q_tb
        );

    -- Clock process
    clock_process : PROCESS
    BEGIN
        while now < 1000 ns loop
            clock_tb <= '0';
            wait for CLOCK_PERIOD / 2;
            clock_tb <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    END PROCESS clock_process;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Initialize the address and wait for stable clock
        address_tb <= (others => '0');
        wait for CLOCK_PERIOD * 2;

        -- Read first 5 values from ROM
        for i in 0 to 4 loop
            address_tb <= std_logic_vector(to_unsigned(i, address_tb'length));
            wait for CLOCK_PERIOD;
        end loop;

        -- End simulation
        wait;
    END PROCESS stimulus_process;

END behavior;

