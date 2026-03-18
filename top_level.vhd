library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top_level is 
  Port (
    Din : in std_logic_vector(7 downto 0);
    Start : in std_logic;
    LoadA_LSB : in std_logic;
    LoadA_MSB : in std_logic; 
    LoadB : in std_logic; 
    Clk : in std_logic; 
    Reset : in std_logic; 
    Done : out std_logic; 
    HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0);
    Overflow : out std_logic
  ); 
end top_level; 

architecture struct of top_level is

  component Controller
    port (
      clk    : in  std_logic;
      reset  : in  std_logic;   
      start  : in  std_logic;
      Load   : out std_logic;
      Add    : out std_logic;
      Shift4 : out std_logic;
      Done   : out std_logic
    );
  end component; 

  component Register8 
    port(
      Inp : in std_logic_vector(7 downto 0); 
      Load, Clk : in std_logic;
      Outp : out std_logic_vector(7 downto 0)
    ); 
  end component;

  component ACC 
    port( 
      clk     : in  std_logic;
      Load    : in  std_logic;
      Add     : in  std_logic;
      Shift4  : in  std_logic;
      A_reg   : in  std_logic_vector(15 downto 0);
      SUM     : in  std_logic_vector(7 downto 0);
      ACC_out : out std_logic_vector(23 downto 0)
    ); 
  end component;

  component ArrayMult
    port(
      X, Y : in  std_logic_vector(3 downto 0);
      Outp : out std_logic_vector(7 downto 0)
    );
  end component;

  component Adder8
    port (
      A, B : in  std_logic_vector(7 downto 0);
      Cin  : in  std_logic;
      Cout : out std_logic;
      S    : out std_logic_vector(7 downto 0)
    );
  end component;
  component BCDconverter is
    port (
        Din : in  std_logic_vector(19 downto 0);
        Do1 : out std_logic_vector(3 downto 0);
        Do2 : out std_logic_vector(3 downto 0);
        Do3 : out std_logic_vector(3 downto 0);
        Do4 : out std_logic_vector(3 downto 0);
        Do5 : out std_logic_vector(3 downto 0);
        Do6 : out std_logic_vector(3 downto 0)
    );
  end component;

  component display_circuit is
    port (
        BCD   : in  std_logic_vector(3 downto 0);
        Segments : out std_logic_vector(6 downto 0));
  end component;

  signal A_MSB : std_logic_vector(7 downto 0);
  signal A_LSB : std_logic_vector(7 downto 0);
  signal A     : std_logic_vector(15 downto 0);
  signal B     : std_logic_vector(7 downto 0);

  signal Load_acc  : std_logic;
  signal Add_acc   : std_logic;
  signal Shift_acc : std_logic;
  signal Done_acc  : std_logic;

  
  signal Sum    : std_logic_vector(7 downto 0) := (others => '0');


  signal acc_out : std_logic_vector(23 downto 0);
  signal nibble  : std_logic_vector(3 downto 0);
  signal prod8   : std_logic_vector(7 downto 0);
  signal cout8   : std_logic;
  signal product : std_logic_vector(19 downto 0); 
  signal ones_digits          : std_logic_vector(3 downto 0);
  signal tens_digits          : std_logic_vector(3 downto 0);
  signal hundreds_digits      : std_logic_vector(3 downto 0);
  signal thousands_digits     : std_logic_vector(3 downto 0);
  signal ten_thousands_digits : std_logic_vector(3 downto 0);
  signal hundred_thousands_digits : std_logic_vector(3 downto 0);


begin


  LA_MSB : Register8 port map(Inp => Din, Load => LoadA_MSB, Clk => Clk, Outp => A_MSB);
  LA_LSB : Register8 port map(Inp => Din, Load => LoadA_LSB, Clk => Clk, Outp => A_LSB);
  LB     : Register8 port map(Inp => Din, Load => LoadB,     Clk => Clk, Outp => B);

  A <= A_MSB & A_LSB;

  
  Control : Controller
    port map(
      clk    => Clk,
      reset  => Reset,
      start  => Start,
      Load   => Load_acc,
      Add    => Add_acc,
      Shift4 => Shift_acc,
      Done   => Done_acc
    );


  Accumulate : ACC
    port map(
      clk     => Clk,
      Load    => Load_acc,
      Add     => Add_acc,
      Shift4  => Shift_acc,
      A_reg   => A,
      SUM     => Sum,
      ACC_out => acc_out
    );

  
  nibble <= acc_out(3 downto 0);

 
  M1 : ArrayMult
    port map(
      X    => nibble,
      Y    => B(3 downto 0),
      Outp => prod8
    );

  
  ADD1 : Adder8
    port map(
      A    => acc_out(23 downto 16),
      B    => prod8,
      Cin  => '0',
      Cout => cout8,
      S    => Sum
    );

  
  Done     <= Done_acc;
  Overflow <= cout8;
  product <= acc_out(19 downto 0) when Done_acc = '1' else (others => '0');

CONVERT : BCDconverter
	port map (
		Din => product, 
		Do1 => ones_digits,         
 		Do2 => tens_digits,         
 		Do3 => hundreds_digits,    
 		Do4 =>thousands_digits,    
 		Do5 =>ten_thousands_digits, 
 		Do6 => hundred_thousands_digits ); 

DISPLAY_ONES : display_circuit
	port map (
		BCD => ones_digits,
		Segments => Hex0); 
DISPLAY_TENS : display_circuit
	port map (
		BCD => tens_digits,
		Segments => Hex1); 
DISPLAY_HUNDRED : display_circuit
	port map (
		BCD => hundreds_digits,
		Segments => Hex2);
DISPLAY_THOUSAND : display_circuit
	port map (
		BCD => thousands_digits,
		Segments => Hex3); 
DISPLAY_TEN_THOUSAND : display_circuit
	port map (
		BCD => ten_thousands_digits,
		Segments => Hex4); 

DISPLAY_HUNDRED_THOUSAND : display_circuit
	port map (
		BCD => hundred_thousands_digits,
		Segments => Hex5); 
end struct;

