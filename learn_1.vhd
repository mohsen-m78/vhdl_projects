-- Std_logic is a subtype of std_ulogic and has exactly one extra property: it's resolved if there are multiple drivers.
-- std_ulogic has 9 values but bit has 2.

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY mux4 IS
    PORT ( i0, i1, i2, i3, a, b : IN std_logic; q : OUT std_logic);
END mux4;

ARCHITECTURE mux4_behave OF mux4 IS
    SIGNAL sel: INTEGER;
    
    BEGIN
        -- Selected signal assignment
        WITH sel SELECT
        q <= i0 AFTER 10 ns WHEN 0,
             i1 AFTER 10 ns WHEN 1,
             i2 AFTER 10 ns WHEN 2,
             i3 AFTER 10 ns WHEN 3,
             'X' AFTER 10 ns WHEN OTHERS;     -- 'OTHERS' is like 'ELSE'

        -- Conditional signal assignment
        sel <= 0 WHEN a = '0' AND b = '0' ELSE
        1 WHEN a = '1' AND b = '0' ELSE
        2 WHEN a = '0' AND b = '1' ELSE
        3 WHEN a = '1' AND b = '1' ELSE
        4 ;

END mux4_behave;
