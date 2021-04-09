library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;	-- add to do arithmetic operations
use IEEE.std_logic_arith.all;		-- add to do arithmetic

entity tb_practica6 is
-- Port ( );
end tb_practica6;
  
-- Conexión del testbench al diseño deseado.
architecture Behavioral of tb_practica6 is
component operaciones is
port(
		a_in: in std_logic_vector (3 downto 0);
		b_in: in std_logic_vector (3 downto 0);
		op: in std_logic_vector (1 downto 0);
		a_signo: in std_logic;
		b_signo: in std_logic;
		res: out std_logic_vector (3 downto 0);
		resultado_signo: out std_logic
	);
end component;
       
-- Creación de señales de estimulación y monitoreo
signal sa_in: std_logic_vector (3 downto 0);
signal sb_in: std_logic_vector (3 downto 0);
signal sop: std_logic_vector (1 downto 0);
signal sa_signo: std_logic;
signal sb_signo: std_logic;
signal sres: std_logic_vector (3 downto 0);
signal sresultado_signo: std_logic;

   
-- Mapeo de entradas y salidas a señales del testbench
begin  

DUT: operaciones port map(
a_in=>sa_in,
b_in=>sb_in,
op=>sop,
a_signo=>sa_signo,
b_signo=>sb_signo,
res=>sres,
resultado_signo=>sresultado_signo
 );
      
-- Estimulación de entradas mediante señales de testbench
-- 5 + 3	, 9 - 4	, 5 × 3	, -8 + -5	, 6 × -2  
process
begin

sa_in <= x"5";
sb_in <= x"3";
sop <= "01";
sa_signo<='0';
sb_signo<='0';

wait for 10 ns;

sa_in <= x"9";
sb_in <= x"4";
sop <= "10";
sa_signo<='0';
sb_signo<='0'; 

wait for 10 ns;

sa_in <= x"5";
sb_in <= x"3";
sop <= "11";    
sa_signo<='0';
sb_signo<='0';      

wait for 10 ns;

sa_in <= x"8";
sb_in <= x"5";
sop <= "01";
sa_signo<='1';
sb_signo<='1';
      
wait for 10 ns;

sa_in <= x"6";
sb_in <= x"2";
sop <= "11";
sa_signo<='0';
sb_signo<='1';
  
wait;
end process;
end Behavioral;
