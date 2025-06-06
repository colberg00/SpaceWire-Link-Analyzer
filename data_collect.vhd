library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity data_collect is
Port(
Clk : in std_logic;
D : in std_logic;
two_bit_d : out std_logic_vector (1 downto 0)
);
end entity data_collect;


architecture data_collect_arch of data_collect is
signal bit0,bit1 : std_logic;

	begin
		process(Clk)
			begin
				if rising_edge(Clk) then
				bit0 <= D;
				two_bit_d <= bit0 & bit1;
				end if;
		end process;

		process(Clk)
			begin
				if falling_edge(Clk) then
				bit1 <= D;
				end if;
		end process;

end architecture data_collect_arch;