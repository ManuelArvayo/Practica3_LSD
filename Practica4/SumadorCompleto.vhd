----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2021 03:02:52 PM
-- Design Name: 
-- Module Name: SumadorCompleto - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SumadorCompleto is
    Port ( 
        X, Y, carryIn : in std_logic;
        sum, carryOut : out std_logic);
end SumadorCompleto;

architecture Behavioral of SumadorCompleto is

begin
    sum <= (X XOR Y) XOR Carryin;

    carryOut <= (CARRYIN AND(X XOR Y)) or (X and Y);


end Behavioral;
