library ieee;
use ieee.std_logic_1164.all;

entity BLOCK2 is
	port(

	);
end BLOCK2;

architecture estructural of BLOCK2 is

component BLOCK1 is
	PORT(
		and1: in std_logic_vector (1 to 3);
		and2: in std_logic_vector (1 to 3);
		and3: in std_logic_vector (1 to 3);
		and4: in std_logic_vector (1 to 3);
		nor_out: out std_logic
	);
end component;

component FLIPFLOP_SR IS
	PORT(
		S,R,CLK, CLEAR: in std_logic;
		Qout,Qneg: out std_logic
	);
END component;

begin

Bloc


end estructural;
