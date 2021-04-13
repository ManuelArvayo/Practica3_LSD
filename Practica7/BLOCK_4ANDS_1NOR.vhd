library ieee;
use ieee.std_logic_1164.all;

entity BLOCK1 is
	PORT(
		and1: in std_logic_vector (1 to 3);
		and2: in std_logic_vector (1 to 3);
		and3: in std_logic_vector (1 to 3);
		and4: in std_logic_vector (1 to 3);
		clk_in, clear_in: in std_logic;
		Q, Qn: out std_logic
	);
end BLOCK1;

architecture behavioral of BLOCK1 is

component FLIPFLOP_SR IS
	PORT(
		S,R,CLK, CLEAR: in std_logic;
		Qout,Qneg: out std_logic
	);
END component;

signal and1_out,and2_out,and3_out,and4_out,nor_out,s_in: std_logic;
 
begin
and1_out <= and1(1) and and1(2) and and1(3);
and2_out <= and2(1) and and2(2) and and2(3);
and3_out <= and3(1) and and3(2) and and3(3);
and4_out <= and4(1) and and4(2) and and4(3);
nor_out <= not(and1_out or and2_out or and3_out or and4_out);

s_in <= not nor_out;

      
FF: FLIPFLOP_SR port map ( S=> s_in, R=> nor_out, CLK=> clk_in, CLEAR=> clear_in, Qout=> Q, Qneg=> Qn);

end behavioral;