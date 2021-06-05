----------------------------------------------------------------------------------
-- COPYRIGHT 2019 Jesús Eduardo Méndez Rosales
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
--
--							LIBRERÍA LCD
--
-- Descripción: Con ésta librería podrás implementar códigos para una LCD 16x2 de manera
-- fácil y rápida, con todas las ventajas de utilizar una FPGA.
--
-- Características:
-- 
--	Los comandos que puedes utilizar son los siguientes:
--
-- LCD_INI() -> Inicializa la lcd.
--		 			 NOTA: Dentro de los paréntesis poner un vector de 2 bits para encender o apagar
--					 		 el cursor y activar o desactivar el parpadeo.
--
--		"1x" -- Cursor ON
--		"0x" -- Cursor OFF
--		"x1" -- Parpadeo ON
--		"x0" -- Parpadeo OFF
--
--   Por ejemplo: LCD_INI("10") -- Inicializar LCD con cursor encendido y sin parpadeo 
--	
--			
-- CHAR() -> Manda una letra mayúscula o minúscula
--
--				 IMPORTANTE: 1) Debido a que VHDL no es sensible a mayúsculas y minúsculas, si se quiere
--								    escribir una letra mayúscula se debe escribir una "M" antes de la letra.
--								 2) Si se quiere escribir la letra "S" mayúscula, se declara "MAS"
--											
-- 	Por ejemplo: CHAR(A)  -- Escribe en la LCD la letra "a"
--						 CHAR(MA) -- Escribe en la LCD la letra "A"	
--						 CHAR(S)	 -- Escribe en la LCD la letra "s"
--						 CHAR(MAS)	 -- Escribe en la LCD la letra "S"	
--	
--
-- POS() -> Escribir en la posición que se indique.
--				NOTA: Dentro de los paréntesis se dene poner la posición de la LCD a la que se quiere ir, empezando
--						por el renglón seguido de la posición vertical, ambos números separados por una coma.
--		
--		Por ejemplo: POS(1,2) -- Manda cursor al renglón 1, poscición 2
--						 POS(2,4) -- Manda cursor al renglón 2, poscición 4		
--
--
-- CHAR_ASCII() -> Escribe un caracter a partir de su código en ASCII
--						 NOTA: Dentro de los parentesis escribir x"(número hex.)"
--
--		Por ejemplo: CHAR_ASCII(x"40") -- Escribe en la LCD el caracter "@"
--
--
-- CODIGO_FIN() -> Finaliza el código. 
--						 NOTA: Dentro de los paréntesis poner cualquier número: 1,2,3,4...,8,9.
--
--
-- BUCLE_INI() -> Indica el inicio de un bucle. 
--						NOTA: Dentro de los paréntesis poner cualquier número: 1,2,3,4...,8,9.
--
--
-- BUCLE_FIN() -> Indica el final del bucle.
--						NOTA: Dentro de los paréntesis poner cualquier número: 1,2,3,4...,8,9.
--
--
-- INT_NUM() -> Escribe en la LCD un número entero.
--					 NOTA: Dentro de los paréntesis poner sólo un número que vaya del 0 al 9,
--						    si se quiere escribir otro número entero se tiene que volver
--							 a llamar la función
--
--
-- CREAR_CHAR() -> Función que crea el caracter diseñado previamente en "CARACTERES_ESPECIALES.vhd"
--                 NOTA: Dentro de los paréntesis poner el nombre del caracter dibujado (CHAR1,CHAR2,CHAR3,..,CHAR8)
--								 
--
-- CHAR_CREADO() -> Escribe en la LCD el caracter creado por medio de la función "CREAR_CHAR()"
--						  NOTA: Dentro de los paréntesis poner el nombre del caracter creado.
--
--     Por ejemplo: 
--
--				Dentro de CARACTERES_ESPECIALES.vhd se dibujan los caracteres personalizados utilizando los vectores 
--				"CHAR_1", "CHAR_2","CHAR_3",...,"CHAR_7","CHAR_8"
--
--								 '1' => [#] - Se activa el pixel de la matríz.
--                       '0' => [ ] - Se desactiva el pixel de la matriz.
--
-- 			Si se quiere crear el				Entonces CHAR_1 queda de la siguiente
--				siguiente caracter:					manera:
--												
--				  1  2  3  4  5						CHAR_1 <=
--  		  1 [ ][ ][ ][ ][ ]							"00000"&			
-- 		  2 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  3 [ ][#][ ][#][ ]							"01010"&   		  
-- 		  4 [ ][ ][ ][ ][ ]		=====>			"00000"&			   
-- 		  5 [#][ ][ ][ ][#]							"10001"&          
-- 		  6 [ ][#][#][#][ ]							"01110"&			  
-- 		  7 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  8 [ ][ ][ ][ ][ ]							"00000";			
--
--		
--			Como el caracter se creó en el vector "CHAR_1",entonces se escribe en las funciónes como "CHAR1"
--			
--			CREAR_CHAR(CHAR1)  -- Crea el caracter personalizado (CHAR1)
--			CHAR_CREADO(CHAR1) -- Muestra en la LCD el caracter creado (CHAR1)		
--
-- 
--
-- LIMPIAR_PANTALLA() -> Manda a limpiar la LCD.
--								 NOTA: Ésta función se activa poniendo dentro de los paréntesis
--										 un '1' y se desactiva con un '0'. 
--
--		Por ejemplo: LIMPIAR_PANTALLA('1') -- Limpiar pantalla está activado.
--						 LIMPIAR_PANTALLA('0') -- Limpiar pantalla está desactivado.
--
--
--	Con los puertos de entrada "CORD" y "CORI" se hacen corrimientos a la derecha y a la
--	izquierda respectivamente. NOTA: La velocidad del corrimiento se puede cambiar 
-- modificando la variable "DELAY_COR".
--
-- Algunas funciónes generan un vector ("BLCD") cuando se terminó de ejecutar dicha función y
--	que puede ser utilizado como una bandera, el vector solo dura un ciclo de instruccion.
--	   
--		LCD_INI() ---------- BLCD <= x"01"
--		CHAR() ------------- BLCD <= x"02"
--		POS() -------------- BLCD <= x"03"
-- 	INT_NUM() ---------- BLCD <= x"04"
--	   CHAR_ASCII() ------- BLCD <= x"05"
--	   BUCLE_INI() -------- BLCD <= x"06"
--		BUCLE_FIN() -------- BLCD <= x"07"
--		LIMPIAR_PANTALLA() - BLCD <= x"08"
--	   CREAR_CHAR() ------- BLCD <= x"09"
--	 	CHAR_CREADO() ------ BLCD <= x"0A"
--
--
--		¡IMPORTANTE!
--		
--		1) Se deberá especificar el número de instrucciones en la constante "NUM_INSTRUCCIONES". El valor 
--			de la última instrucción es el que se colocará
--		2) En caso de utilizar a la librería como TOP del diseño, se deberá comentar el puerto genérico y 
--			descomentar la constante "FPGA_CLK" para especificar la frecuencia de reloj.
--		3) Cada función se acompaña con " INST(NUM) <= <FUNCIÓN> " como lo muestra en el código
-- 		demostrativo.
--
--
--                CÓDIGO DEMOSTRATIVO
--
--		CONSTANT NUM_INSTRUCCIONES : INTEGER := 7;
--
-- 	INST(0) <= LCD_INI("11"); 		-- INICIALIZAMOS LCD, CURSOR A HOME, CURSOR ON, PARPADEO ON.
-- 	INST(1) <= POS(1,1);				-- EMPEZAMOS A ESCRIBIR EN LA LINEA 1, POSICIÓN 1
-- 	INST(2) <= CHAR(MH);				-- ESCRIBIMOS EN LA LCD LA LETRA "h" MAYUSCULA
-- 	INST(3) <= CHAR(O);			
-- 	INST(4) <= CHAR(L);
-- 	INST(5) <= CHAR(A);
-- 	INST(6) <= CHAR_ASCII(x"21"); -- ESCRIBIMOS EL CARACTER "!"
-- 	INST(7) <= CODIGO_FIN(1);	   -- FINALIZAMOS EL CODIGO
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE WORK.COMANDOS_LCD_REVD.ALL;

entity PAG1 is

GENERIC(
			FPGA_CLK : INTEGER := 100_000_000
);


PORT(CLK: IN STD_LOGIC;

-----------------------------------------------------
------------------PUERTOS DE LA LCD------------------
	  RS 		  : OUT STD_LOGIC;							--
	  RW		  : OUT STD_LOGIC;							--
	  ENA 	  : OUT STD_LOGIC;							--
	  DATA_LCD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   --
-----------------------------------------------------
-----------------------------------------------------
	  
	  
-----------------------------------------------------------
--------------ABAJO ESCRIBE TUS PUERTOS--------------------	
	  MODO_SYS: in std_logic;
	  DIA_NOCHE_SYS: IN STD_LOGIC;
	  NUM_FOCOS,NIV_CONSUMO: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	  CONT_F1,CONT_F2,CONT_F3,GTO_APRX:IN STD_LOGIC_VECTOR(11 DOWNTO 0)
-----------------------------------------------------------
-----------------------------------------------------------

	  );

end PAG1;

architecture Behavioral of PAG1 is


CONSTANT NUM_INSTRUCCIONES : INTEGER := 38; 	--INDICAR EL NÚMERO DE INSTRUCCIONES PARA LA LCD


--------------------------------------------------------------------------------
-------------------------SEÑALES DE LA LCD (NO BORRAR)--------------------------
																										--
component PROCESADOR_LCD_REVD is																--
																										--
GENERIC(																								--
			FPGA_CLK : INTEGER := 50_000_000;												--
			NUM_INST : INTEGER := 1																--
);																										--
																										--
PORT( CLK 				 : IN  STD_LOGIC;														--
	   VECTOR_MEM 		 : IN  STD_LOGIC_VECTOR(8  DOWNTO 0);							--
	   C1A,C2A,C3A,C4A : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);							--
	   C5A,C6A,C7A,C8A : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);							--
	   RS 				 : OUT STD_LOGIC;														--
	   RW 				 : OUT STD_LOGIC;														--
	   ENA 				 : OUT STD_LOGIC;														--
	   BD_LCD 			 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);			         	--
	   DATA 				 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);							--
	   DIR_MEM 			 : OUT INTEGER RANGE 0 TO NUM_INSTRUCCIONES					--
	);																									--
																										--
