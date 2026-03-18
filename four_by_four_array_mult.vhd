library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


Entity ArrayMult is  
	Port(	X, Y : in std_logic_vector(3 downto 0); 
		Outp : out std_logic_vector(7 downto 0)
	); 
end ArrayMult;

Architecture struct of ArrayMult is

signal t1 : std_logic_vector(6 downto 0);
signal t2: std_logic_vector(3 downto 0);
signal t3: std_logic_vector(3 downto 0);
signal carry1 : std_logic_vector(3 downto 0); 
signal carry2: std_logic_vector(3 downto 0);
signal carry3: std_logic_vector(3 downto 0);
signal sum1 : std_logic_vector(3 downto 0); 
signal sum2: std_logic_vector(3 downto 0);
signal sum3: std_logic_vector(3 downto 0);

begin 

Outp(0) <= X(0) and Y(0);  ---LSB of output

t1(0) <= X(1) and Y(0);
t1(1) <= X(0) and Y(1);
sum1(0) <= t1(0) xor t1(1); ----Outp(1)
Outp(1) <= sum1(0); 
carry1(0) <= t1(0) and t1(1); ---carry -> cin for the next


t1(2) <= X(2) and Y(0);
t1(3) <= X(1) and Y(1);
sum1(1) <= t1(2) xor t1(3) xor carry1(0); --- S11
carry1(1) <= (t1(2) and t1(3)) or (carry1(0) and (t1(2) xor t1(3)));



t1(4) <= X(3) and Y(0);
t1(5) <= X(2) and Y(1);
sum1(2) <= t1(4) xor t1(5) xor carry1(1); 
carry1(2) <= (t1(4) and t1(5)) or (carry1(1) and (t1(4) xor t1(5))); 


t1(6) <= X(3) and Y(1);
sum1(3) <= t1(6) xor carry1(2);
carry1(3) <= t1(6) and carry1(2); 



t2(0) <= X(0) and Y(2);
sum2(0) <= sum1(1) xor t2(0);
carry2(0) <= sum1(1) and t2(0); 
Outp(2) <= sum2(0);

t2(1) <= X(1) and Y(2);
sum2(1) <= t2(1) xor sum1(2) xor carry2(0);
carry2(1) <= (t2(1) and sum1(2)) or (carry2(0) and (t2(1) xor sum1(2))); 


t2(2) <= X(2) and Y(2);
sum2(2) <= t2(2) xor sum1(3) xor carry2(1);
carry2(2) <= (t2(2) and sum1(3)) or (carry2(1) and (t2(2) xor sum1(3)));



t2(3) <= X(3) and Y(2);
sum2(3) <= t2(3) xor carry1(3) xor carry2(2);
carry2(3) <= (t2(3) and carry1(3)) or (carry2(2) and (t2(3) xor carry1(3)));



t3(0) <= X(0) and Y(3);
sum3(0) <= t3(0) xor sum2(1);
carry3(0) <= t3(0) and sum2(1);
Outp(3) <= sum3(0);

t3(1) <= X(1) and Y(3);
sum3(1) <= t3(1) xor sum2(2) xor carry3(0);
carry3(1) <= (t3(1) and sum2(2)) or (carry3(0) and (t3(1) xor sum2(2))); 
Outp(4) <= sum3(1);

t3(2) <= X(2) and Y(3);
sum3(2) <= t3(2) xor sum2(3) xor carry3(1);
carry3(2) <= (t3(2) and sum2(3)) or (carry3(1) and (t3(2) xor sum2(3)));
Outp(5) <= sum3(2);


t3(3) <= X(3) and Y(3);
sum3(3) <= t3(3) xor carry2(3) xor carry3(2);
carry3(3) <= (t3(3) and carry2(3)) or (carry3(2) and (t3(3) xor carry2(3)));
Outp(6) <= sum3(3);

Outp(7) <= carry3(3);


 









end struct; 