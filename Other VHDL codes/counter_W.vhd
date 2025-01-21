library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_W1 is
    port (
        clk : in std_logic;
        rst : in std_logic;
	update_en: in std_logic;
        count : out std_logic_vector(20 downto 0)
    );
end counter_W1;

architecture behavior of counter_W1 is
    signal count_internal : unsigned(20 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count_internal <= (others => '0');
        elsif rising_edge(clk) then
	    if update_en = '1'then
            	count_internal <= count_internal + 1;
             end if;
	end if;
    end process;

    count <= std_logic_vector(count_internal);

end behavior;

