library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_domain_shift is
	port (
	clk_in : in std_logic;
	clk_out : in std_logic;
	signal_in : in std_logic;
	reset : in std_logic;
	signal_out : out std_logic
	);
end clock_domain_shift;

architecture clock_domain_shift_arch of clock_domain_shift is
 
type state_type is (IDLE, SEND, WAIT_ACK);
signal state : state_type := IDLE;

signal signal_in_prev : std_logic :='0';
signal signal_in_pulse : std_logic := '0';

signal signal_hold : std_logic;
signal counter : std_logic_vector (1 downto 0) := (others => '0');


signal reg1,reg2 : std_logic;

signal ack : std_logic;

signal a_reg1, a_reg2 : std_logic;



begin

	process (clk_in) 
	begin
		if rising_edge(clk_in) then
				signal_in_prev <= signal_in;
			if (signal_in ='1' and signal_in_prev='0') then
				signal_in_pulse <= '1';
			else
				signal_in_pulse <= '0';
			end if;
		end if;
	end process;
		
		process(clk_in)
		begin
			if rising_edge(clk_in) then
				if reset = '1' then 
						signal_hold <= '0';
						state <= IDLE;
						counter <= (others => '0');
				else
				
					case state is
						when IDLE =>
							if signal_in_pulse ='1' then
								signal_hold <= '1';
								counter <= "01";
								state <= SEND;
							end if;
							
							
						when SEND =>
							if counter = "10" then
								signal_hold <= '0';
								counter <= (others => '0');
								state <= IDLE;
							else 
								counter <= counter + 1;
							end if;
							
						when WAIT_ACK =>
							if a_reg2 = '1' then
								state <= IDLE;
							end if;
							
					end case;
				end if;
		end if;
	end process;
	
	process (clk_out)
	begin
		if rising_edge (clk_out) then
			reg1 <= signal_hold;
			reg2 <= reg1;
		end if;
	end process;
	
	process (clk_out)
	begin
		if rising_edge (clk_out) then
			signal_out <= reg2 AND NOT reg1;
		end if;
	end process;
	
	process (clk_out)
	begin
		if rising_edge (clk_out) then
			ack <= reg2;
		end if;
	end process;

	
	process (clk_in)
	begin
		if rising_edge(clk_in) then
			a_reg1 <= ack;
			a_reg2 <= a_reg1;
		end if;
	end process;

end architecture clock_domain_shift_arch;