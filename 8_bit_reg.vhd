

library ieee;
use ieee.std_logic_1164.all; --libraries

Entity Register8 is  --Entity declaration
Port(Inp : in std_logic_vector(7 downto 0); --declare ports, and specify interface, notice here that the ; is used as seperator
Load, Clk : in std_logic;
Outp : out std_logic_vector(7 downto 0)); end Register8;



architecture behav of Register8 is
signal storage : std_logic_vector(7 downto 0);
begin

process(Clk)
begin
    if rising_edge(Clk) then
        if Load = '1' then
            storage <= Inp;
        end if;
    end if;
end process;

Outp <= storage;

end behav;



