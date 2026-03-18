library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Controller is
  port (
    clk    : in  std_logic;
    reset  : in  std_logic;   
    start  : in  std_logic;

    Load   : out std_logic;
    Add    : out std_logic;
    Shift4 : out std_logic;
    Done   : out std_logic
  );
end entity;

architecture behav of Controller is
	type state_type is (IDLE, LOAD_S, ADD_S, SHIFT_S, DONE_S);
 	signal current_state, next_state : state_type;
	signal count : unsigned(1 downto 0) := (others => '0');
begin

	process(clk, reset)
	begin
  	if reset='0' then
    		current_state <= IDLE;
    		count <= "00";
  	elsif rising_edge(clk) then
    		current_state <= next_state;
    		if current_state = LOAD_S then
      			count <= "00";              
    		elsif current_state = SHIFT_S then
      			count <= count + 1;         
    		end if;

  	end if;
	end process;

	process(current_state, start, count)
  	begin
    	next_state <= current_state; 
    	case current_state is
      		when IDLE =>
        	if start = '1' then
          		next_state <= LOAD_S;  
        	else
          	next_state <= IDLE;
        	end if;
		when LOAD_S =>
			next_state <= ADD_S;
		when ADD_S =>
			next_state <= SHIFT_S;
		when SHIFT_S =>
			if count = "11" then
				next_state <= DONE_S;
			else
				next_state <= ADD_S;
			end if; 
		when DONE_S =>
  			next_state <= DONE_S;
		when others =>
  			next_state <= IDLE;
	end case;
	end process; 

	process(next_state)
	begin
  		Load   <= '0';
  		Add    <= '0';
  		Shift4 <= '0';
  		Done   <= '0';
  	case next_state is
    		when LOAD_S  => Load   <= '1';
    		when ADD_S   => Add    <= '1';
    		when SHIFT_S => Shift4 <= '1';
    		when DONE_S  => Done   <= '1';
    		when others  => null;
  	end case;
	end process;
	end behav; 