library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_multiplier_add_comb is
    port (
        a   : in  signed(15 downto 0);  -- First 16-bit signed input
        b   : in  signed(15 downto 0);  -- Second 16-bit signed input
        add_in: in signed(31 downto 0); -- rolling addition input
	result : out signed(31 downto 0) -- 32-bit signed output for the multiplication result
    );
end entity signed_multiplier_add_comb;

architecture rtl of signed_multiplier_add_comb is
begin

    -- Combinational process to compute the product and rolling sum
    process (a,b,add_in)
    begin
        result <= (a * b) + add_in;
    end process;

end architecture rtl;
