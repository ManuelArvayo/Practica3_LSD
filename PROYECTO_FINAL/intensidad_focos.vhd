library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity dimmer is
    port(
      state: in std_logic_vector (2 downto 0);
      signal_out: out std_logic
    );
end dimmer;
  
architecture behavioral of dimmer is
  
  
type stateType is (S0, S25, S50, S75, S100);
	signal currentState, nextState : stateType;

subtype u20 is unsigned(19 downto 0);
signal counter      : u20 := x"00000";

constant clk_freq   : integer := 100_000_000;       -- Clock frequency in Hz (10 ns)
constant pwm_freq   : integer := 50;                -- PWM signal frequency in Hz (20 ms)
constant period     : integer := clk_freq/pwm_freq; -- Clock cycle count per PWM period
signal duty_cycle : integer := 50000;            -- Clock cycle count per PWM duty cycle

signal pwm_counter  : std_logic := '0';
signal stateHigh    : std_logic := '1';

begin

  
syncProcess: process(btn_in, Clk100m)
variable cur : u20 := counter;
	begin
		if (rising_edge(Clk100m)) then
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
    
    
			duty_cycle <= 50000;
			if (btn_in = '1') then
				nextState <= S45;
			else
				nextState <= S0;
			end if;
        
        
		when S25 =>
        
        
		duty_cycle <= 100000;
			if (btn_in = '1') then
				nextState <= S90;
			else
				nextState <= S45;
			end if;
        
        
		when S50 =>
        
		duty_cycle <= 150000;
			if (btn_in = '1') then
				nextState <= S135;
			else
				nextState <= S90;
			end if;
        
        
		when S75 =>
        
        
		duty_cycle <= 200000;
			if (btn_in = '1') then
				nextState <= S180;
			else
				nextState <= S135;
			end if;
        
        
		when S100 =>
        
        
		duty_cycle <= 250000;
			if (btn_in = '1') then
				nextState <= S0;
	        else
	            nextState <= S180;
			end if;
        
		when others =>
			nextState <= S0;
			
	end case;
	
	end process combProcess;


signal_out <= pwm_counter;
  end behavioral;
