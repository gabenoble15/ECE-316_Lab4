<<<<<<< HEAD
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
=======
library ieee;
use ieee.std_logic_1164.all; --libraries

Entity Register8 is  --Entity declaration
Port(Inp : in std_logic_vector(7 downto 0); --declare ports, and specify interface, notice here that the ; is used as seperator
Load, Clk : in std_logic;
Outp : out std_logic_vector(7 downto 0)); end Register8;


Architecture behav of Register8 is  --architecture declaration, multiple architecture can be associated to one entity
Signal storage : std_logic_vector(7 downto 0); begin
process(Inp, Load, Clk) begin
if (Clk'event and Clk = '1') then 
Outp <= storage;
elsif (Clk'event and Clk = '0' and Load = '0') then 
storage <= Inp;
end if; 
end process;
end;


>>>>>>> e1e433fc843ed3b0bb1c69d0389b74099d5acd6c
