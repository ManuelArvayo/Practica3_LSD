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
    f1_out, f2_out, f3_out: out std_logic

);
end sistema;

architecture Behavioral of sistema is
	
signal dispositivo_signal_select: std_logic_vector(2 downto 0); -- cuando signal select ='1' output=input del switch, cuando ='0' output=señal logica
signal enable_general: std_logic;		-- cuando ='1' sistema activo, cuando ='0' sistema inactivo (focos apagados)
signal disp1_out_aux,disp2_out_aux,disp3_out_aux: std_logic;
signal cont_disp, nivel_consumo: std_logic_vector (1 downto 0):="00";
signal disp1_time_on,disp2_time_on,disp3_time_on, tiempo_total: std_logic_vector (4 downto 0):"00000"; -- cada 30 minutos es 1 unidad (se necesitan 48 [110000] para hacer un dia)
signal rutina_select: std_logic_vector(2 downto 0):="001";
signal f1_intensity, f2_intensity, f3_intensity: std_logic_vector(2 downto 0):="000";


signal dia_noche:std_logic:="0"; -- dia=1 ; noche = 0

component dimmer is
    port( 
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
      timer1,timer2, timer3: out std_logic_vector(5 downto 0)
    );
end component;	
	
begin
	      

CONT_DISP<="01" WHEN switch="001" OR switch="010" OR switch="100" ELSE
	   "10" WHEN switch="011" OR switch="101" OR switch="110" ELSE
	   "11" WHEN switch="111" ELSE
	   "00";
	
d1: dimmer port map (state=>f1_intensity, signal_out=>disp1_out_aux);		
d2: dimmer port map (state=>f2_intensity, signal_out=>disp1_out_aux);		
d3: dimmer port map (state=>f3_intensity, signal_out=>disp1_out_aux);
		   
JK1:JK port map (btn_on,btn_off,clk100m, enable_general);

tiempo_disp_on: tempo_disp_on port map(clk1out, disp1_out,disp2_out,disp3_out,disp1_time_on,disp2_time_on,disp3_time_on);			
tiempo_total<= disp1_time_on + disp2_time_on + disp3_time_on;		
	
 process(enable_general)
	begin
	if(enable_general='1') then
		case modo is
			when '1' =>				-- Manual
				dispositivo_signal_select<="111";  				
			when '0' =>   -- Automatico
				dispositivo_signal_select<="000";
				case rutina_select is
					when "001" =>
						if (nivel_consumo="01") then --nivel bajo de consumo: encender foco 1 y habilitar encendido de los demas
							f1_intensity<="100";
							dispositivo_signal_select<="110";
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
	
			
		end case;
	else 
		dispositivo_signal_select<="000";
		disp1_out_aux<='0';
		disp2_out_aux<='0';
		disp3_out_aux<='0';
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
	else nul;
	end if;
end process;

signal_select: process(dispositivo_signal_select)
	begin
		if dispositivo_signal_select(0) ='1' then
			disp1_out <= switch(0);
		elsif dispositivo_signal_select(0) = '0' then
			disp1_out <= disp1_out_aux;
		else null;
		end if;
			
		if dispositivo_signal_select(1) ='1' then
			disp2_out <= switch(1);
		elsif dispositivo_signal_select(1) = '0' then
			disp2_out <= disp2_out_aux;
		else null;
		end if;
			
		if dispositivo_signal_select(2) ='1' then
			disp3_out <= switch(2);
		elsif dispositivo_signal_select(2) = '0' then
			disp3_out <= disp3_out_aux;
		else null;
		end if;
	end process;
	

			
	
			
end Behavioral;
