library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KEYBOARD is
    Port ( row : in  STD_LOGIC_VECTOR (3 downto 0);
           column : in  STD_LOGIC_VECTOR (3 downto 0);
           KEY : out  STD_LOGIC_VECTOR (15 downto 0)
         );
end KEYBOARD;

architecture Behavioral of KEYBOARD is
--signal row_internal: std_logic_vector (3 downto 0);
begin

process(row,column)
begin
	if row = "0111" then
		case column is
	                when "0111" =>
	                	KEY <= "1000000000000000"; --8000  1
	                when "1011" => 
	                	KEY <= "0100000000000000"; --4000  2
	                when "1101" =>
	                    	KEY <= "0010000000000000"; --2000  3
	                when "1110" =>
	                   	KEY <= "0001000000000000"; --1000  +
	                when others => 
				KEY <= "0000000000000000"; 
		end case;
	end if;

if row = "1011" then
		case column is
	                when "0111" =>
	                	KEY <= "0000100000000000"; --0800  4
	                when "1011" => 
	                	KEY <= "0000010000000000"; --0400  5
	                when "1101" =>
	                    	KEY <= "0000001000000000"; --0200  6 
	                when "1110" =>
	                   	KEY <= "0000000100000000"; --0100  -
	                when others => 
				KEY <= "0000000000000000"; 
		end case;
	end if;

if row = "1101" then
		case column is
	                when "0111" =>
	                	KEY <= "0000000010000000"; --0080  7
	                when "1011" => 
	                	KEY <= "0000000001000000"; --0040  8
	                when "1101" =>
	                    	KEY <= "0000000000100000"; --0020  9
	                when "1110" =>
	                   	KEY <= "0000000000010000"; --0010  *
	                when others => 
				KEY <= "0000000000000000"; 
		end case;
	end if;

if row = "1110" then
		case column is
	                when "0111" =>
	                	KEY <= "0000000000001000"; --0008  del
	                when "1011" => 
	                	KEY <= "0000000000000100"; --0004  0
	                when "1101" =>
	                    	KEY <= "0000000000000010"; --0002  neg
	                when "1110" =>
	                   	KEY <= "0000000000000001"; --0001  =  
	                when others => 
				KEY <= "0000000000000000"; 
		end case;
	end if;

	
end process;

end Behavioral;