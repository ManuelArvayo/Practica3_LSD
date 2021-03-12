library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;

entity ContadorSincronoMOD10 is
    PORT (
        CLOCK, Reset: in std_logic;
	Q : out std_logic_vector (3 downto 0)
    );
end ContadorSincronoMOD10;
 
architecture estructural of ContadorSincronoMOD10 is
component JK_FF is
PORT( 
	J,K: in  std_logic;
        Reset: in std_logic;
        Clock_enable: in std_logic;
        Clock: in std_logic;
        Output: out std_logic
);
end component;
signal Q_Aux, Q_Aux2, Q_Reset, q0, q1, q2, q3, Q_Reset_FF: std_logic;
begin 
	Q(0) <= q0;
	Q(1) <= q1;
	Q(2) <= q2;
	Q(3) <= q3;
	Q_Aux <= q0 and q1;
	Q_Aux2 <= q0 and q1 and q2;
	Q_Reset <= q3 and q1;
	Q_Reset_FF <= (q3 and q1) or Reset;
	
FFJK0: JK_FF 
port map (
J => '1',
K => '1',
Reset => Q_Reset_FF,
Clock_enable =>'1',
Clock =>CLOCK,
Output =>q0);

FFJK1: JK_FF 
port map (
J =>q0,
K =>q0,
Reset=>Q_Reset_FF,
Clock_enable =>'1',
Clock=>CLOCK,
Output=>q1);

FFJK2: JK_FF 
port map (
J =>Q_Aux,
K =>Q_Aux,
Reset =>Q_Reset_FF,
Clock_enable =>'1',
Clock =>CLOCK,
Output =>q2);

FFJK3: JK_FF 
port map (
J =>Q_Aux2,
K =>Q_Aux2,
Reset =>Q_Reset_FF,
Clock_enable =>'1',
Clock =>CLOCK,
Output =>q3);

end estructural;
