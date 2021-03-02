library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity reloj is
	port (
		clk_in : in std_logic;
hrs_dec, hrs_uni, min_dec,min_uni, seg_dec, seg_uni: out std_logic;
	);
end reloj;
architecture estructural of reloj is

component ContadorSincronoMOD60BCD is
PORT(
CLOCK, Reset: in std_logic;
Q_Unidades, Q_Decenas: out std_logic_vector (3 downto 0);
    	);
end component;

component ContadorSincronoMOD12BCD is
    PORT (
          CLOCK, Reset: in std_logic;
Q_Dec: out std_logic_vector (3 downto 0);
Q_Uni: out std_logic;
    );
end component;

SEG: ContadorSincronoMOD60BCD port map (CLOCK,’0’,seg_uni,seg_dec);
MIN: ContadorSincronoMOD60BCD port map (CLOCK,’0’,min_uni,min_dec);
HRS: ContadorSincronoMOD12BCD port map (CLOCK,’0’,hrs_uni,hrs_dec);

end estructural;
