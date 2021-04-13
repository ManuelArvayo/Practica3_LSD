library ieee;
use ieee.std_logic_1164.all;

entity BI_Shift_Register_8bits is
	port(
		A_in,B_in,C_in,D_in,E_in,F_in,G_in,H_in: in std_logic; 
		Clear_in: in std_logic;
		S0_in,S1_in: in std_logic;
		CLK_in: in std_logic;
		SL_in, SR_in: in std_logic;
		QA, QB, QC, QD, QE, QF, QG, QH: out std_logic

	);
end BI_Shift_Register_8bits;

architecture estructural of BI_Shift_Register_8bits is

component BI_Shift_Register_4bits is
	port(
		A,B,C,D: in std_logic; 
		Clear: in std_logic;
		S0,S1: in std_logic;
		CLK: in std_logic;
		SL, SR: in std_logic;
		QA, QB, QC, QD: out std_logic

	);
end component;
signal QA_temp, QB_temp, QC_temp, QD_temp, QE_temp, QF_temp, QG_temp, QH_temp: std_logic;
begin

ShiftR1: BI_Shift_Register_4bits port map 
(A => A_in, B=> B_in, C=>C_in, D=>D_in, Clear=>Clear_in, S0=>S0_in, S1=>S1_in, CLK=>CLK_in, SL=>QA_temp, SR=>SR_in, QA=>QA_temp, QB=>QB_temp, QC=>QC_temp, QD=>QD_temp);

ShiftR2: BI_Shift_Register_4bits port map 
(A => E_in, B=> F_in, C=>G_in, D=>H_in, Clear=>Clear_in, S0=>S0_in, S1=>S1_in, CLK=>CLK_in, SL=>SL_in, SR=>QD_temp, QA=>QE_temp, QB=>QF_temp, QC=>QG_temp, QD=>QH_temp);

QA<= QA_temp;
QB<= QB_temp;
QC<= QC_temp;
QD<= QD_temp;
QE<= QE_temp;
QF<= QF_temp;
QG<= QG_temp;
QH<= QH_temp;

end estructural;

