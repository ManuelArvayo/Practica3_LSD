library IEEE;
use IEEE.STD_LOGIC
  
 
entity CONTA isPort ( 
  CLK : in STD_LOGIC;
  SIETE_SEG : out STD_LOGIC_VECTOR (6 downto 0);
  Up : 
  Down : 
  
  
  
  
  
   
entity CONTA isPort ( 
  CLK : in STD_LOGIC;
  SIETE_SEG : out STD_LOGIC_VECTOR (6 downto 0);
  CATODO : out STD_LOGIC_VECTOR (3 downto 0) ;
  X : out STD_LOGIC);
end CONTA; 
  
 architecture Behavioral of CONTA is
  signal led : std_logic;
  signal led2 : integer range 0 to 2**4;
  signal led3 : integer range 0 to 2**4;
  constant limite : natural := 50000000;
  signal count : integer range 0 to 2**26-1;
  begin
  clock : process (CLK)
  begin
  if CLK'event and CLK = '1' then
  count <= count + 1;
  if count = limite then
  led <= not led;
  led2 <=led2 +1;
  led3 <=led3 +1;
  if led2=9 then
  led2<=0;end if;
  if led3 =9 then
  led3<=0;
  end if;
  count <= 0;
  end if;
  end if;
  end process clock;
  X <= led;
  SEG : process (led2)
  begin
  case led2 is
  when 0 => SIETE_SEG <= "1000000";
  when 1 => SIETE_SEG <= "1111001";
  when 2 => SIETE_SEG <= "0100100";
  when 3 => SIETE_SEG <= "0110000";
  when 4 => SIETE_SEG <= "0011001";
  when 5 => SIETE_SEG <= "0010010";
  when 6 => SIETE_SEG <= "0000010";
  when 7 => SIETE_SEG <= "