end component PROCESADOR_LCD_REVD;															--
																										--
COMPONENT CARACTERES_ESPECIALES_REVD is													--
																										--
PORT( C1,C2,C3,C4 : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);								--
		C5,C6,C7,C8 : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)									--
	 );																								--
																										--
end COMPONENT CARACTERES_ESPECIALES_REVD;													--
																										--
CONSTANT CHAR1 : INTEGER := 1;																--
CONSTANT CHAR2 : INTEGER := 2;																--
CONSTANT CHAR3 : INTEGER := 3;																--
CONSTANT CHAR4 : INTEGER := 4;																--
CONSTANT CHAR5 : INTEGER := 5;																--
CONSTANT CHAR6 : INTEGER := 6;																--
CONSTANT CHAR7 : INTEGER := 7;																--
CONSTANT CHAR8 : INTEGER := 8;																--
																										--
type ram is array (0 to  NUM_INSTRUCCIONES) of std_logic_vector(8 downto 0); 	--
signal INST : ram := (others => (others => '0'));										--
																										--
signal blcd 			  : std_logic_vector(7 downto 0):= (others => '0');		--																										
signal vector_mem 	  : STD_LOGIC_VECTOR(8  DOWNTO 0) := (others => '0');		--
signal c1s,c2s,c3s,c4s : std_logic_vector(39 downto 0) := (others => '0');		--
signal c5s,c6s,c7s,c8s : std_logic_vector(39 downto 0) := (others => '0'); 	--
signal dir_mem 		  : integer range 0 to NUM_INSTRUCCIONES := 0;				--
																										--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
