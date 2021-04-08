library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity operaciones is
	port(
		a_in: in std_logic_vector (3 downto 0);
		b_in: in std_logic_vector (3 downto 0);
		op: in std_logic_vector (1 downto 0);
		a_signo: in std_logic;
		b_signo: in std_logic;
		res: out std_logic_vector (3 downto 0);
		resultado_signo: out std_logic
	);
end operaciones;
architecture behavioral of operaciones is


component MULTIPLIER is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           RES : out  STD_LOGIC_VECTOR (11 downto 0));
end component;

signal a_int, b_int, suma, resta_ab, resta_ba, mult_int, resultado: integer:=0;

signal mult: std_logic_vector (3 downto 0);
signal operand_a: std_logic_vector (7 downto 0);
signal res_temp: std_logic_vector (11 downto 0);
signal a_mayorque_b: std_logic;

begin

operand_a <= "0000"&a_in;

a_int <= to_integer(unsigned(a_in));
b_int <= to_integer(unsigned(b_in));


suma <= a_int + b_int;
resta_ab <= a_int-b_int;
resta_ba <= b_int-a_int;
a_mayorque_b <= '1' when a_int>b_int else '0';

mu: MULTIPLIER port map ( A => operand_a, B => b_in, RES => res_temp);
mult <= res_temp(3 downto 0);
mult_int<=to_integer(unsigned(mult));
process(suma, resta_ab, resta_ba, a_signo, b_signo, a_int, b_int, mult_int, op)
begin
	if op="01" then
		if a_signo='0' and b_signo ='0' then
			resultado<=suma;
			resultado_signo <= '0';

		elsif a_signo='0' and b_signo='1' then
				if a_mayorque_b = '1' then
					resultado<=resta_ab;
					resultado_signo <= '0';
				else 
					resultado<=resta_ba;
					resultado_signo<='1';
				end if;

			--resultado_signo <= '0' when a_mayorque_b ='1' else '1';

		elsif a_signo='1' and b_signo='0' then
			if a_mayorque_b = '1' then
					resultado<=resta_ab;
					resultado_signo<='1';
				else 
					resultado<=resta_ba;
					resultado_signo<='0';
				end if;
			--resultado_signo <= '1' when a_mayorque_b ='1' else '0';

		elsif a_signo='1' and b_signo='1' then
			resultado <= suma;
			resultado_signo <= '1';
		end if;		

	end if;
		
	if op="10" then
		if a_signo='0' and b_signo='0' then
				if a_mayorque_b = '1' then
					resultado<=resta_ab;
					resultado_signo <= '0';
				else 
					resultado<=resta_ba;
					resultado_signo<='1';
				end if;

		elsif a_signo='0' and b_signo='1' then
			resultado<=suma;
			resultado_signo <= '0';

		elsif a_signo='1' and b_signo='0' then
			resultado <= suma;
			resultado_signo <= '1';

		elsif a_signo='1' and b_signo='1' then
				if a_mayorque_b = '1' then
					resultado<=resta_ab;
					resultado_signo <= '1';
				else 
					resultado<=resta_ba;
					resultado_signo<='0';
				end if;
		end if;

	end if;

	if op="11" then
		resultado<=mult_int;
		if a_signo='0' and b_signo='0' then
			resultado_signo <= '0';

		elsif a_signo='0' and b_signo='1' then
			--resultado<=mult_int;
			resultado_signo <= '1';

		elsif a_signo='1' and b_signo='0' then
			--resultado <= mult_int;
			resultado_signo <= '1';

		elsif a_signo='1' and b_signo='1' then
			--resultado<=mult_int;
			resultado_signo <= '0';
		end if; 

	end if;
 
end process;

res<= std_logic_vector( to_unsigned( resultado, res'length) );

end behavioral;