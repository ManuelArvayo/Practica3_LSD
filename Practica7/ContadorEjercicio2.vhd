library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
  
entity Contador is
 Port ( Par_En,Up_Dn,CE_Par,CE_Trick,clk : in std_logic;
        Par_in : in std_logic_vector(3 downto 0);
        Q : out std_logic_vector(3 downto 0);
        Terminal_C : out std_logic
      );
end Contador;
  
architecture Behavorial of Contador is
  signal count : std_logic_vector(3 downto 0):= "0001";
  signal aux : std_logic_vector(3 downto 0):="0000";
begin
  Process(clk,Par_En,CE_Par,CE_Trick,Up_Dn,aux)
begin
if (rising_edge(clk)) then
	if Par_En='0' then
		aux<=Par_in;
		Terminal_C <= '1';
	else
		if (CE_Par='0' and CE_Trick='0')then
			if (Up_Dn='1') then
				    aux <= std_logic_vector(unsigned(aux) + unsigned(count));
				if(aux = "1000") then
					Terminal_C <= '0';
         	 	 	else 
					Terminal_C <= '1';
      		 		end if;
      			else
       	   			aux <= std_logic_vector(unsigned(aux) - unsigned(count));
            			if(aux = "0001") then
            				Terminal_C <= '0';
            			else 
					Terminal_C <= '1';
            			end if;
      			end if;
		else 
			null;
     		end if;
	end if;
end if;
end process;

Q <= aux;

  end Behavorial;