---------------------------AGREGA TUS SEÑALES AQUÍ------------------------------

CONSTANT ESCALA_1S : INTEGER := FPGA_CLK -1;
signal b                 : std_logic := '0';
signal conta_retardo     : integer range 0 to escala_1s := 0;
signal unidades, decenas : integer range 0 to 9 :=0;
SIGNAL C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16 :STD_LOGIC_VECTOR (7 DOWNTO 0):=X"20";
SIGNAL C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30,C31,C32:STD_LOGIC_VECTOR (7 DOWNTO 0):=X"20";
SIGNAL NUM_PAG: STD_LOGIC_VECTOR(1 DOWNTO 0);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


begin


---------------------------------------------------------------
-------------------COMPONENTES PARA LCD------------------------
																				 --
u1: PROCESADOR_LCD_REVD													 --
GENERIC map( FPGA_CLK => FPGA_CLK,									 --
				 NUM_INST => NUM_INSTRUCCIONES )						 --
																				 --
PORT map( CLK,VECTOR_MEM,C1S,C2S,C3S,C4S,C5S,C6S,C7S,C8S,RS, --
			 RW,ENA,BLCD,DATA_LCD, DIR_MEM );						 --
																				 --
U2 : CARACTERES_ESPECIALES_REVD 										 --
PORT MAP( C1S,C2S,C3S,C4S,C5S,C6S,C7S,C8S );				 		 --
																				 --
VECTOR_MEM <= INST(DIR_MEM);											 --
																				 --
---------------------------------------------------------------
---------------------------------------------------------------


