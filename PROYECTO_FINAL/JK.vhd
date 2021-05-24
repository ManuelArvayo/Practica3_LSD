library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JK is
port(
  J,K,CLK: in std_logic;
  Q: out std_logic
  );
end JK;
architecture behavioral of JK is

begin

process(J,K,CLK)
	begin
		if rising_edge(CLK) then
			if(J='1') then
			   	Q='1';
			elsif(K='1') then
				Q='0';
			else null;
			end if;
		else null;
		end if;
	end process;

end behavioral;
