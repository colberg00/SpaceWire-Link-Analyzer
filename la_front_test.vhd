library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity la_front_test is
port(
	D_in : in std_logic;
	S_in : in std_logic;
	reset_in : in std_logic;
	two_bit_out : out std_logic_vector (1 downto 0)
);
end entity la_front_test;

architecture la_front_test_arch of la_front_test is

signal clk_save : std_logic;

component clock_create 
port(
D : in std_logic;
S : in std_logic;
Clk : out std_logic
);
end component;

component data_collect
Port(
Clk : in std_logic;
D : in std_logic;
two_bit_d : out std_logic_vector (1 downto 0)
);
end component;

begin

clock_gen : clock_create
	port map (
		D => D_in,
		S => S_in,
		Clk => clk_save
		);
		
data_col : data_collect
	port map (
		Clk => clk_save,
		D => D_in,
		two_bit_d => two_bit_out
		);
		

end architecture;
		