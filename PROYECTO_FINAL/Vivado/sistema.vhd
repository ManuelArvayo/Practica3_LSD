----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2021 15:50:24
-- Design Name: 
-- Module Name: sistema - Behavioral
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



entity sistema is  
port (
    clk100m : in std_logic;
    btn_on  : in std_logic;
    btn_off : in std_logic;
    switch: in std_logic_vector (2 downto 0);
    modo    : in std_logic;
    f1_out, f2_out, f3_out, buzzer: out std_logic;
    rs,rw,e: out std_logic;
    lcd_data: out std_logic_vector(7 downto 0)

);
end sistema;

architecture Behavioral of sistema is
	
signal dispositivo_signal_select: std_logic_vector(2 downto 0); -- cuando signal select ='1' output=input del switch, cuando ='0' output=señal logica
signal enable_general: std_logic;		-- cuando ='1' sistema activo, cuando ='0' sistema inactivo (focos apagados)
signal disp1_out_aux,disp2_out_aux,disp3_out_aux: std_logic:='0'; -- señales auxiliares de salida a los focos
signal cont_disp, nivel_consumo: std_logic_vector (1 downto 0):="00";
signal disp1_time_on,disp2_time_on,disp3_time_on: std_logic_vector (11 downto 0):=x"000"; -- cada 60 minutos es 1 unidad (se necesitan 24 [110000] para hacer un dia)
signal tiempo_total: std_logic_vector(7 downto 0);
signal rutina_select: std_logic_vector(2 downto 0):="001";
signal f1_intensity, f2_intensity, f3_intensity: std_logic_vector(2 downto 0):="000";

signal disp1_out,disp2_out,disp3_out: std_logic;
signal dia_noche: std_logic:='1'; -- dia=1 ; noche = 0
signal clk_out1, reset,locked: std_logic;

signal gasto: std_logic_vector(11 downto 0);

component dimmer is
    port( 
      Clk100m: in std_logic;
      state: in std_logic_vector (2 downto 0);
      signal_out: out std_logic
    );
end component;

component JK is
port(
  J,K,CLK: in std_logic;
  Q: out std_logic
  );
end component;

component tempo_disp_on is
  port(
      CLK, d1,d2,d3: in std_logic;
      timer1,timer2, timer3: out std_logic_vector(11 downto 0);
      timerT: out std_logic_vector(7 downto 0)
    );
end component;	
	
component signal_selector is
  Port (
            s_in, switch: in std_logic_vector (2 downto 0);
            clk,s_secundaria1,s_secundaria2, s_secundaria3: in std_logic; 
            d1,d2,d3: out std_logic
     );
end component;

COMPONENT DISPLAY_lcd is

GENERIC(
			FPGA_CLK : INTEGER := 100_000_000
);


PORT(CLK: IN STD_LOGIC;

	  RS 		  : OUT STD_LOGIC;							
	  RW		  : OUT STD_LOGIC;							
	  ENA 	  : OUT STD_LOGIC;							
	  DATA_LCD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   
	  MODO_SYS: in std_logic;
	  DIA_NOCHE_SYS: IN STD_LOGIC;
	  NUM_FOCOS,NIV_CONSUMO: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	  CONT_F1,CONT_F2,CONT_F3,GTO_APRX:IN STD_LOGIC_VECTOR(11 DOWNTO 0)

	  );

end COMPONENT;
	
begin
	      

CONT_DISP<="01" WHEN switch="001" OR switch="010" OR switch="100" ELSE
	   "10" WHEN switch="011" OR switch="101" OR switch="110" ELSE
	   "11" WHEN switch="111" ELSE
	   "00";
	
gasto <= std_logic_vector(to_unsigned(to_integer(unsigned(tiempo_total) * 8),12));
d1: dimmer port map (Clk100m=>clk100m,state=>f1_intensity, signal_out=>disp1_out_aux);		
d2: dimmer port map (Clk100m=>clk100m,state=>f2_intensity, signal_out=>disp2_out_aux);		
d3: dimmer port map (Clk100m=>clk100m,state=>f3_intensity, signal_out=>disp3_out_aux);
		   
JK1:JK port map 
    (  J=> btn_on,
       K=> btn_off,
       CLK=> clk100m,
       Q=> enable_general);

