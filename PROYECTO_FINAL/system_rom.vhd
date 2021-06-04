library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity sistema_rom is  
port (
      address: in std_logic_vector(5 downto 0);
      lcd_data: out std_logic_vector (7 downto 0)
);
end sistema_rom;
  
architecture behavioral of sistema_rom is
  
begin
  case address is
    when "000001"=>  lcd_data<="01000001" --A
    when "000010"=>  lcd_data<="01000010" --B
    when "000011"=>  lcd_data<="01000011" --C
    when "000100"=>  lcd_data<="01000100" --D
    when "000101"=>  lcd_data<="01000101" --E
    when "000110"=>  lcd_data<="01000110" --F
    when "000111"=>  lcd_data<="01000111" --G
    when "001000"=>  lcd_data<="01001000" --H
    when "001001"=>  lcd_data<="01001001" --I
    when "001010"=>  lcd_data<="01001010" --J
    when "001011"=>  lcd_data<="01001011" --K
    when "001100"=>  lcd_data<="01001100" --L
    when "001100"=>  lcd_data<="01001101" --M
    when "001101"=>  lcd_data<="01001110" --N
    when "001110"=>  lcd_data<="01001111" --O 
    when "001111"=>  lcd_data<="01010000" --P
    when "010000"=>  lcd_data<="01010001" --Q
    when "010001"=>  lcd_data<="01010010" --R
    when "010010"=>  lcd_data<="01010011" --S
    when "010011"=>  lcd_data<="01010100" --T
    when "010100"=>  lcd_data<="01010101" --U
    when "010101"=>  lcd_data<="01010110" --V
    when "010110"=>  lcd_data<="01010111" --W
    when "010111"=>  lcd_data<="01011000" --X
    when "011000"=>  lcd_data<="01011001" --Y
    when "011001"=>  lcd_data<="01011010" --Z
    when "011010"=>  lcd_data<="00110000" --0
    when "011011"=>  lcd_data<="00110001" --1
    when "011100"=>  lcd_data<="00110010" --2
    when "011101"=>  lcd_data<="00110011" --3
    when "011110"=>  lcd_data<="00110100" --4
    when "011111"=>  lcd_data<="00110101" --5
    when "100000"=>  lcd_data<="00110110" --6
    when "100001"=>  lcd_data<="00110111" --7
    when "100010"=>  lcd_data<="00111000" --8
    when "100011"=>  lcd_data<="00111001" --9
    when "100100"=>  lcd_data<="00111010" --:
    when "100101"=>  lcd_data<="11000000"; -- salto de linea
    when "100110"=>  lcd_data<="00100011"
    
end behavioral;
