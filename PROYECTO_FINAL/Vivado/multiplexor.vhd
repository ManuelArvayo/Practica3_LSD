----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2021 16:02:08
-- Design Name: 
-- Module Name: signal_selector - Behavioral
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

entity signal_selector is
  Port (
            s_in, switch: in std_logic_vector (2 downto 0);
            clk,s_secundaria1,s_secundaria2, s_secundaria3: in std_logic; 
            d1,d2,d3: out std_logic
     );
end signal_selector;

architecture Behavioral of signal_selector is

begin

signal_select: process(clk,s_in)
	begin
	   if rising_edge(clk) then
		if s_in(0) ='1' then
			d1 <= switch(0);
		elsif s_in(0) = '0' then
			d1 <= s_secundaria1;
		else null;
		end if;
			
		if s_in(1) ='1' then
			d2 <= switch(1);
		elsif s_in(1) = '0' then
			d2 <= s_secundaria2;
		else null;
		end if;
			
		if s_in(2) ='1' then
			d3 <= switch(2);
		elsif s_in(2) = '0' then
			d3 <= s_secundaria3;
		else null;
		end if;
	   else null;
	   end if;
	end process;
	

end Behavioral;
