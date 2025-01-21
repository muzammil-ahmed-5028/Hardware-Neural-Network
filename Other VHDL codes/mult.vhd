library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_multiplier_add_comb is
    port (
        a      : in  signed(15 downto 0);  -- First 16-bit signed input
        b      : in  signed(15 downto 0);  -- Second 16-bit signed input
        add_in : in  signed(31 downto 0);  -- Rolling addition input
        result : out signed(31 downto 0)   -- 32-bit signed output for the final result
    );
end entity signed_multiplier_add_comb;

architecture rtl of signed_multiplier_add_comb is
    -- Constants for 32-bit signed range
    constant MAX_S32 : signed(31 downto 0) := to_signed(2147483647, 32);
    constant MIN_S32 : signed(31 downto 0) := to_signed(-2147483648, 32);
begin

    -- Combinational process to compute the product and rolling sum
    process (a, b, add_in)
        variable prod       : signed(31 downto 0);
        variable temp_sum   : signed(32 downto 0);  -- 33-bit to capture intermediate values
    begin
        -- Calculate product (resulting in a 32-bit value)
        prod := resize(a * b, 32);

        -- Calculate temporary sum with 33-bit width to handle overflow
        temp_sum := resize(prod, 33) + resize(add_in, 33);

        -- Check for overflow and adjust result accordingly
        if temp_sum > MAX_S32 then
            result <= MAX_S32;
        elsif temp_sum < MIN_S32 then
            result <= MIN_S32;
        else
            result <= resize(temp_sum, 32);
        end if;
    end process;

end architecture rtl;

