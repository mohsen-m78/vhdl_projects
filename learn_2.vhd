library ieee;
use ieee.std_logic_1164.all;

entity Multiplexer is port(a,b,c,d,s0,s1 : in bit; x : out bit); end Multiplexer;

-------------------------------------------------------

architecture behavioural_1 of Multiplexer is

    --signal 

begin
    x <= a after 5 ns when s0 = '0' and s1 = '0' else
         b after 5 ns when s0 = '1' and s1 = '0' else
         c after 5 ns when s0 = '0' and s1 = '1' else
         d ;

end behavioural_1 ; -- behavioural_1

-------------------------------------------------------

architecture behavioural_2 of Multiplexer is

    signal choice : integer; 

begin

    with choice select 
        x <= a after 10 ns when 0,
             b after 10 ns when 1,
             c after 10 ns when 2,
             d after 10 ns when others; 

    choice <= 0 when s0 = '0' and s1 = '0' else
              1 when s0 = '1' and s1 = '0' else
              2 when s0 = '0' and s1 = '1' else
              3 ;

end behavioural_2 ; -- behavioural_2

