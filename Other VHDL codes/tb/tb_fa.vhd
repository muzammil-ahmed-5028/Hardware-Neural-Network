LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_fa IS
-- No ports needed as we instantiate the fa entity directly
END ENTITY tb_fa;

ARCHITECTURE tb_arch OF tb_fa IS

    -- Component declaration for the fa entity
    COMPONENT fa
    PORT (
        a, b, cin: IN  BIT;
        sum, cout: OUT BIT
    );
    END COMPONENT;

    -- Signals for testbench
    SIGNAL a_tb, b_tb, cin_tb: BIT;
    SIGNAL sum_tb, cout_tb: BIT;

BEGIN

    -- Instantiate the fa entity
    uut: fa PORT MAP (
        a => a_tb,
        b => b_tb,
        cin => cin_tb,
        sum => sum_tb,
        cout => cout_tb
    );

    -- Stimulus process
    stimulus_proc: PROCESS
    BEGIN
        -- Test case 1: a = '0', b = '0', cin = '0'
        a_tb <= '0';
        b_tb <= '0';
        cin_tb <= '0';
        WAIT FOR 10 ns;
        
        -- Test case 2: a = '1', b = '0', cin = '1'
        a_tb <= '1';
        b_tb <= '0';
        cin_tb <= '1';
        WAIT FOR 10 ns;
        
        -- Test case 3: a = '1', b = '1', cin = '0'
        a_tb <= '1';
        b_tb <= '1';
        cin_tb <= '0';
        WAIT FOR 10 ns;
        
        -- Test case 4: a = '1', b = '1', cin = '1'
        a_tb <= '1';
        b_tb <= '1';
        cin_tb <= '1';
        WAIT FOR 10 ns;
        
        -- End simulation
        WAIT;
    END PROCESS stimulus_proc;

END ARCHITECTURE tb_arch;
