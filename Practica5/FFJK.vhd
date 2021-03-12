library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;

entity JK_FF is
PORT( 
J,K: in  std_logic;
          Reset: in std_logic;
          Clock_enable: in std_logic;
          Clock: in std_logic;
          Output: out std_logic
);
end JK_FF;
 
architecture Behavioral of JK_FF is
   signal temp: std_logic:='0';
begin
   process (Clock, Reset) 
   begin
	    if Reset = '1' then
		  temp <= '0';
	end if;
      if rising_edge(Clock) then                
          if Clock_enable ='1' then
            if (J='0' and K='0') then
               temp <= temp;
            elsif (J='0' and K='1') then
               temp <= '0';
            elsif (J='1' and K='0') then
               temp <= '1';
            elsif (J='1' and K='1') then
               temp <= not (temp);
            end if;
         end if;
      end if;
   end process;
   Output <= temp;
end Behavioral;
