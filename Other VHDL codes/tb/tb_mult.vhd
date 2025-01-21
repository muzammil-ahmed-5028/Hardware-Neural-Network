library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_signed_multiplier_add_comb is
end entity tb_signed_multiplier_add_comb;

architecture tb_arch of tb_signed_multiplier_add_comb is
    signal a, b  : signed(15 downto 0);    -- Inputs
    signal add_in : signed(31 downto 0);  -- Output result
    signal result : signed(31 downto 0);  -- Output result

begin

    -- Instantiate the signed_multiplier_comb module
    uut : entity work.signed_multiplier_add_comb
        port map (
            a => a,
            b => b,
	    add_in => add_in,
            result => result
        );

    -- Stimulus process
    process
    begin
        -- Test Case 1: Multiply 5 * 3
        a <= to_signed(5, 16);
        b <= to_signed(3, 16);
	add_in <= to_signed(78,32);
        wait for 10 ns;
        
        -- Test Case 2: Multiply -8 * 2
        a <= to_signed(-8, 16);
        b <= to_signed(2, 16);
        add_in <= to_signed(40,32);
	wait for 10 ns;
        
        -- Test Case 3: Multiply 7 * -4
        a <= to_signed(7, 16);
        b <= to_signed(-4, 16);
        add_in <= to_signed(-888,32);
	wait for 10 ns;
        
        -- Test Case 4: Multiply -6 * -5
        a <= to_signed(-6, 16);
        b <= to_signed(-5, 16);
        add_in <= to_signed(-30,32);
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;

end architecture tb_arch;

