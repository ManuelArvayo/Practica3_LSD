
library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;
use IEEE.numeric_std.ALL;




entity reloj is
	port (
	clk_in : in std_logic;
	
	seg7d : out std_logic_vector(7 downto 0);
	an7d : out std_logic_vector(7 downto 0)
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

component sSegDisplay is
    Port(ck : in  std_logic;                          -- 100MHz system clock
			number : in  std_logic_vector (31 downto 0); -- eight digit number to be displayed
			seg : out  std_logic_vector (7 downto 0);    -- display cathodes
			an : out  std_logic_vector (7 downto 0));    -- display anodes (active-low, due to transistor complementing)
end component;

signal seg_uni_Aux, seg_dec_Aux: std_logic_vector (3 downto 0);
signal minClock: std_logic;
signal min_uni_Aux, min_dec_Aux: std_logic_vector(3 downto 0);
signal hrsClock: std_logic;
signal hrs_uni_Aux, hrs_dec_Aux: std_logic_vector(3 downto 0);
signal hrs_dec, hrs_uni, min_dec,min_uni, seg_dec, seg_uni: std_logic_vector (3 downto 0);
signal num7seg : std_logic_vector(31 downto 0) := x"00000000";
signal clk_div, temp: std_logic:='0';
signal count: integer := 1;

begin
seg_uni <= seg_uni_Aux;
seg_dec <= seg_dec_Aux;
minClock <= seg_dec_Aux(2) and seg_dec_Aux(0) and seg_uni_Aux(3) and seg_uni_Aux(1);
min_uni <= min_uni_Aux;
min_dec <= min_dec_Aux;
hrsClock <= min_dec_Aux(2) and min_dec_Aux(0) and min_uni_Aux(3) and min_uni_Aux(1);
hrs_uni <= hrs_uni_Aux;
hrs_dec <= hrs_dec_Aux;
--num7seg <= '0'&'0'&'0'&'0'&hrs_dec&'0'&'0'&'0'&'0'&hrs_uni&'0'&'0'&'0'&'0'&min_dec&'0'&'0'&'0'&'0'&min_uni;

process (clk_in, min_uni, min_dec, hrs_uni, hrs_dec)
begin
if(rising_edge(clk_in)) then
    count <= count+1;
    if(count = 5000000) then
        clk_div <= not clk_div;
        count<=1;
    end if;
end if;
    
case (min_uni) is
    when "0000" => num7seg (7 downto 0) <= "11000000"; -- C0
    when "0001" => num7seg (7 downto 0) <= "11111001"; -- F9
    when "0010" => num7seg (7 downto 0) <= "10100100"; -- A4
    when "0011" => num7seg (7 downto 0) <= "10110000"; -- B0
    when "0100" => num7seg (7 downto 0) <= "10011001"; --
    when "0101" => num7seg (7 downto 0) <= "10010010"; --
    when "0110" => num7seg (7 downto 0) <= "10000010"; --
    when "0111" => num7seg (7 downto 0) <= "11111000"; --
    when "1000" => num7seg (7 downto 0) <= "10000000"; --
    when "1001" => num7seg (7 downto 0) <= "10010000"; -- 
    when others => num7seg (7 downto 0) <= "11000000"; --
end case;

case (min_dec) is
    when "0000" => num7seg (15 downto 8) <= "11000000";
    when "0001" => num7seg (15 downto 8) <= "11111001";
    when "0010" => num7seg (15 downto 8) <= "10100100";
    when "0011" => num7seg (15 downto 8) <= "10110000";
    when "0100" => num7seg (15 downto 8) <= "10011001";
    when "0101" => num7seg (15 downto 8) <= "10010010";
    when "0110" => num7seg (15 downto 8) <= "10000010";
    when "0111" => num7seg (15 downto 8) <= "11111000";
    when "1000" => num7seg (15 downto 8) <= "10000000";
    when "1001" => num7seg (15 downto 8) <= "10010000";
    when others => num7seg (15 downto 8) <= "11111111";
end case;

case (hrs_uni) is
    when "0000" => num7seg (23 downto 16) <= "11000000";
    when "0001" => num7seg (23 downto 16) <= "11111001";
    when "0010" => num7seg (23 downto 16) <= "10100100";
    when "0011" => num7seg (23 downto 16) <= "10110000";
    when "0100" => num7seg (23 downto 16) <= "10011001";
    when "0101" => num7seg (23 downto 16) <= "10010010";
    when "0110" => num7seg (23 downto 16) <= "10000010";
    when "0111" => num7seg (23 downto 16) <= "11111000";
    when "1000" => num7seg (23 downto 16) <= "10000000";
    when "1001" => num7seg (23 downto 16) <= "10010000";
    when others => num7seg (23 downto 16) <= "11000000";
end case;

case (hrs_dec) is
    when "0000" => num7seg (31 downto 24) <= "11000000";
    when "0001" => num7seg (31 downto 24)<= "11111001";
    when "0010" => num7seg (31 downto 24)<= "10100100";
    when "0011" => num7seg (31 downto 24)<= "10110000";
    when "0100" => num7seg (31 downto 24)<= "10011001";
    when "0101" => num7seg (31 downto 24)<= "10010010";
    when "0110" => num7seg (31 downto 24)<= "10000010";
    when "0111" => num7seg (31 downto 24)<= "11111000";
    when "1000" => num7seg (31 downto 24)<= "10000000";
    when "1001" => num7seg (31 downto 24)<= "10010000";
    when others => num7seg (31 downto 24)<= "11111111";
end case;

end process;

SEG: ContadorSincronoMOD60BCD port map (clock => clk_div, reset => '0', Q_unidades => seg_uni_Aux, Q_decenas => seg_dec_Aux);
MIN: ContadorSincronoMOD60BCD port map (clock => minClock,reset=>'0', Q_unidades =>min_uni_Aux,Q_decenas =>min_dec_Aux);
HRS: ContadorSincronoMOD12BCD port map (clock =>hrsClock, reset=>'0', Q_Uni=>hrs_uni_Aux, Q_Dec=>hrs_dec_Aux);
S7D: sSegDisplay port map (ck => clk_in, number => num7seg , seg => seg7d, an => an7d);

end estructural;