display: DISPLAY_lcd PORT map (
      CLK             => clk100m,
	  RS 	          => rs,						
	  RW		      => rw,						
	  ENA 	  		  => e,
	  DATA_LCD        => lcd_data,
	  MODO_SYS        => modo,
	  DIA_NOCHE_SYS   => dia_noche,  
	  NUM_FOCOS       => CONT_DISP,
	  NIV_CONSUMO     => nivel_consumo,
	  CONT_F1         => disp1_time_on,
	  CONT_F2         => disp2_time_on,
	  CONT_F3         => disp3_time_on,
	  GTO_APRX        => gasto

	  );

ciclo_dia_noche: process(clk100m)
variable cont,seg: integer:=0;

begin
    if rising_edge(clk100m) then
        if seg= 60 then
            dia_noche<= not dia_noche;
            seg:=0;
        elsif cont= 100000000 then
           seg:=seg+1;
           cont:=0;
        else
           cont:=cont+1;
        end if; 
    else null;
    end if;
end process;

tiempo_disp_on: tempo_disp_on port map
    (CLK=>Clk100m,
     d1=>disp1_out,
     d2=>disp2_out,
     d3=>disp3_out,
     timer1=>disp1_time_on,
     timer2=>disp2_time_on,
     timer3=>disp3_time_on,
     timerT=>tiempo_total
     );			
	
 process(enable_general,modo,rutina_select)
	begin
	if(enable_general='1') then
		case modo is
			when '1' =>				-- Manual
				dispositivo_signal_select<="111";  	
				buzzer<='0';			
			when '0' =>   -- Automatico
				dispositivo_signal_select<="000";
				case rutina_select is
					when "001" =>
						if (nivel_consumo="01") then --nivel bajo de consumo: encender foco 1 y habilitar encendido de los demas
							f1_intensity<="100";
							dispositivo_signal_select<="110";
							buzzer<='0';
						else
							rutina_select<="010";
						end if;
					when"010"  =>
						if(nivel_consumo="10") then -- nivel medio de consumo: reducir intensidad del foco con mas tiempo encendido a la mitad.
							if ((disp1_time_on > disp2_time_on) and (disp1_time_on> disp3_time_on)) then -- disp1_timer > disp2_timer > disp3_timer
								f1_intensity<="010";						
							elsif ((disp2_time_on > disp1_time_on) and (disp2_time_on> disp3_time_on)) then -- disp2_timer > disp1_timer > disp3_timer
								f2_intensity<="010";
							elsif ((disp3_time_on > disp1_time_on) and (disp3_time_on> disp2_time_on)) then -- disp3_timer > disp1_timer > disp2_timer
								f3_intensity<="010";
							else null;
							end if;
							buzzer<='0';
						else
							rutina_select<="011";
						end if;
					when "011" =>
						if (nivel_consumo="11") then -- nivel alto de consumo: apagar todos los focos y deshabilitarlos, encender buzzer
							f1_intensity<="000";
							f2_intensity<="000";
							f3_intensity<="000";
							dispositivo_signal_select<="000";
							buzzer<='1';
						else
							null;
						end if;
					when others => null;
				end case;
	
	   when others=>null;		
		end case;
	else 
		dispositivo_signal_select<="000";
		--disp1_out_aux<='0';
		--disp2_out_aux<='0';
		--disp3_out_aux<='0';
	end if;
	
	end process;

				
consumo: process(tiempo_total)
begin
	if(tiempo_total<"00101") then  -- 5 hrs
		nivel_consumo<="01"; --Bajo
	elsif (tiempo_total>"00101" and (tiempo_total>"01010")) then -- entre 5 y 10 hrs
		nivel_consumo<="10"; --Medio
	elsif (tiempo_total>"01010") then  -- mayor a 10 hrs
		nivel_consumo<="11"; --Alto
	else null;
	end if;
end process;

signal_select: signal_selector port map 
    (   s_in=>dispositivo_signal_select, 
        switch=>switch,
        clk=>clk100m,
        s_secundaria1=>disp1_out_aux,
        s_secundaria2=>disp2_out_aux,
        s_secundaria3=>disp3_out_aux, 
        d1=>disp1_out,
        d2=>disp2_out,
        d3=>disp3_out
    );
    
f1_out <= disp1_out;
f2_out <= disp2_out;
f3_out <= disp3_out;

			
end Behavioral;
