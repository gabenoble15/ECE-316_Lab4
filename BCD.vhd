library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCDconverter is
    port (
        Din : in  std_logic_vector(19 downto 0);
        Do1 : out std_logic_vector(3 downto 0);
        Do2 : out std_logic_vector(3 downto 0);
        Do3 : out std_logic_vector(3 downto 0);
        Do4 : out std_logic_vector(3 downto 0);
        Do5 : out std_logic_vector(3 downto 0);
        Do6 : out std_logic_vector(3 downto 0)
    );
end BCDconverter;

architecture behavioral of BCDconverter is
begin
    process(Din)
        variable bcd : unsigned(23 downto 0);
        variable bin : unsigned(19 downto 0);
        variable i   : integer;
    begin
        bcd := (others => '0');
        bin := unsigned(Din);

        for i in 19 downto 0 loop
            if bcd(3 downto 0) > 4 then
                bcd(3 downto 0) := bcd(3 downto 0) + 3;
            end if;

            if bcd(7 downto 4) > 4 then
                bcd(7 downto 4) := bcd(7 downto 4) + 3;
            end if;

            if bcd(11 downto 8) > 4 then
                bcd(11 downto 8) := bcd(11 downto 8) + 3;
            end if;

            if bcd(15 downto 12) > 4 then
                bcd(15 downto 12) := bcd(15 downto 12) + 3;
            end if;

            if bcd(19 downto 16) > 4 then
                bcd(19 downto 16) := bcd(19 downto 16) + 3;
            end if;

            if bcd(23 downto 20) > 4 then
                bcd(23 downto 20) := bcd(23 downto 20) + 3;
            end if;

            bcd := bcd(22 downto 0) & bin(i);
        end loop;

        Do1 <= std_logic_vector(bcd(3 downto 0));
        Do2 <= std_logic_vector(bcd(7 downto 4));
        Do3 <= std_logic_vector(bcd(11 downto 8));
        Do4 <= std_logic_vector(bcd(15 downto 12));
        Do5 <= std_logic_vector(bcd(19 downto 16));
        Do6 <= std_logic_vector(bcd(23 downto 20));
    end process;
end behavioral;

