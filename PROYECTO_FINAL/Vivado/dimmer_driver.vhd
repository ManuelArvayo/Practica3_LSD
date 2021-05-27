----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.05.2021 15:54:24
-- Design Name: 
-- Module Name: dimmer_driver - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity dimmer is
    port(
      Clk100m: in std_logic;
      state: in std_logic_vector (2 downto 0);
      signal_out: out std_logic
    );
end dimmer;
  
architecture behavioral of dimmer is
  
  
type stateType is (S0, S25, S50, S75, S100);
	signal currentState: stateType;

subtype u20 is unsigned(19 downto 0);
signal counter      : u20 := x"00000";

constant clk_freq   : integer := 100_000_000;       -- Clock frequency in Hz (10 ns)
constant pwm_freq   : integer := 50;                -- PWM signal frequency in Hz (20 ms)
constant period     : integer := clk_freq/pwm_freq; -- Clock cycle count per PWM period
signal duty_cycle : integer := 0;            -- Clock cycle count per PWM duty cycle

signal pwm_counter  : std_logic := '0';
signal stateHigh    : std_logic := '1';

begin

currentState <=	S0  when state="000" else
		S25 when state="001" else
		S50 when state="010" else
		S75 when state="011" else
		S100;
				
	
  
syncProcess: process(Clk100m)
variable cur : u20 := counter;
	begin
	    if (rising_edge(Clk100m)) then
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
	combProcess: process(currentState)
	begin
	case currentState is
		when S0 => duty_cycle <= 0;    -- 0%
		when S25 => duty_cycle <= 500000;    -- 25%
		when S50 => duty_cycle <= 1000000;    -- 50%
		when S75 => duty_cycle <= 1500000;      -- 75%
		when S100 => duty_cycle <= 2000000;     -- 100%
		when others => null;
			
	end case;
	
	end process combProcess;


signal_out <= pwm_counter;
  end behavioral;
