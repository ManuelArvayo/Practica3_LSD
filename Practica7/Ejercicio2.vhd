library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ContadorUD is
 Port ( Up_Down,CEP,CET : in std_logic;
        clk: in std_logic;
        seg7seg, an7seg: out std_logic_vector (7 downto 0)
      );
end ContadorUD;

architecture behavioral of ContadorUD is
  
component Contador is
 Port ( Par_En, 	
	Up_Dn,CE_Par,CE_Trick,clk : in std_logic;
        Par_in : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0);
        Terminal_C : out std_logic
      );
end component;
 
 component sSegDisplay is
    Port(ck : in  std_logic;                          -- 100MHz system clock
	 number : in  std_logic_vector (15 downto 0); -- eight digit number to be displayed
	 seg : out  std_logic_vector (7 downto 0);    -- display cathodes
	 an : out  std_logic_vector (7 downto 0));    -- display anodes (active-low, due to transistor complementing)
end component;
  
signal TC_unidades_aux: std_logic:='0';
signal PE_unidades_aux: std_logic:='0';
signal TC_decenas_aux: std_logic:='0';
signal PE_decenas_aux : std_logic:='0';

signal Uni_aux : std_logic_vector(3 downto 0);
signal Dec_aux : std_logic_vector(3 downto 0);

signal paralela : std_logic_vector(3 downto 0);
signal cont: integer range 0 to 24999999 := 0;
signal clk_div: std_logic:='0';
signal num7seg: std_logic_vector(15 downto 0);
signal clk_dec: std_logic:='1';

begin
  
--aux1 <= not PE;

C_unidades : Contador port map( 
	Par_En 		=> PE_unidades_aux,
	Up_Dn 		=> Up_Down,
	CE_Par 		=> CEP,
	CE_Trick 	=> CET,
	clk 		=> clk_div,
        Par_in		=> paralela,
        Q 		=> Uni_aux,
        Terminal_C 	=> TC_unidades_aux
      );

C_decenas : Contador port map( 
	Par_En 		=> PE_decenas_aux,
	Up_Dn 		=> Up_Down,
	CE_Par 		=> CEP,
	CE_Trick 	=> CET,
	clk 		=> clk_dec,
        Par_in		=> paralela,
        Q 		=> Dec_aux,
        Terminal_C 	=> TC_decenas_aux
      );

process (clk,Uni_aux,Dec_aux,Up_Down,TC_unidades_aux,TC_decenas_aux)
begin
	if(Up_Down='1') then
        if(Uni_aux="0000" and TC_unidades_aux='1') then
  	         clk_dec <='1';
  	    else 
  	         clk_dec <='0';
  	    end if;
  	
    else
        if (Uni_aux="1001" and TC_unidades_aux='1') then
            clk_dec <='1';
  	     else 
  	         clk_dec <='0';
  	     end if;
  	end if;
  	
  	
	if rising_edge(clk) then  
		if (cont = 24999999) then
                	clk_div <= NOT(clk_div);
                	cont <= 0;
            	else
                	cont <= cont+1;
            	end if;
        end if;
   
	if(Up_Down ='1') then
    		paralela <= "0000";
     		if(TC_unidades_aux='0') then
        		PE_unidades_aux <='0';
      			if(TC_decenas_aux='0') then
				PE_decenas_aux <='0';
			else
				PE_decenas_aux <='1';
			end if;
      		else
        		PE_unidades_aux <= '1';
		end if;

  	else
    		paralela <= "1001";
      		if(TC_unidades_aux ='0') then
        		PE_unidades_aux <='0';
      			if(TC_decenas_aux ='0') then
				PE_decenas_aux <='0';
			else
				PE_decenas_aux <='1';
			end if;
     		else
        		PE_unidades_aux <= '1';
     		end if;
  	end if;
  
    
case (Uni_aux) is
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

case (Dec_aux) is
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

d7s: sSegDisplay port map ( ck => clk, number => num7seg,seg => seg7seg, an => an7seg);
    
end behavioral;