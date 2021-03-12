
library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity ContadorSincronoMOD6 is
PORT( 
CLOCK, Reset, J1, K1: in std_logic;
Qout: out std_logic_vector (2 downto 0));
end ContadorSincronoMOD6;
architecture estructural of ContadorSincronoMOD6 is
component JK_FF is
PORT( 
J,K: in  std_logic;
          Reset: in std_logic;
          Clock_enable: in std_logic;
          Clock: in std_logic;
          Output: out std_logic
);
end component;
signal Q_Aux,Q_Reset, q0,q1,q2: std_logic;
begin 
	Qout(0) <= q0;
	Qout(1) <= q1;
	Qout(2) <= q2;
	Q_Aux <= q0 and q1;
	Q_Reset <= q1 and q2;

FFJK0: JK_FF 
port map (
J =>J1,
K =>K1,
Reset => Q_Reset ,
Clock_enable =>'1',
Clock =>CLOCK,
Output => q0);

FFJK1: JK_FF 
port map (
J =>q0,
K =>q0,
Reset=>Q_Reset,
Clock_enable =>'1',
Clock=>CLOCK,
Output=> q1);

FFJK2: JK_FF 
port map (
J =>Q_Aux,
K =>Q_Aux,
Reset =>Q_Reset,
Clock_enable =>'1',
Clock =>CLOCK,
Output => q2);
end estructural;