library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_LAYER_2_OUTPUT is
    port (
        clk : in std_logic;
        rst : in std_logic;
	update_en: in std_logic;
        count : out std_logic_vector(10 downto 0)
    );
end counter_LAYER_2_OUTPUT;

architecture behavior of counter_LAYER_2_OUTPUT is
    signal count_internal : unsigned(10 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count_internal <= (others => '0');
        elsif rising_edge(clk) then
            if update_en = '1' then
		count_internal <= count_internal + 1;
	    end if;
        end if;
    end process;
count <= std_logic_vector(count_internal);

end behavior;

