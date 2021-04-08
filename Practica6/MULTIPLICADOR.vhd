library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MULTIPLIER is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           RES : out  STD_LOGIC_VECTOR (11 downto 0));
end MULTIPLIER;


architecture Behavioral of MULTIPLIER is
	signal A_int: integer;
	signal B_int: integer;
	signal RES_int: integer;
begin

	A_int <= to_integer(unsigned(A));
        B_int <= to_integer(unsigned(B));
	RES_int <=  A_int * B_int;
        RES <= std_logic_vector(to_unsigned(RES_int , RES'length) );
        
        --if I comment out everything related with RES_int and use the below code everything works 
	--RES <= std_logic_vector(to_unsigned(A_int * B_int , RES'length)  );  

	
end Behavioral;
