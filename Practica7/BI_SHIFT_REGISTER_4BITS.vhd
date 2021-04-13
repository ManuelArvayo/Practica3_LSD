library ieee;
use ieee.std_logic_1164.all;

entity BI_Shift_Register_4bits is
	port(
		A,B,C,D: in std_logic; 
		Clear: in std_logic;
		S0,S1: in std_logic;
		CLK: in std_logic;
		SL, SR: in std_logic;
		QA, QB, QC, QD: out std_logic

	);
end BI_Shift_Register_4bits;

architecture estructural of BI_Shift_Register_4bits is

component  BLOCK1 is
	PORT(
		and1: in std_logic_vector (1 to 3);
		and2: in std_logic_vector (1 to 3);
		and3: in std_logic_vector (1 to 3);
		and4: in std_logic_vector (1 to 3);
		clk_in, clear_in: in std_logic;
		Q, Qn: out std_logic
	);
end component;

signal sAnd1, sAnd2, sAnd3, sAnd4: std_logic_vector (1 to 3);
signal sAnd5, sAnd6, sAnd7, sAnd8: std_logic_vector (1 to 3);
signal sAnd9, sAnd10, sAnd11, sAnd12: std_logic_vector (1 to 3);
signal sAnd13, sAnd14, sAnd15, sAnd16: std_logic_vector (1 to 3);

signal notS1, notS0, QA_temp, QB_temp, QC_temp, QD_temp, QAN, QBN, QCN, QDN: std_logic;

begin

notS1 <= not S1;
notS0 <= not S0;

sAnd4 <=  SR & notS1 & S0;
sAnd2 <=  S0 & S1 & A;
sAnd3 <=  notS0 & S1 & QB_temp;
sAnd1 <=  notS0 & notS1 & QA_temp;

sAnd5 <= QA_temp & notS1 & S0;
sAnd6 <= S0 & S1 & B;
sAnd7 <= notS0 & S1 & QC_temp;
sAnd8 <= notS0 &notS1 & QB_temp;


sAnd9  <= QB_temp & notS1 & S0;
sAnd10 <= S0 & S1 & C;
sAnd11 <= notS0 & S1 & QD_temp;
sAnd12 <= notS0 & notS1 & QC_temp;


sAnd13 <= QC_temp & notS1 & S0;
sAnd14 <= S0 & S1 & D;
sAnd15 <= notS0 & S1 & SL;
sAnd16 <= notS0 & notS1 & QD_temp;

B1:BLOCK1 port map (and1=> sAnd1, and2=> sAnd2, and3=> sAnd3, and4=> sAnd4, clk_in=> CLK, clear_in=> Clear, Q=> QA_temp, Qn=> QAN);

B2:BLOCK1 port map (and1=> sAnd5, and2=> sAnd6, and3=> sAnd7, and4=> sAnd8, clk_in=> CLK, clear_in=> Clear, Q=> QB_temp, Qn=> QBN);

B3:BLOCK1 port map (and1=> sAnd9, and2=> sAnd10, and3=> sAnd11, and4=> sAnd12, clk_in=> CLK, clear_in=> Clear, Q=> QC_temp, Qn=> QCN);

B4:BLOCK1 port map (and1=> sAnd13, and2=> sAnd14, and3=> sAnd15, and4=> sAnd16, clk_in=> CLK, clear_in=> Clear, Q=> QD_temp, Qn=> QDN );

QA <= QA_temp;
QB <= QB_temp;
QC <= QC_temp;
QD <= QD_temp;

end estructural;
