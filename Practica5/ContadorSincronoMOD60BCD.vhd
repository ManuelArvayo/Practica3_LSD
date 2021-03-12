library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity ContadorSincronoMOD60BCD is
     PORT(
	CLOCK, Reset: in std_logic;
	Q_Unidades, Q_Decenas: out std_logic_vector (3 downto 0)
    );
end ContadorSincronoMOD60BCD;

architecture estructural of ContadorSincronoMOD60BCD is
component ContadorSincronoMOD10 is
    PORT (
       	CLOCK, Reset: in std_logic;
	Q: out std_logic_vector (3 downto 0)
    );
end component;

component ContadorSincronoMOD6 is
PORT( 
	CLOCK, Reset,J1,K1: in std_logic;
	Qout: out std_logic_vector (2 downto 0)
);
end component;
signal Reset_mod10: std_logic:='0';
signal Q_Unidades_Aux: std_logic_vector (3 downto 0);
signal Q_Decenas_Aux: std_logic_vector (2 downto 0);
begin
Reset_mod10 <= Q_Unidades_Aux (3) and Q_Unidades_Aux(1) and not Q_Unidades_Aux(0) and not Q_Unidades_Aux(2);
Q_Unidades <= Q_Unidades_Aux;
Q_Decenas <= '0'&Q_Decenas_Aux;

CS10: ContadorSincronoMOD10 
	port map (
	CLOCK => CLOCK,
	Reset =>'0',
	Q => Q_Unidades_Aux);

CS6: ContadorSincronoMOD6 
	port map (
	CLOCK => Reset_mod10,
	Reset => '0',
	J1 => '1',
	K1 => '1',
	Qout => Q_Decenas_Aux);

end estructural;
