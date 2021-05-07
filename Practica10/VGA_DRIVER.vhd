----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2021 03:05:39 PM
-- Design Name: 
-- Module Name: VGA_DRIVER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_DRIVER is
  Port ( 
        clk_in1, reset: in std_logic;
        HS,VS,Video_ON: out std_logic;
        R,G,B: out std_logic_vector (3 downto 0)
  );
end VGA_DRIVER;
architecture Behavioral of VGA_DRIVER is

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

--constant H_Display_Area : integer := 639;
--constant H_Front_Porch : integer := 16;
--constant H_Retrace : integer := 96;
--constant H_Back_Porch : integer := 48;
--
--constant V_Display_Area : integer := 479;
--constant V_Front_Porch : integer := 10;
--constant V_Retrace : integer := 2;
--constant V_Back_Porch : integer := 33;

signal clk_out1, locked: std_logic;
signal column, row: std_logic_vector (9 downto 0):="0000000000";

signal VideoON: std_logic:='0';

begin

your_instance_name : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_out1,
  -- Status and control signals                
   reset => reset,
   locked => locked,
   -- Clock in ports
   clk_in1 => clk_in1
 );

Column_counter: process(clk_out1, reset)
begin
    if reset='1' then
        column<="0000000000";
    elsif (rising_edge(clk_out1)) then
        if(column = "1100011111") then
            column<="0000000000";
        else
            column<=column+'1';
        end if;
    else null;
    end if;
end process;

row_counter: process(clk_out1, reset, column)
begin
    if reset='1' then
        row<="0000000000";
    elsif (rising_edge(clk_out1)) then
        if (column = "1100011111")then
            if(row = "1000001100") then
                row<="0000000000";
            else
                row<=row+'1';
            end if;
        else null;
        end if;
    else null;
    end if;
end process;

--H_Sync: process (clk_out1, reset, column)
--begin
--    if(reset='1') then
--        HS<='0';
--    elsif (rising_edge(clk_out1)) then
--        if(column <= "1010001101" or column >= "1011101110") then
--            HS<='1';
--        else 
--            HS<='0';
--        end if;        
--    else null;
--    end if;
--end process;

H_Sync: process (clk_out1, reset, column)
begin
    if(reset='1') then
        HS<='0';
    elsif (rising_edge(clk_out1)) then
        if(column >="1100000") then
            HS<='0';
        else 
            HS<='1';
        end if;        
    else null;
    end if;
end process;

V_Sync: process (clk_out1, reset, row)
begin
    if(reset='1') then
        VS<='0';
    elsif (rising_edge(clk_out1)) then
        if(row <= "0111101000" or row >= "0111101011") then
            VS<='1';
        else 
            VS<='0';
        end if;        
    else null;
    end if;
end process;

video_on_p: process(clk_out1,reset, column, row)
begin
    if (reset='1') then
        Videoon<='0';
    elsif (rising_edge(clk_out1)) then
        if column <= "1001111101" and (row <= "0111011111") then
                        --637                    479
            VideoON<='1';
        else 
            VideoON<='0';
        end if;
    else null;
    end if;

end process;

draw: process (clk_out1, reset, column, row,videoon)
    VARIABLE clk_count : INTEGER := 0;
begin
    if reset='1' then
        R<="0000";
        G<="0000";
        B<="0000";
    elsif (rising_edge(clk_out1)) then
        if VideoOn='1' then
            if(clk_count < 125000000) then --WAIT 5 seconds
                if(column<"0000001010") then
                    R<="1111";
                    G<="0000";
                    B<="0000";
                    
                elsif(column>"0100111010" and column<"0101000100") then
                     R<="1111";
                     G<="0000";
                     B<="0000";
                elsif(column>"1001110101") then
                     R<="1111";
                     G<="0000";
                     B<="0000";
                                                    
                elsif(row<"0000001010") then
                    R<="1111";
                    G<="0000";
                    B<="0000";
                 elsif(row>"0011101010" and row<"0011110100") then
                    R<="1111";
                    G<="0000";
                    B<="0000";
                 elsif(row>"0111010101") then
                    R<="1111";
                    G<="0000";
                    B<="0000";
                 else
                    R<="0000";
                    G<="0000";
                    B<="1111";
                end if;
                clk_count:=clk_count+1;
           elsif (clk_count < 250000000) then
                if(column<=79) then                      -- BLANCO
                    R<="1111";
                    G<="1111";
                    B<="1111";
                elsif (column>79 and column<=159) then   --AMARILLO
                    R<="1111";
                    G<="1111";
                    B<="0000";
                elsif (column>159 and column<=239) then   --CYAN
                    R<="0000";
                    G<="1111";
                    B<="1111";
                elsif (column>239 and column<=319) then   --VERDE
                    R<="0000";
                    G<="1111";
                    B<="0000";
                elsif (column>319 and column<=399) then   --MAGENTA
                    R<="1111";
                    G<="0000";
                    B<="1111";
                elsif (column>399 and column<=479) then   --ROJO
                    R<="1111";
                    G<="0000";
                    B<="0000";
                elsif (column>479 and column<=559) then   --AZUL
                    R<="0000";
                    G<="0000";
                    B<="1111";
                elsif (column>559 and column<=639) then   --NEGRO
                    R<="0000";
                    G<="0000";
                    B<="0000";
                else null;
                end if;
                clk_count:=clk_count+1;
           else
                clk_count:=0;
           end if;
        else null;
        end if;
    
    end if;
end process;

video_on<=VideoOn;
end Behavioral;
