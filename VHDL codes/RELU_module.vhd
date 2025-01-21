library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity relu is
port (
	relu_IN: in signed(15 downto 0);
	count_in: in unsigned(31 downto 0);
	relu_OUT: out signed(15 downto 0)
	
);
end entity relu;

architecture behavior of relu is
constant end_L2_count: integer := 1607680;
constant end_L3_count: integer := 3705856;
constant end_L4_count: integer := 4230656;
constant end_L5_count: integer := 4235786;

constant L3_reset_value: integer := 2049;
constant L4_reset_value: integer := 1025;
constant L5_reset_value: integer := 513;
begin
RELU_DECISION: process(relu_IN,count_in)
begin
	if count_in > end_L2_count and count_in < end_L3_count then
		if (count_in - end_l2_count) mod L3_reset_value = 0 then
			relu_OUT <= to_signed(1,16);
		elsif relu_IN < 0 then
			relu_OUT <= to_signed(0,16);
		else
			relu_OUT <= relu_IN;
		end if;
		
	elsif count_in > end_L3_count and count_in < end_L4_count then
		if (count_in - end_l3_count) mod L4_reset_value = 0 then
			relu_OUT <= to_signed(1,16);
		elsif relu_IN < 0 then
			relu_OUT <= to_signed(0,16);
		else
			relu_OUT <= relu_IN;
		end if;
		
	elsif count_in > end_L4_count and count_in < end_L5_count then
		if (count_in - end_l4_count) mod L5_reset_value = 0 then
			relu_OUT <= to_signed(1,16);
		elsif relu_IN < 0 then
			relu_OUT <= to_signed(0,16);
		else
			relu_OUT <= relu_IN;
		end if;
	
	end if;

end process;

end architecture behavior;