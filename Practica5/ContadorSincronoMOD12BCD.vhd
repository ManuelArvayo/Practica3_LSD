library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity ContadorSincronoMOD12BCD is
    PORT (
        CLOCK, Reset: in std_logic;
	Q_Uni: out std_logic_vector (3 downto 0);
	Q_Dec: out std_logic_vector (3 downto 0)
    );
end ContadorSincronoMOD12BCD;

architecture estructural of ContadorSincronoMOD12BCD is
 
 component ContadorSincronoMOD10 is
    PORT (
        CLOCK, Reset: in std_logic;
	Q: out std_logic_vector (3 downto 0)
    );
 end component;

component JK_FF is
    
   PORT(J,K: in  std_logic;
          Reset: in std_logic;
          Clock_enable: in std_logic;
          Clock: in std_logic;
          Output: out std_logic
);
end component;

signal Q_FF,Q_Aux,Q_Reset, Q_Dec_Out, Q_Reset_MOD10: std_logic:='0';
signal Q_Uni_Aux: std_logic_vector (3 downto 0);

 begin 
	Q_FF <= Q_Uni_Aux(3) and Q_Uni_Aux(1);
	Q_Reset <= Q_Dec_Out and Q_Uni_Aux(1) and not Q_Uni_Aux(0)and not Q_Uni_Aux(2)and not Q_Uni_Aux(3);
 	Q_Uni <= Q_Uni_Aux;
	Q_Dec <= '0'&'0'&'0'&Q_Dec_Out;
	Q_Reset_MOD10 <= (Q_Uni_Aux(3) and Q_Uni_Aux(1)) or (Q_Dec_Out and not Q_Uni_Aux(1) and Q_Uni_Aux(0)and not Q_Uni_Aux(2)and not Q_Uni_Aux(3));
	Q_Aux <= Q_Uni_Aux(3) and Q_Uni_Aux(0);

CSM10: ContadorSincronoMOD10 
	port map (
	CLOCK => CLOCK,
	Reset=> Q_Reset,
	Q => Q_Uni_Aux
);

FFJK0: JK_FF 
	port map (
	J =>Q_Aux,
	K =>Q_Aux,
	Reset => Q_Reset,
	Clock_enable =>'1',
	Clock => CLOCK,
	Output =>Q_Dec_Out
       );

end estructural;

