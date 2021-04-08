library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity calculadora is
	port(
		CLK: in std_logic;
		fila, columna: in std_logic_vector (3 downto 0);
		resultado: out std_logic_vector (3 downto 0);		
		signo_R: out std_logic
			
	);

end calculadora;
architecture behavioral of calculadora is

component operaciones is
	port(
		a_in: in std_logic_vector (3 downto 0);
		b_in: in std_logic_vector (3 downto 0);
		op: in std_logic_vector (1 downto 0);
		a_signo: in std_logic;
		b_signo: in std_logic;
		res: out std_logic_vector (3 downto 0);
		resultado_signo: out std_logic
	);
end component;

component KEYBOARD is
    Port ( row : in  STD_LOGIC_VECTOR (3 downto 0);
           column : in  STD_LOGIC_VECTOR (3 downto 0);
           KEY : out  STD_LOGIC_VECTOR (15 downto 0)
         );
end component;

component sSegDisplay is
    Port(		ck : in  std_logic;                          -- 100MHz system clock
			number : in  std_logic_vector (63 downto 0); -- eight digit number to be displayed
			seg : out  std_logic_vector (7 downto 0);    -- display cathodes
			an : out  std_logic_vector (7 downto 0));    -- display anodes (active-low, due to transistor complementing)
end component;

signal number,A, B, RES: std_logic_vector (3 downto 0);
signal signoA, signoB, signoRes: std_logic:='0';
signal operacion, oper: std_logic_vector(1 downto 0);

signal not_number, ready: std_logic;
signal KB: std_logic_vector(15 downto 0):=x"0000";
signal I: integer:=0;

signal num7seg : std_logic_vector(63 downto 0) := x"00000000";


begin

k: KEYBOARD port map( row => fila, column => columna, KEY => KB);
op: operaciones port map ( a_in => A, b_in => B, op => oper, a_signo => signoA, b_signo => signoB, res => resultado, resultado_signo => signo_R);
sSd: sSegDisplay port map ( ck => CLK, number => , seg=> , an =>);

process(CLK)
begin
case KB is
		when x"8000" =>
			number<=x"1";
		when x"4000" =>
			number<=x"2";
		when x"2000" =>
			number<=x"3";
		when x"0800" =>
			number<=x"4";
		when x"0400" =>
			number<=x"5";
		when x"0200" =>
			number<=x"6";
		when x"0080" =>
			number<=x"7";
		when x"0040" =>
			number<=x"8";
		when x"0020" =>
			number<=x"9";
		when x"0004" =>
			number<=x"0";
		when x"1000" =>
			operacion<="01";
		when x"0100" =>
			operacion<="10";
		when x"0010" =>
			operacion<="11";
		when others =>
			null;

	end case;


case signoA is
	when "0" =>
		num7seg(63 downto 56) <= "11111111";
	when "1" =>
		num7seg(63 downto 56) <= "10111111";
end case;

case signoB is
	when "0" =>
		num7seg(63 downto 56) <= "11111111";
	when "1" =>
		num7seg(63 downto 56) <= "10111111";
end case;


if rising_edge (CLK) then
	if KB=x"1000" or KB=x"0100" or KB=x"0010" or KB=x"0008" or KB=x"0002" or KB=x"0001" then
		not_number<='1';
	else 
		not_number<='0';
	end if;

	if(KB=x"0002" and I=0) then
		signoA <= '1';
		I<= I+1;
	elsif (not_number='0' and I=0) then
		A<=number;
		signoA <= '0';
		I<=I+2;
	end if;
	if I=1 and not_number='0' then
		A<=number;
		I<=I+1;
	end if;
		if I=2 and not_number='1' then
		oper <= operacion;
		I<=I+1;
	end if;
		if(KB=x"0002" and I=3) then
		signoB <= '1';
		I<= I+1;
	elsif (not_number='0' and I=3) then
		B<=number;
		signoB <= '0';
		I<=I+2;
	end if;
		if I=4 and not_number='0' then
		B<=number;
		I<=I+1;
	end if; 
		if I=5 and KB=x"0001" then
		ready<='1';
		else
		ready<='0';	
	end if;

	

	
	
end if;
end process;

end behavioral;