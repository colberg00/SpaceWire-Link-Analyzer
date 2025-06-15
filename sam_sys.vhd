library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sam_sys is
port(
	reset_in : in std_logic;
	clk50mhz : in std_logic;
	
	data_out : out std_logic_vector(7 downto 0);
	EEP_out : out std_logic;
	EOD_out : out std_logic;
	Nchar_out : out std_logic;
	p_err_out : out std_logic;
	valid_out : out std_logic
	);
	
end entity sam_sys;

architecture sam_sys_arch of sam_sys is

signal d_out : std_logic :='0';
signal s_out : std_logic :='0'; 
signal clk_save : std_logic :='0';
signal two_bit_out : std_logic_vector(1 downto 0) := "00";
signal clk_stable : std_logic :='0';
signal data_done : std_logic_vector(7 downto 0) := "00000000";
signal eep_done : std_logic :='0';
signal eod_done : std_logic :='0';
signal nchar_done : std_logic :='0';
signal p_err_done : std_logic :='0';
signal valid_done : std_logic :='0';

component bit_feeder 
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        bit_out    : out std_logic;
        strobe_out : out std_logic
    );
end component bit_feeder;


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

component sys_col is
port(
	Data_in : in std_logic_vector(1 downto 0);
	reset_in : in std_logic;
	clk50mhz : in std_logic;
	clk_gen : in std_logic;
	
	data_out : out std_logic_vector(7 downto 0);
	EEP_out : out std_logic;
	EOD_out : out std_logic;
	Nchar_out : out std_logic;
	p_err_out : out std_logic;
	valid_out : out std_logic
	);
end component;





begin

bit_feed : bit_feeder 
    port map(
        clk => clk50mhz,
        reset => reset_in,
        bit_out => d_out,
        strobe_out => s_out
    );

clock_gen : clock_create
	port map (
		D => d_out,
		S => s_out,
		Clk => clk_save);
	
		
data_col : data_collect
	port map (
		Clk => clk_stable,
		D => d_out,
		two_bit_d => two_bit_out
		);

sam_sys : sys_col
port map(
	Data_in => two_bit_out,
	reset_in => reset_in,
	clk50mhz => clk50mhz,
	clk_gen => clk_stable,
	
	data_out => data_out,
	EEP_out => EEP_out,
	EOD_out => EOD_out,
	Nchar_out => Nchar_out,
	p_err_out => p_err_out,
	valid_out => valid_out
	);
	
clk_stable <= clk_save;
		

end;





