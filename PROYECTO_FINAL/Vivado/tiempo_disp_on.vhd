----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2021 15:57:39
-- Design Name: 
-- Module Name: tiempo_disp_on - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity tempo_disp_on is
  port(
      CLK, d1,d2,d3: in std_logic;
      timer1,timer2, timer3: out std_logic_vector(5 downto 0)
    );
  end tempo_disp_on;
  
  
 architecture behavioral of tempo_disp_on is
   
   signal t1,t2,t3: std_logic_vector(5 downto 0);
   
   begin
     
     tiempo_disp_on: process(CLK, d1,d2,d3)
	    begin
		  if rising_edge (CLK) then
			  if(d1='1') then
				   t1<= t1 + '1';
			  else
				  t1<= "000000";
			  end if;
			  
      			  if(d2='1') then
				  t2<= t2 + '1';
			  else
				    t2<= "000000";
			  end if;
				
			  if(d3='1') then
				  t3<= t3 + '1';
			  else
				  t3<= "000000";
			  end if;
								
		else null;
		end if;
    end process;
      
     timer1<=t1;
     timer2<=t2;
     timer3<=t3;
          
     end behavioral;
