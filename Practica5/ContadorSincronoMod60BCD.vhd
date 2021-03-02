library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity ContadorSincronoMOD60BCD is
    (
     PORT    CLOCK, Reset: in std_logic;
Q_Unidades, Q_Decenas: out std_logic_vector (3 downto 0);
    );
end ContadorSincronoMOD60BCD;

architecture estructural ContadorSincronoMOD60BCD is
component ContadorSincronoMOD10 is
    PORT (
       	CLOCK, Reset: in std_logic;
		j_ff1,k_ff1 : in std_logic;
Q: out std_logic_vector (3 downto 0)
    );
end component;

component ContadorSincronoMOD6 is
PORT( 
CLOCK, Reset: in std_logic;
		j_ff1,k_ff1 : in std_logic;
Q: out std_logic_vector (2 downto 0)
);
end component;
signal Reset_mod10: std_logic;
begin
Reset_mod10 <= Q_Unidades(3) and Q_Unidades(1);
CS10: ContadorSincronoMOD10 port map (CLOCK,’0’,’1’,’1’,Q_ Unidades);
CS6: ContadorSincronoMOD6 port map (CLOCK,’0’,Reset_mod10, Reset_mod10, Q_Decenas);
end estructural;
