--Stardard IEEE library
library IEEE;
use IEEE.std_logic_1164.all;

-- Entity port declaration
entity FSM is port(
	Run	: in std_logic;
--	stim : out std_logic_vector(2 downto 0);
	Clk, Rst: in std_logic;
	Result 	: out std_logic);
end FSM;

-- Architecture of FSM
architecture struct of FSM is 
	type stateType is (S0, S45, S90, S135, S180);
	signal currentState, nextState : stateType;
begin
	--Syncrhonous process (State FFs)
	syncProcess: process(Rst, Clk)
	begin
		if (Rst = '1') then 
			currentState <= S0;
		elsif (rising_edge(Clk)) then
			currentState <= nextState;

		end if;
	end process syncProcess;

	--Combinatorial process (State and output decode)
	combProcess: process(currentState, Run)

	begin
	case currentState is
		when S0 =>
			duty_cycle <= 50_000;
			if (Run = '1') then
				nextState <= S45;
			else
				nextState <= S0;
			end if;
		when S45 =>
		duty_cycle <= 100_000;
			if (Run = '1') then
				nextState <= S90;
			else
				nextState <= S1;
			end if;
		when others =>
			Result <= '0';
			nextState <= S0;
	end case;
	end process combProcess;
end struct;

