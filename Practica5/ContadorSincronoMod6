library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity ContadorSincronoMOD6 is
PORT( 
CLOCK, Reset: in std_logic;
j_ff1,k_ff1 : in std_logic;
Q: out std_logic_vector (2 downto 0));
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
signal Q_Aux,Q_Reset: std_logic;
begin 
	Q_Aux <= Q(0) and Q(1);
	Q_Reset <= Q(1) and Q(2);
j_ff1 => ‘1’;
	k_ff1 => ‘1’;

FFJK0: JK_FF 
port map (
J =>j_ff1;
K =>k_ff1;
Reset => Q_Reset 
Clock_enable =>‘1’
Clock =>CLOCK
Output =>Q(0));

FFJK1: JK_FF 
port map (
J =>Q(0)
K =>Q(0)
Reset=>Q_Reset
Clock_enable =>’1’
Clock=>CLOCK
Output=>Q(1));

FFJK2: JK_FF 
port map (
J =>Q_Aux
K =>Q_Aux
Reset =>Q_Reset
Clock_enable =>’1’
Clock =>CLOCK
Output =>Q(2));
end estructural;
