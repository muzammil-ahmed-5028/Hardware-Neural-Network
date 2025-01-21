LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY flip_flop_32bit IS
PORT (
    clk : IN STD_LOGIC;        -- Clock input
    reset : IN STD_LOGIC;      -- Reset input
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Data input (32 bits)
    q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)  -- Data output (32 bits)
);
END flip_flop_32bit;

ARCHITECTURE behavior OF flip_flop_32bit IS
SIGNAL ff_internal : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Internal signal for flip-flop storage
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN    -- Reset condition
            ff_internal <= (OTHERS => '0');  -- Reset all flip-flops to '0'
        ELSIF (clk'EVENT AND clk = '1') THEN  -- Clock edge condition
            ff_internal <= d;  -- Update flip-flops with input data on rising edge of clock
        END IF;
    END PROCESS;

    q <= ff_internal;  -- Output the stored data
END behavior;
