----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2021 02:59:17 PM
-- Design Name: 
-- Module Name: pr4 - Behavioral
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

entity addsub08 is
    port (
	       W1 : in STD_LOGIC_VECTOR (7 downto 0);
           W2 : in STD_LOGIC_VECTOR (7 downto 0);
           sel : in STD_LOGIC;
           c_out : out STD_LOGIC;
           c_ov : out STD_LOGIC;
           R : out STD_LOGIC_VECTOR (7 downto 0));
end addsub08;

architecture Behavioral of addsub08 is

component SumadorCompleto is 
port (
        X, Y, carryIn : in std_logic;
        sum, carryOut : out std_logic
    );
end component;
signal co,c1,c2,c3,c4,c5,c6,c7,b0,b1,b2,b3,b4,b5,b6,b7 : std_logic;

begin
b0 <= W2(0) xor Sel;
b1 <= W2(1) xor Sel;
b2 <= W2(2) xor Sel;
b3 <= W2(3) xor Sel;
b4 <= W2(4) xor Sel;
b5 <= W2(5) xor Sel;
b6 <= W2(6) xor Sel;
b7 <= W2(7) xor Sel;
fa1 : SumadorCompleto port map (W1(0),b0,Sel,R(0),c1);
fa2 : SumadorCompleto port map (W1(1),b1,c1,R(1),c2);
fa3 : SumadorCompleto port map (W1(2),b2,c2,R(2),c3);
fa4 : SumadorCompleto port map (W1(3),b3,c3,R(3),c4);
fa5 : SumadorCompleto port map (W1(4),b4,c4,R(4),c5);
fa6 : SumadorCompleto port map (W1(5),b5,c5,R(5),c6);
fa7 : SumadorCompleto port map (W1(6),b6,c6,R(6),c7);
fa8 : SumadorCompleto port map (W1(7),b7,c7,R(7),co);
c_out <= co and (not Sel);
c_ov <= co xor c7;
end Behavioral;
