
--=======================================================
--  Entity decleration
--=======================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DE10_LITE_Empty_Top is
    port(
	   MAX10_CLK1_50 : in std_logic;
		KEY :        in std_logic_vector(0 downto 0);
		GPIO : inout std_logic_vector(0 downto 0);
		LEDR : out std_logic_vector(7 downto 0);
		HEX0 : out std_logic_vector(7 downto 0);
		HEX1 : out std_logic_vector(7 downto 0);
		HEX2 : out std_logic_vector(7 downto 0);
		HEX3 : out std_logic_vector(7 downto 0);
		HEX4 : out std_logic_vector(7 downto 0));
	
end entity DE10_LITE_Empty_Top;

    --DE10_LITE_Empty_Top: 
    --
	-------------- CLOCK ----------
	--input 		          		ADC_CLK_10,
	--input 		          		MAX10_CLK1_50,
	--input 		          		MAX10_CLK2_50,
    --
	-------------- SDRAM ----------
	--output		    [12:0]		DRAM_ADDR,
	--output		     [1:0]		DRAM_BA,
	--output		          		DRAM_CAS_N,
	--output		          		DRAM_CKE,
	--output		          		DRAM_CLK,
	--output		          		DRAM_CS_N,
	--inout 		    [15:0]		DRAM_DQ,
	--output		          		DRAM_LDQM,
	--output		          		DRAM_RAS_N,
	--output		          		DRAM_UDQM,
	--output		          		DRAM_WE_N,
    --
	-------------- SEG7 ----------
	--output		     [7:0]		HEX0,
	--output		     [7:0]		HEX1,
	--output		     [7:0]		HEX2,
	--output		     [7:0]		HEX3,
	--output		     [7:0]		HEX4,
	--output		     [7:0]		HEX5,
    --
	-------------- KEY ----------
	--input 		     [1:0]		KEY,
    --
	-------------- LED ----------
	--output		     [9:0]		LEDR,
    --
	-------------- SW ----------
	--input 		     [9:0]		SW,
    --
	-------------- VGA ----------
	--output		     [3:0]		VGA_B,
	--output		     [3:0]		VGA_G,
	--output		          		VGA_HS,
	--output		     [3:0]		VGA_R,
	--output		          		VGA_VS,
    --
	-------------- Accelerometer ----------
	--output		          		GSENSOR_CS_N,
	--input 		     [2:1]		GSENSOR_INT,
	--output		          		GSENSOR_SCLK,
	--inout 		          		GSENSOR_SDI,
	--inout 		          		GSENSOR_SDO,
    --
	-------------- Arduino ----------
	--inout 		    [15:0]		ARDUINO_IO,
	--inout 		          		ARDUINO_RESET_N,
    --
	-------------- GPIO, GPIO connect to GPIO Default ----------
	--inout 		    [35:0]		GPIO




--=======================================================
-- Architecture declaration
--=======================================================
architecture rtl of DE10_LITE_Empty_Top is

component gpio_lite is
	port (
		dout   : out   std_logic_vector(0 downto 0);                    --   dout.export
		din    : in    std_logic_vector(0 downto 0) := (others => '0'); --    din.export
		pad_io : inout std_logic_vector(0 downto 0) := (others => '0'); -- pad_io.export
		oe     : in    std_logic_vector(0 downto 0) := (others => '0')  --     oe.export
	);
end component gpio_lite;

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


signal d_out : std_logic;
signal s_out : std_logic; 
signal clk_save : std_logic;
signal two_bit_out : std_logic_vector(1 downto 0);
signal clk_stable : std_logic;
signal data_done : std_logic_vector(7 downto 0);
signal eep_done : std_logic;
signal eod_done : std_logic;
signal nchar_done : std_logic;
signal p_err_done : std_logic;
signal valid_done : std_logic;



begin

bit_feed : bit_feeder 
    port map(
        clk => MAX10_CLK1_50,
        reset => KEY(0),
        bit_out => d_out,
        strobe_out => s_out
    );

clock_gen : clock_create
	port map (
		D => d_out,
		S => s_out,
		Clk => clk_save
		);
		
buff1 : gpio_lite
	port map (
		dout(0) => clk_stable,
		din(0) => clk_save,
		pad_io(0) => GPIO(0),
		oe(0) => '1'
			);
	
		
data_col : data_collect
	port map (
		Clk => clk_save,
		D => d_out,
		two_bit_d => two_bit_out
		);
		

sam_sys : sys_col
port map(
	Data_in => two_bit_out,
	reset_in => KEY(0),
	clk50mhz => MAX10_CLK1_50,
	clk_gen => clk_stable,
	
	data_out => data_done,
	EEP_out => eep_done,
	EOD_out => eod_done,
	Nchar_out => nchar_done,
	p_err_out => p_err_done,
	valid_out => valid_done
	);
		
		
		
		
process (MAX10_CLK1_50)
	begin
	
	if rising_edge(MAX10_CLK1_50) then
		LEDR(7 downto 0) <= data_done;
		
		
			case eep_done is
			when '0' => HEX0 <= "01000000"; --0
			when '1' => HEX0 <= "01111001"; --1
			when others => HEX0 <= "01111111";
			end case;
		
	
	
			case eod_done is
			when '0' => HEX1 <= "01000000"; --0
			when '1' => HEX1 <= "01111001"; --1
			when others => HEX1 <= "01111111";
			end case;

	
			case nchar_done is
			when '0' => HEX2 <= "01000000"; --0
			when '1' => HEX2 <= "01111001"; --1
			when others => HEX2 <= "01111111";
			end case;

		

		
			case p_err_done is
			when '0' => HEX3 <= "01000000"; --0
			when '1' => HEX3 <= "01111001"; --1
			when others => HEX3 <= "01111111";
			end case;

	
		
			case valid_done is
			when '0' => HEX4 <= "01000000"; --0
			when '1' => HEX4 <= "01111001"; --1
			when others => HEX4 <= "01111111";
			end case;
		

	
	end if;
end process;



end;






