library ieee;
use ieee.std_logic_1164.all;

entity mux_3to1 is
    port (
        -- Inputs
        in0, in1, in2 : in std_logic_vector(15 downto 0);
        sel : in std_logic_vector(1 downto 0);  -- Selection signal (2 bits)
        
        -- Output
        output : out std_logic_vector(15 downto 0)
    );
end entity mux_3to1;

architecture Behavioral of mux_3to1 is
begin
    process(sel, in0, in1, in2)
    begin
        case sel is
            when "00" =>
                output <= in0;
            when "01" =>
                output <= in1;
            when "10" =>
                output <= in2;
            when others =>
                output <= (others => '0');  -- Default case (optional): all zeros
        end case;
    end process;
end architecture Behavioral;
