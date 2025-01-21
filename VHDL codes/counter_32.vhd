library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_32 is
    port (
        clk : in std_logic;
        reset : in std_logic;
        update_en : in std_logic;  -- New input for update enable
        count_out : out std_logic_vector(31 downto 0)
    );
end entity counter_32;

architecture behavioral of counter_32 is
    signal count : unsigned(31 downto 0) := (others => '0');
begin
    process (clk, reset)
    begin
        if reset = '1' then
            count <= (others => '0');
        elsif rising_edge(clk) then
            if update_en = '1' then  -- Increment only if update_en is asserted
                count <= count + 1;
            end if;
        end if;
    end process;

    count_out <= std_logic_vector(count);
end architecture behavioral;
