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
    modo    : in std_logic

);
end sistema;

architecture Behavioral of sistema is
	

signal dispositivo_signal_select, rutina_select: std_logic_vector(2 downto 0); -- cuando signal select ='1' output=input del switch, cuando ='0' output=señal logica
signal enable_general: std_logic;		-- cuando ='1' sistema activo, cuando ='0' sistema inactivo (focos apagados)
signal disp1_out_aux,disp2_out_aux,disp3_out_aux: std_logic;
signal cont_disp: std_logic_vector (1 downto 0);
signal disp1_time_on,disp2_time_on,disp3_time_on: std_logic_vector (16 downto 0):"00000000000000000";

begin
	      

CONT_DISP<="01" WHEN switch="001" OR switch="010" OR switch="100" ELSE
	   "10" WHEN switch="011" OR switch="101" OR switch="110" ELSE
	   "11" WHEN switch="111" ELSE
	   "00";
	
	
JK: process(btn_on,btn_off,clk100m)
	begin
		if rising_edge(clk100m) then
			if(btn_on='1') then
			   	enable_general='1';
			elsif(btn_off='1') then
				enable_general='1';
			else null;
			end if;
		else null;
		end if;
	end process;
		


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
						
					when"010"  =>
					
					when "011" =>
					
					when "100" =>
					
					when "101" =>
					
					when others => null;
				end case;
	
			
		end case;
	else 
		dispositivo_signal_select<="000";
		disp1_out_aux<='0';
		disp2_out_aux<='0';
		disp3_out_aux<='0';
	end if;
	
	end process combProcess;
		
		
tiempo_disp_on: process(clk1out, disp1_out,disp2_out,disp3_out)
	begin
		if rising_edge (clk1out) then
			if(disp1_out='1') then
				disp1_time_on<= disp1_time_on + '1';
			else
				disp1_time_on<= "00000000000000000";
			end if;
				
			if(disp2_out='1') then
				disp2_time_on<= disp2_time_on + '1';
			else
				disp2_time_on<= "00000000000000000";
			end if;
				
			if(disp3_out='1') then
				disp3_time_on<= disp3_time_on + '1';
			else
				disp3_time_on<= "00000000000000000";
			end if;
				
				
		else null;
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
