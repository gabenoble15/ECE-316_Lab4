library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity ACC is  
	Port(	
		clk     : in  std_logic;
        	Load    : in  std_logic;
        	Add     : in  std_logic;
        	Shift4  : in  std_logic;

        	A_reg   : in  std_logic_vector(15 downto 0);
        	SUM     : in  std_logic_vector(7 downto 0);

        	ACC_out : out std_logic_vector(23 downto 0)
	); 
end ACC;

Architecture behavior of ACC is
signal ACC_reg : std_logic_vector(23 downto 0) := (others => '0');
begin
 process(clk)
  begin
    if rising_edge(clk) then
      if Load = '1' then
        ACC_reg(23 downto 16) <= (others => '0');
        ACC_reg(15 downto 0)  <= A_reg;

      elsif Add = '1' then
        ACC_reg(23 downto 16) <= SUM;

      elsif Shift4 = '1' then
        ACC_reg <= "0000" & ACC_reg(23 downto 4);

      else
        -- hold
        null;
      end if;
    end if;
  end process;

  ACC_out <= ACC_reg;
end architecture behavior;