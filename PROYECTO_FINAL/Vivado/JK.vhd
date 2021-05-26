----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2021 15:56:10
-- Design Name: 
-- Module Name: JK - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
			   	Q<='1';
			elsif(K='1') then
				Q<='0';
			else null;
			end if;
		else null;
		end if;
	end process;

end behavioral;