-------------------------------------------------------------------
---------------ESCRIBE TU CÓDIGO PARA LA LCD-----------------------
INST(0)  <= LCD_INI("11");
INST(1)  <= LCD_INI("00");
INST(2)  <= BUCLE_INI(1);
INST(3)  <= POS(1,1);
INST(4)  <= CHAR_ASCII(C1);
INST(5)  <= CHAR_ASCII(C2);
INST(6)  <= CHAR_ASCII(C3);
INST(7)  <= CHAR_ASCII(C4);
INST(8)  <= CHAR_ASCII(C5);
INST(9)  <= CHAR_ASCII(C6);
INST(10)  <= CHAR_ASCII(C7);
INST(11)  <= CHAR_ASCII(C8);
INST(12)  <= CHAR_ASCII(C9);
INST(13)  <= CHAR_ASCII(C10);
INST(14)  <= CHAR_ASCII(C11);
INST(15)  <= CHAR_ASCII(C12);
INST(16)  <= CHAR_ASCII(C13);
INST(17)  <= CHAR_ASCII(C14);
INST(18)  <= CHAR_ASCII(C15);
INST(19)  <= CHAR_ASCII(C16);
INST(20)  <= POS(2,1);
INST(21)  <= CHAR_ASCII(C17);
INST(22)  <= CHAR_ASCII(C18);
INST(23)  <= CHAR_ASCII(C19);
INST(24)  <= CHAR_ASCII(C20);
INST(25)  <= CHAR_ASCII(C21);
INST(26)  <= CHAR_ASCII(C22);
INST(27)  <= CHAR_ASCII(C23);
INST(28)  <= CHAR_ASCII(C24);
INST(29)  <= CHAR_ASCII(C25);
INST(30)  <= CHAR_ASCII(C26);
INST(31)  <= CHAR_ASCII(C27);
INST(32)  <= CHAR_ASCII(C28);
INST(33)  <= CHAR_ASCII(C29);
INST(34)  <= CHAR_ASCII(C30);
INST(35)  <= CHAR_ASCII(C31);
INST(36)  <= CHAR_ASCII(C32);
INST(37)  <= BUCLE_FIN(1);
INST(38)  <= CODIGO_FIN(1);
-------------------------------------------------------------------
-------------------------------------------------------------------




-------------------------------------------------------------------
--------------------ESCRIBE TU CÓDIGO DE VHDL----------------------


PROCESS(CLK)
VARIABLE CONT: INTEGER:=0;
BEGIN
IF rising_edge(CLK) THEN
    IF(CONT<10*FPGA_CLK) THEN
        NUM_PAG<="00";
    ELSIF(CONT<20*FPGA_CLK) THEN
        NUM_PAG<="01";
    ELSIF(CONT<30*FPGA_CLK) THEN
        NUM_PAG<="10";
    ELSE
        NUM_PAG<="11";
    END IF;
    CONT:=CONT+1;
END IF;

