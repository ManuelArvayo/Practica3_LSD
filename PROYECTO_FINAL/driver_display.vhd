library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity disp is
  port(
    t_foco1, t_foco2, t_foco3, t_total : in std_logic_vector (5 downto 0);
    foco1_is_on, foco2_is_on, foco3_is_on: in std_logic;
    
    );
  end disp;
  
  architecture behavioral of disp is
    
    
    constant precio_basico: 	real := 0.829;       -- 
    constant precio_intermedio: 	real := 1.004;       -- 
    constant precio_excedente:	real := 2.934;       -- 
    constant consumo_foco_prom:	real := 8;       -- 
    
    
    begin
      
      
      
      
      end behavioral;
