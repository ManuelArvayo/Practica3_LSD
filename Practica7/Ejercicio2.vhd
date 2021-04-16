library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ContadorUD is
 Port ( UD,CEP,CET,CP : in std_logic;
        Dec : in std_logic_vector(3 downto 0);
        Uni : in std_logic_vector(3 downto 0);
        Dec1 : out std_logic_vector(3 downto 0);
        Uni1 : out std_logic_vector(3 downto 0);
        seg7seg, an7seg: out std_logic_vector (7 downto 0)
      );
end ContadorUD;
  
architecture Behavorial of ContadorUD is
  component Contador is
   Port ( PE,UD,CEP,CET,CP : in std_logic;
        P : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0);
        TC : out std_logic
      );
  end component;
 
 component sSegDisplay is
    Port(ck : in  std_logic;                          -- 100MHz system clock
	 number : in  std_logic_vector (15 downto 0); -- eight digit number to be displayed
	 seg : out  std_logic_vector (7 downto 0);    -- display cathodes
	 an : out  std_logic_vector (7 downto 0));    -- display anodes (active-low, due to transistor complementing)
end component;
  
signal TC : std_logic:='0';
signal TC1 : std_logic;
signal PE : std_logic:='0';
signal TC2 : std_logic:='0';
signal Uniaux : std_logic_vector(3 downto 0);
signal Decaux : std_logic_vector(3 downto 0);
signal PE1 : std_logic:='0';
signal aux1 : std_logic;
signal res : std_logic_vector(3 downto 0);
signal ant : std_logic_vector(3 downto 0):="0000";
signal cont: integer range 0 to 24999999 := 0;
signal clk_div: std_logic:='0';
signal num7seg: std_logic_vector(15 downto 0);

begin
  
aux1 <= not PE;
Dec1 <= Decaux;
Uni1 <= Uniaux;

C1 : Contador
  port map (PE=>PE,UD=>UD,CEP=>CEP,CET=>CET,CP=>clk_div,P=>res,Q=>Uniaux,TC=>TC);
C2 : Contador
  port map (PE=>PE1,UD=>UD,CEP=>CEP,CET=>CET,CP=>TC1,P=>res,Q=>Decaux,TC=>TC2);
  
process (Uniaux,Decaux,aux1,UD)
  begin
   
   if rising_edge(CP) then
            if (cont = 24999999) then
                clk_div <= NOT(clk_div);
                cont <= 0;
            else
                cont <= cont+1;
            end if;
        end if;
   
   if(UD='1') then
     res <= "0000";
      if(Uniaux="1001") then
        PE <='0';
      elsif(Uniaux="0001") then
        ant <= "1000";
        PE <= '1';
      else
        PE <= '1';
  end if;
    if (Decaux="1001") then
      PE1 <= '0';
    else
      PE1 <= '1';
    end if;
      
  elsif (UD='0') then
    res <= "1001";
      if(Uniaux="0000") then
        PE <='0';
      elsif(Uniaux="0001") then
        ant <= "1000";
        PE <= '1';
      else
        PE <= '1';
      end if;
     if (Decaux="0000") then
      PE1 <= '0';
    else
      PE1 <= '1';
    end if;
  end if;
    
 if(aux1='0' and aux1 'event and ant = "1000") then
    TC1 <='1';
    else TC1 <='0';
 end if;

    
case (Uniaux) is
    when "0000" => num7seg (7 downto 0) <= "11000000"; -- 
    when "0001" => num7seg (7 downto 0) <= "11111001"; --
    when "0010" => num7seg (7 downto 0) <= "10100100"; -- 
    when "0011" => num7seg (7 downto 0) <= "10110000"; -- 
    when "0100" => num7seg (7 downto 0) <= "10011001"; --
    when "0101" => num7seg (7 downto 0) <= "10010010"; --
    when "0110" => num7seg (7 downto 0) <= "10000010"; --
    when "0111" => num7seg (7 downto 0) <= "11111000"; --
    when "1000" => num7seg (7 downto 0) <= "10000000"; --
    when "1001" => num7seg (7 downto 0) <= "10010000"; -- 
    when others => num7seg (7 downto 0) <= "11000000"; --
end case;

case (Decaux) is
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
end process;

d7s: sSegDisplay port map ( ck => CP, number => num7seg,seg => seg7seg, an => an7seg);
    
end Behavorial;
