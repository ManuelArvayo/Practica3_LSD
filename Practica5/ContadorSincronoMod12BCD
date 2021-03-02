library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;


entity ContadorSincronoMOD12BCD is
    PORT (
        CLOCK, Reset: in std_logic;
Q_Dec: out std_logic_vector (3 downto 0);
Q_Uni: out std_logic;
    );
end ContadorSincronoMOD12BCD;

architecture estructural ContadorSincronoMOD12BCD is
 
 component ContadorSincronoMOD10 is
    PORT (
        CLOCK, Reset: in std_logic;
		j_ff1,k_ff1 : in std_logic;
Q: out std_logic_vector (3 downto 0);
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

signal Q_Aux,Q_Reset: std_logic;
 begin 
	Q_Aux <= Q_Uni(3) and Q_Uni(1);
j_ff1 => ‘1’;
	k_ff1 => ‘1’;
	Q_Reset <= Q_Dec and Q_Uni(1);

	CSM10: ContadorSincronoMOD10 
port map (
CLOCK => CLOCK
Reset=> Q_Aux or Q_Reset
j_ff1 => ‘1’
k_ff1 => ‘1’
Q => Q_Uni
);

FFJK0: JK_FF 
port map (
J =>Q_Aux;
K =>Q_Aux;
Reset => Q_Reset
Clock_enable =>‘1’
Clock =>CLOCK
Output =>Q_Dec
       );

end estructural;

