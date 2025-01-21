library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_OUT_LAYER_3 is
    port (
        clk : in std_logic;
        rst : in std_logic;
        update_en: in std_logic;
	count : out std_logic_vector(9 downto 0)
    );
end counter_OUT_LAYER_3;

architecture behavior of counter_OUT_LAYER_3 is
    signal count_internal : unsigned(9 downto 0) := (others => '0');
    constant reset_value : unsigned (9 downto 0) := to_unsigned(1023,10); -- change this value based on your resetting value.
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count_internal <= (others => '0');
        elsif rising_edge(clk) then
	    if update_en = '1' then	
		if count_internal = reset_value then 
			count_internal <= (others => '0');
	    	else
                	count_internal <= count_internal + 1; 
            	end if;
	    end if;	
	end if;
    end process;

    count <= std_logic_vector(count_internal);

end behavior;

