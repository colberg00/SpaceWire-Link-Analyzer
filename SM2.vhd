library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SM2 is
port (
	clk100mhz : in std_logic;
	reset : in std_logic;
	
	FCT : in std_logic;
	NUL : in std_logic;
	TS : in std_logic;
	Nchar : in std_logic;
	EEP : in std_logic;
	EOD : in std_logic;
	p_err : in	std_logic;
	
	--ready : out std_logic;
	reset_out : out std_logic
	);
end entity;

architecture SM2_arch of SM2 is

type state_type is (reset_state, errorwait, started_ready, connecting, run);
signal current_state : state_type := reset_state;
signal next_state  : state_type;

signal start64 : std_logic;
signal start64_reg : std_logic;
signal waitdone64 : std_logic;
--signal done64 : std_logic;

signal start128 : std_logic;
signal start128_reg : std_logic;
signal waitdone128 : std_logic;
--signal done128 : std_logic;

signal count64 : std_logic_vector(9 downto 0);
signal count128 : std_logic_vector(13 downto 0);

--component counter64 
--port(
	--clk : in std_logic; 
	--start : in std_logic;
	--reset : in std_logic;
	--stop :out std_logic
	--);
--end component;

--component counter128
--port(
	--clk : in std_logic; 
	--start : in std_logic;
	--reset : in std_logic;
	--stop :out std_logic
	--);
--end component;


	begin
	
	--count64 : counter64 port map ( clk => clk100mhz, start => start64, reset => reset, stop => done64);
	--count128 : counter128 port map ( clk => clk100mhz, start => start128, reset => reset, stop => done128);
	
	process(clk100mhz, reset)
	begin
		if reset = '1' then
			current_state <= reset_state;
		elsif rising_edge(clk100mhz) then
			current_state <= next_state;
		end if;
	end process;
	
	process(current_state)
	begin
			case current_state is
				when errorwait =>
					--ready <= '1';
					reset_out <= '0';
				when reset_state =>
					--ready <= '0';
					reset_out <= '1';
				when others =>
					--ready <= '0';
					reset_out <= '0';
				end case;
		end process;
			
--	process(current_state, done64, done128)
	--begin
		--waitdone64 <= '0';
		--waitdone128 <= '0';
		--case current_state is 
		--	when reset_state =>
				--if done64 = '1' then
					--waitdone64 <= '1';
				--end if;
			--when errorwait|started_ready|connecting =>
				--if done128 = '1' then 
					--waitdone128 <= '1';
				--end if;
			--when others =>
				--null;
		--end case;
	--end process;
	
	process(current_state)
	begin
		start64 <= '0';
		start128 <= '0';
		case current_state is
			when reset_state =>
				start64 <= '1';
			when errorwait|started_ready|connecting =>
				start128 <= '1';
			when others =>
				null;
		end case;
	end process;
		
		
		process (FCT, NUL, TS, Nchar, EEP, EOD, p_err, waitdone64, waitdone128, current_state)
		begin
			next_state <= current_state;
			case current_state is
				when reset_state => 
					if EEP = '1' or FCT = '1' or Nchar = '1' or TS = '1' --or p_err = '1' 
					then
						next_state <= reset_state;
					elsif waitdone64 = '1' then
						next_state <= errorwait;
					end if;
				
				when errorwait =>
					if EEP = '1' or FCT = '1' or Nchar = '1' or TS = '1' --or p_err = '1'
					then
						next_state <= reset_state;
					elsif waitdone128 = '1' then 
						next_state <= started_ready;
					end if;
				
				when started_ready =>
					if EEP = '1' or FCT = '1' or Nchar = '1' or TS = '1' or waitdone128 = '1' --or p_err = '1'
					then
						next_state <= reset_state;
					elsif NUL = '1' then
						next_state <= connecting;
					end if;
				
				when connecting =>
					if EEP = '1' or Nchar = '1' or TS = '1' or waitdone128 = '1' --or p_err = '1'
					then
						next_state <= reset_state;
					elsif FCT = '1' then
						next_state <= run;
					end if;
				
				when run =>
					if EEP = '1' -- or p_err = '1'
					then
						next_state <= reset_state;
					end if;
					
				when others =>
					next_state <= reset_state;
			end case;
			
		end process;
		
process(clk100mhz)
begin 
	if rising_edge(clk100mhz) then
		if reset = '1' then
			waitdone64 <= '0';
			count64 <= (others => '0');
			start64_reg <= '0';
			
		elsif start64 = '1' and start64_reg = '0' then  -- detect new start
			waitdone64 <= '0';
			count64 <= "0000000001";
			start64_reg <= '1';
		
		elsif count64 = "0001000000" then  -- 64
			waitdone64 <= '1';
			count64 <= (others => '0');
			start64_reg <= '0';
		
		elsif start64 = '0' then  -- reset latch if signal drops
			start64_reg <= '0';
		
		else
			waitdone64 <= '0';
			count64 <= count64 + 1;
		end if;
	end if;
end process;

process(clk100mhz)
begin 
	if rising_edge(clk100mhz) then
		if reset = '1' then
			waitdone128 <= '0';
			count128 <= (others => '0');
			start128_reg <= '0';
		
		elsif start128 = '1' and start128_reg = '0' then  -- detect new start
			waitdone128 <= '0';
			count128 <= "00000000000001";
			start128_reg <= '1';
		
		elsif count128 = "00000010000000" then  -- 128
			waitdone128 <= '1';
			count128 <= (others => '0');
			start128_reg <= '0';
		
		elsif start128 = '0' then
			start128_reg <= '0';
		
		else
			waitdone128 <= '0';
			count128 <= count128 + 1;
		end if;
	end if;
end process;


				
	
end architecture;