----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 10:05:49 PM
-- Design Name: 
-- Module Name: pwm_main - Behavioral
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

entity main_pwm is  
port (
    clk100m : in std_logic;
    btn_in  : in std_logic;
    pwm_out : out std_logic;
    SEGM: out std_logic_vector (7 downto 0);
    AN : out std_logic_vector (7 downto 0)
);
end main_pwm;

architecture Behavioral of main_pwm is

component sSegDisplay is
    Port(ck : in  std_logic;                          -- 100MHz system clock
			number : in  std_logic_vector (23 downto 0); -- eight digit number to be displayed
			seg : out  std_logic_vector (7 downto 0);    -- display cathodes
			an : out  std_logic_vector (7 downto 0));    -- display anodes (active-low, due to transistor complementing)
end component;


subtype u20 is unsigned(19 downto 0);
signal counter      : u20 := x"00000";

constant clk_freq   : integer := 100_000_000;       -- Clock frequency in Hz (10 ns)
constant pwm_freq   : integer := 50;                -- PWM signal frequency in Hz (20 ms)
constant period     : integer := clk_freq/pwm_freq; -- Clock cycle count per PWM period
signal duty_cycle : integer := 50000;            -- Clock cycle count per PWM duty cycle

signal pwm_counter  : std_logic := '0';
signal stateHigh    : std_logic := '1';

signal numero: std_logic_vector (2 downto 0);
signal num7seg: std_logic_vector (23 downto 0);
signal contador: std_logic_vector(2 downto 0):="000";
signal reset: std_logic;

begin

reset <= contador(2);
s7D: sSegDisplay port map (ck => clk100m, number => num7seg, seg => SEGM, an => AN);

pwm_generator : process(clk100m) is
variable cur : u20 := counter;
begin
    if (rising_edge(clk100m) and btn_in = '1') then
        cur := cur + 1;  
        counter <= cur;
        if (cur <= duty_cycle) then
            pwm_counter <= '1'; 
        elsif (cur > duty_cycle) then
            pwm_counter <= '0';
        elsif (cur = period) then
            cur := x"00000";
        end if;  
    end if;
end process;


boton: process (btn_in)
begin
    if reset='1' then
        contador<="000";
    elsif btn_in ='1' then
       contador <= contador + '1';
    end if;
end process;

decoder_contador: process (contador)
begin
    if   contador<="000" then
        duty_cycle<=50000;  -- 0 grados
    elsif contador<="001" then
        duty_cycle<=100000; -- 45 grados
    elsif contador<="010" then
        duty_cycle<=150000; -- 90 grados
    elsif contador<="011" then
        duty_cycle<=200000; -- 135 grados
    elsif contador<="100" then
        duty_cycle<=250000; -- 180 grados
    end if;
end process;


decoder_duty_cycle: process(duty_cycle)
begin
if (duty_cycle = 50000) then
        numero <= "000";
   elsif (duty_cycle = 100000) then
        numero <= "001";
   elsif (duty_cycle = 150000) then
        numero <= "010";
   elsif (duty_cycle = 200000) then
        numero <= "011";
   elsif (duty_cycle = 250000) then
        numero <= "100";
   end if;
   
end process;

decoder_display: process(numero)
begin
    case numero is
        when "000" =>
            num7seg(23 downto 16)<="11000000"; --0
            num7seg(15 downto 8) <="11000000"; --0
            num7seg(7 downto 0) <="11000000";  --0
        when "001" =>
            num7seg(23 downto 16)<="11000000"; --0
            num7seg(15 downto 8) <="10011001"; --4
            num7seg(7 downto 0) <="10010010";  --5
        when "010" =>
            num7seg(23 downto 16)<="11000000"; --0
            num7seg(15 downto 8) <="10010000";
            num7seg(7 downto 0) <="11000000";
        when "011" =>
            num7seg(23 downto 16)<="11111001";
            num7seg(15 downto 8) <="10110000";
            num7seg(7 downto 0) <="10010010";
        when "100" =>
            num7seg(23 downto 16)<="11111001";
            num7seg(15 downto 8) <="10000000";
            num7seg(7 downto 0) <="11000000";
        when others =>
            null;    
    end case;
end process;

pwm_out <= pwm_counter;
end Behavioral;