END PROCESS;
process(CLK,MODO_SYS, DIA_NOCHE_SYS, NUM_PAG)
begin
if rising_edge(CLK) then
    IF(NUM_PAG="00") THEN
        C1<=X"4D"; --M
        C2<=X"6F"; --o
        C3<=X"64"; --d
        C4<=X"6F"; --o
        C5<=X"3A"; --:
        C17<=x"54"; --T
        C18<=x"69"; --i
        C19<=x"65"; --e
        C20<=x"6D"; --m
        C21<=x"70"; --p
        C22<=x"6F"; --o
        C23<=X"3A"; --:
        if (MODO_SYS='0') THEN
            C6<=x"4D"; --M
            C7<=x"61"; --A
            C8<=x"6E"; --N
        ELSIF (MODO_SYS='1') THEN
            C6<=x"41"; --A
            C7<=x"75"; --U
            C8<=x"74"; --T
        end if;
        IF (DIA_NOCHE_SYS='0') THEN
            C24<=x"44"; --D
            C25<=x"69"; --I
            C26<=x"61"; --A
            C27<=x"20"; --
            C28<=x"20"; --
        ELSIF(DIA_NOCHE_SYS='1') THEN
            C24<=x"4E"; --N
            C25<=x"6F"; --O
            C26<=x"63"; --C
            C27<=x"68"; --H
            C28<=x"65"; --E
        end if;
        
        
          C9<=X"20";
          C10<=X"20";
          C11<=X"20";
          C12<=X"20";
          C13<=X"20";
          C14<=X"20";
          C15<=X"20";
          C16<=X"20";
          C29<=X"20";
          C30<=X"20";
          C31<=X"20";
          C32<=X"20";
     ELSIF(NUM_PAG="01") THEN
          C1<=X"23"; --#
          C2<=X"20"; --
          C3<=X"64"; --D
          C4<=X"65"; --E
          C5<=X"20"; --
          C6<=X"66"; --F
          C7<=X"6F"; --O
          C8<=X"63"; --C
          C9<=X"6F"; --O
          C10<=X"73"; --S
          C11<=X"3A"; --:
          
          C17<=X"54";--T
          C18<=X"69";--I
          C19<=X"6D";--M
          C20<=X"65";--E
          C21<=X"20";--
          C22<=X"46";--F
          C23<=X"31";--1
          C24<=X"3A";--:
          C27<=X"3A";--:
          C29<=X"30";
          IF(NUM_FOCOS = "00") THEN
            C12<=X"30";
          ELSIF(NUM_FOCOS = "01") THEN
            C12<=X"31";
          ELSIF(NUM_FOCOS = "10") THEN
            C12<=X"32";
          ELSIF(NUM_FOCOS = "11") THEN
            C12<=X"33";
          END IF;
         
          IF(CONT_F1(3)='1')THEN
            C28<=X"33";
          ELSIF (CONT_F1(3)='0')THEN
            C28<=X"30";
          END IF;
            C25<=X"3"&CONT_F1(11 DOWNTO 8);
            C26<=X"3"&CONT_F1(7 DOWNTO 4);              
          
     END IF;
          
          C13<=X"20";
          C14<=X"20";
          C15<=X"20";
          C16<=X"20";
          
          
      ELSIF(NUM_PAG="10") THEN
          C1<=X"54";--T
          C2<=X"69";--I
          C3<=X"6D";--M
          C4<=X"65";--E
          C5<=X"20";-- 
          C6<=X"46";--F
          C7<=X"32";--2
          C8<=X"3A";--:
          C11<=X"3A";--:
          C13<=X"30";
          
          C17<=X"54";--T
          C18<=X"69";--I
          C19<=X"6D";--M
          C20<=X"65";--E
          C21<=X"20";--
          C22<=X"46";--F
          C23<=X"33";--3
          C24<=X"3A";--:
          C27<=X"3A";--:
          C29<=X"30";
          
          
          IF(CONT_F3(3)='1')THEN
            C12<=X"33";
          ELSIF (CONT_F3(3)='0')THEN
            C12<=X"30";
          END IF;
            C9<=X"3"&CONT_F3(11 DOWNTO 8);
            C10<=X"3"&CONT_F3(7 DOWNTO 4);   
         
          IF(CONT_F2(3)='1')THEN
            C28<=X"33";
          ELSIF (CONT_F2(3)='0')THEN
            C28<=X"30";
          END IF;
            C25<=X"3"&CONT_F2(11 DOWNTO 8);
            C26<=X"3"&CONT_F2(7 DOWNTO 4);              
                    
      ELSIF(NUM_PAG="10") THEN
          C1<=X"4E";--N     
          C2<=X"69";--I     
          C3<=X"76";--V     
          C4<=X"65";--E     
          C5<=X"6C";--L     
          C6<=X"20";--     
          C7<=X"63";--C     
          C8<=X"6F";--O     
          C9<=X"6E";--N     
          C10<=X"3A";--:  
          
          IF(NIV_CONSUMO="01")THEN
             C11<=X"42";--B
             C12<=X"41";--A
             C13<=X"4A";--J
             C14<=X"4F";--O
             C15<=X"20";
          ELSIF (NIV_CONSUMO="10")THEN
             C11<=X"4D";--M
             C12<=X"45";--E
             C13<=X"44";--D
             C14<=X"49";--I
             C15<=X"4F";--O
          ELSIF(NIV_CONSUMO="11")THEN
             C11<=X"41";--A
             C12<=X"4C";--L
             C13<=X"54";--T
             C14<=X"4F";--O
             C15<=X"20";
          END IF;
          
          C17<=X"47";--G   
          C18<=X"54";--T     
          C19<=X"4F";--O     
          C20<=X"20";--     
          C21<=X"41";--A     
          C22<=X"50";--P    
          C23<=X"58";--X     
          C24<=X"3A";--:
          C25<=X"24";--$
          
          C26<=X"3"&GTO_APRX(11 DOWNTO 8);
          C27<=X"3"&GTO_APRX(7 DOWNTO 4);
          C28<=X"3"&GTO_APRX(3 DOWNTO 0);
          C29<=X"20";
          C30<=X"20";
          C31<=X"20";
          C32<=X"20";
 END IF;
end process;

-------------------------------------------------------------------
-------------------------------------------------------------------





end Behavioral;

