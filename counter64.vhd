library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter64 is
port(					 
	clk : in std_logic; -- clk skal være 100 mhz for at passe med timing
	start : in std_logic;
	reset : in std_logic;
	stop :out std_logic
	);
end entity;



architecture counter64_arch of counter64 is 

signal count : std_logic_vector(9 downto 0);




begin

process(clk)
	begin 
	
	if(rising_edge(clk)) then
		if reset = '1' then
			stop <= '0';
			count <= "0000000000";	 
		elsif count = "0001000000" then --64
			stop <= '1';
			count <= "0000000000";
		elsif start = '1' then
			stop <= '0';
			count <= "0000000001";
		else
			stop <= '0';
			count <= count + 1;
		end if;
	end if;
end process;

end architecture;
			