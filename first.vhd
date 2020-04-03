entity mux is port(a,b,c,d : in bit ; s0,s1 : in bit ; x,y : out bit);  end mux;
------------------------------------------------------------------
-- Behavioural description
architecture dataflow of mux is

    signal sel : integer;     -- create some intermediate value called SEL
-- Concurrent Statements    >>    execute only one or more signals on the right hand side of " <= " changes.....
begin
    sel <= 0 when s0 = '0' and s1 = '0' else
           1 when s0 = '0' and s1 = '1' else
           2 when s0 = '1' and s1 = '0' else
           3;

    x <= a after 0.5 ns when sel = 0   else     
         b after 0.5 ns when sel = 1   else
         c after 0.5 ns when sel = 2   else
         d after 0.5 ns;

    y <= a and b;    -- ????????

end dataflow ; -- dataflow
------------------------------------------------------------------
-- Structural description
ARCHITECTURE netlist OF mux IS

    COMPONENT andgate
        PORT(a, b, c : IN bit; x : OUT BIT);
    END COMPONENT;

    COMPONENT inverter
        PORT(in1 : IN BIT; x : OUT BIT);
    END COMPONENT;

    COMPONENT orgate
        PORT(a, b, c, d : IN bit; x : OUT BIT);
    END COMPONENT;

    SIGNAL s0_inv, s1_inv, x1, x2, x3, x4 : BIT;

    BEGIN
        E1 : inverter port map (s0, s0_inv);
        E2 : inverter port map (s1, s1_inv);
        E3 : andgate port map (a, s0_inv, s1_inv, x1);
        E4 : andgate port map (b, s0, s1_inv, x2);
        E5 : andgate port map (c, s0_inv, s1, x3);
        E6 : andgate port map (d, s0, s1, x4);
        E7 : orgate port map (x1, x2, x3, x4, x);

END netlist;
------------------------------------------------------------------
-- Sequential description
ARCHITECTURE sequential OF mux IS 
BEGIN

    my_process : PROCESS(a, b, c, d, s0, s1 )   -- Sensitivity list
    
    VARIABLE sel : INTEGER;
    
    BEGIN
        IF  s0 = '0' and s1 = '0' THEN sel := 0;
            ELSIF s0 = '1' and s1 = '0' THEN sel := 1;
            ELSIF s0 = '0' and s1 = '0' THEN sel := 2;
            ELSE sel := 3;
        END IF;

        CASE sel IS
            WHEN 0 => x <= a;
            WHEN 1 => x <= b;
            WHEN 2 => x <= c;
            WHEN OTHERS => x <= d;
        END CASE;

    END PROCESS;

END sequential;
------------------------------------------------------------------
-- Configuration
CONFIGURATION muxcon1 OF mux IS
    
    FOR netlist
        -- use entity inverter, architecture version1 from work library to instanciate E1 and E2.....
        FOR E1,E2 : inverter USE ENTITY WORK.myinv(version1);
        END FOR;

        FOR E3,E4,E5,E6 : andgate USE ENTITY WORK.myand(version1);
        END FOR;

        FOR E7 : orgate USE ENTITY WORK.myor(version1);
        END FOR;
    END FOR;

END muxcon1;

-- Some points : ENTITY mux has some ARCHITECTURES . every COMPONENT in ARCHITECTURE netlist are ENTITIES themselves
--               and can have some ENTITIES for their implementation .
--             >>>> all the implemetations of all entities and components are done by declaring CONFIGURATION .
------------------------------------------------------------------
-- Configuration
CONFIGURATION muxcon2 OF mux IS
    FOR dataflow
    END FOR;
END muxcon2;

-- In behavioural description of an entity we use SIGNAL ASSIGNMENTS
-- In sequential description of an entity we use PROCESS STATEMENTS

------------------------------------------------------------------


