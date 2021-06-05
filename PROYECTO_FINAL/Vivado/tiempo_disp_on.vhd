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
      timer1,timer2, timer3: out std_logic_vector(11 downto 0);
      timerT:out std_logic_vector(7 downto 0)
    );
  end tempo_disp_on;
  
  
 architecture behavioral of tempo_disp_on is
   
   signal t1,t2,t3: std_logic_vector(11 downto 0):=x"000";
   signal t_total: std_logic_vector(7 downto 0):="00000000";

   
   begin
     
     tiempo_disp_on: process(CLK, d1,d2,d3,t1,t2,t3)
	    begin
		  if rising_edge (CLK) then
			  if(d1='1') then
			     if(t1(11 downto 8)>x"9") then
			         t1(11 downto 8)<= t1(11 downto 8)-"1001";
			     end if;
			     if(t1(7 downto 0)=x"98") then
			         t1(7 downto 0)<= x"00";
			         t1(11 downto 8)<= t1(11 downto 8)+x"1";
			     end if;
				   t1<= t1 + x"008";
				   t_total<=t_total+'1';
			  else
				  t1<= x"000";
			  end if;
			  
      			  if(d2='1') then
      			  if(t2(11 downto 8)>"1001") then
			         t2(11 downto 8)<= t2(11 downto 8)-"1001";
			     end if;
			     if(t2(7 downto 0)=x"98") then
			         t2(7 downto 0)<= x"00";
			         t2(11 downto 8)<= t2(11 downto 8)+x"1";
			     end if;
				  t2<= t2 + x"008";
				   t_total<=t_total+'1';
			  else
				    t2<= x"000";
			  end if;
				
			  if(d3='1') then
			     if(t3(11 downto 8)>"1001") then
			         t3(11 downto 8)<= t3(11 downto 8)-"1001";
			     end if;
			     if(t3(7 downto 0)=x"98") then
			         t3(7 downto 0)<= x"00";
			         t3(11 downto 8)<= t3(11 downto 8)+x"1";
			     end if;
				  t3<= t3 + x"008";
				   t_total<=t_total+'1';
			  else
				  t3<= x"000";
			  end if;
								
		else null;
		end if;
    end process;
      
     timer1<=t1;
     timer2<=t2;
     timer3<=t3;
     timerT<=t_total;
          
     end behavioral;
