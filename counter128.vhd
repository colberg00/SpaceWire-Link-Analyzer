library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter128 is
port(
	clk : in std_logic; -- clk skal være 100 mhz for at passe med timing 
	start : in std_logic;
	reset : in std_logic;
	stop :out std_logic
	);
end entity;



architecture counter128_arch of counter128 is 

signal count : std_logic_vector(13 downto 0);


begin

process(clk)
	begin 
	
	if(rising_edge(clk)) then
		if reset = '1' then
			stop <= '0';
			count <= "00000000000000";
				-- 11001000000000 org men skal lige tjekkes
		elsif count = "00000010000000" then -- 128
			stop <= '1';
			count <= "00000000000000";
		elsif start = '1' then
			stop <= '0';
			count <= "00000000000001";
		else
			stop <= '0';
			count <= count + 1;
		end if;
	end if;
end process;

end architecture;
			