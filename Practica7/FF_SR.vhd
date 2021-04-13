library ieee;
use ieee.std_logic_1164.all;

entity FLIPFLOP_SR IS
	PORT(
		S,R,CLK, CLEAR: in std_logic;
		Qout,Qneg: out std_logic
	);
END FLIPFLOP_SR;

ARCHITECTURE BEHAVIORAL OF FLIPFLOP_SR IS

SIGNAL temp: std_logic;
BEGIN
	PROCESS(CLK, CLEAR)
	BEGIN
	if (CLEAR='1') then
		temp<='0';
	end if;
		if rising_edge(CLK) then
			if (S='0' and R='0') then
               			null;
            		elsif (S='0' and R='1') then
              			temp <= '0';
           		elsif (S='1' and R='0') then
               			temp <= '1';
            		elsif (S='1' and R='1') then
               			temp <= 'Z'; 
			end if;
		end if;

	END PROCESS;
Qout<=temp;
Qneg<=not temp;

END BEHAVIORAL;
