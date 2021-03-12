
library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity reloj is
	port (
	clk_in : in std_logic;
	hrs_dec, hrs_uni, min_dec,min_uni, seg_dec, seg_uni: out std_logic_vector (3 downto 0)
	);
end reloj;

architecture estructural of reloj is

component ContadorSincronoMOD60BCD is
PORT(
	CLOCK, Reset: in std_logic;
	Q_Unidades, Q_Decenas: out std_logic_vector (3 downto 0)
    );
end component;

component ContadorSincronoMOD12BCD is
    PORT (
        CLOCK, Reset: in std_logic;
	Q_Uni: out std_logic_vector (3 downto 0);
	Q_Dec: out std_logic_vector (3 downto 0)
    );
end component;

signal seg_uni_Aux, seg_dec_Aux: std_logic_vector (3 downto 0);
signal minClock: std_logic;
signal min_uni_Aux, min_dec_Aux: std_logic_vector(3 downto 0);
signal hrsClock: std_logic;
signal hrs_uni_Aux, hrs_dec_Aux: std_logic_vector(3 downto 0);

begin
seg_uni <= seg_uni_Aux;
seg_dec <= seg_dec_Aux;
minClock <= seg_dec_Aux(2) and seg_dec_Aux(0) and seg_uni_Aux(3) and seg_uni_Aux(1);
min_uni <= min_uni_Aux;
min_dec <= min_dec_Aux;
hrsClock <= min_dec_Aux(2) and min_dec_Aux(0) and min_uni_Aux(3) and min_uni_Aux(1);
hrs_uni <= hrs_uni_Aux;
hrs_dec <= hrs_dec_Aux;

SEG: ContadorSincronoMOD60BCD port map (clk_in,'0',seg_uni_Aux,seg_dec_Aux);
MIN: ContadorSincronoMOD60BCD port map (minClock,'0',min_uni_Aux,min_dec_Aux);
HRS: ContadorSincronoMOD12BCD 
port map (
	CLOCK=>hrsClock,
	Reset=>'0',
	Q_Uni=>hrs_uni_Aux,
	Q_Dec=>hrs_dec_Aux);

end estructural;