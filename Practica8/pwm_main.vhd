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

type stateType is (S0, S45, S90, S135, S180);
	signal currentState, nextState : stateType;

subtype u20 is unsigned(19 downto 0);
signal counter      : u20 := x"00000";

constant clk_freq   : integer := 100_000_000;       -- Clock frequency in Hz (10 ns)
constant pwm_freq   : integer := 50;                -- PWM signal frequency in Hz (20 ms)
constant period     : integer := clk_freq/pwm_freq; -- Clock cycle count per PWM period
signal duty_cycle : integer := 50000;            -- Clock cycle count per PWM duty cycle

signal pwm_counter  : std_logic := '0';
signal stateHigh    : std_logic := '1';

signal num7seg: std_logic_vector (23 downto 0);

begin

s7D: sSegDisplay port map (ck => clk100m, number => num7seg, seg => SEGM, an => AN);


syncProcess: process(btn_in, Clk100m)
variable cur : u20 := counter;
	begin
		if (btn_in = '1') then 
			currentState <= S0;
		elsif (rising_edge(Clk100m)) then
			currentState <= nextState;
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
	end process syncProcess;

	--Combinatorial process (State and output decode)
	combProcess: process(currentState, btn_in)

	begin
	case currentState is
		when S0 =>
		    num7seg(23 downto 16)<="11000000"; --0
            num7seg(15 downto 8) <="11000000"; --0
            num7seg(7 downto 0) <="11000000";  --0
			duty_cycle <= 50000;
			if (btn_in = '1') then
				nextState <= S45;
			else
				nextState <= S0;
			end if;
		when S45 =>
		num7seg(23 downto 16)<="11000000"; --0
        num7seg(15 downto 8) <="10011001"; --4
        num7seg(7 downto 0) <="10010010";  --5
		duty_cycle <= 100000;
			if (btn_in = '1') then
				nextState <= S90;
			else
				nextState <= S45;
			end if;
		when S90 =>
		num7seg(23 downto 16)<="11000000"; --0
        num7seg(15 downto 8) <="10010000"; --9
        num7seg(7 downto 0) <="11000000";  --0
		duty_cycle <= 150000;
			if (btn_in = '1') then
				nextState <= S135;
			else
				nextState <= S90;
			end if;
		when S135 =>
		num7seg(23 downto 16)<="11111001"; --1
        num7seg(15 downto 8) <="10110000"; --3
        num7seg(7 downto 0) <="10010010";  --5
		duty_cycle <= 200000;
			if (btn_in = '1') then
				nextState <= S180;
			else
				nextState <= S135;
			end if;
		when S180 =>
		num7seg(23 downto 16)<="11111001"; --1
        num7seg(15 downto 8) <="10000000"; --8
        num7seg(7 downto 0) <="11000000";  --0
		duty_cycle <= 250000;
			if (btn_in = '1') then
				nextState <= S0;
	        else
	            nextState <= S180;
			end if;
		when others =>
			nextState <= S0;
			
	end case;
	
 --  case nextState is
 --      when s0 =>
 --          num7seg(23 downto 16)<="11000000"; --0
 --          num7seg(15 downto 8) <="11000000"; --0
 --          num7seg(7 downto 0) <="11000000";  --0
 --      when s45 =>
 --          num7seg(23 downto 16)<="11000000"; --0
 --          num7seg(15 downto 8) <="10011001"; --4
 --          num7seg(7 downto 0) <="10010010";  --5
 --      when s90 =>
 --          num7seg(23 downto 16)<="11000000"; --0
 --          num7seg(15 downto 8) <="10010000"; --9
 --          num7seg(7 downto 0) <="11000000";  --0
 --      when s135 =>
 --          num7seg(23 downto 16)<="11111001"; --1
 --          num7seg(15 downto 8) <="10110000"; --3
 --          num7seg(7 downto 0) <="10010010";  --5
 --      when s180 =>
 --          num7seg(23 downto 16)<="11111001"; --1
 --          num7seg(15 downto 8) <="10000000"; --8
 --          num7seg(7 downto 0) <="11000000";  --0
 --      when others =>
 --          null;    
 --  end case;
	end process combProcess;


pwm_out <= pwm_counter;
end Behavioral;