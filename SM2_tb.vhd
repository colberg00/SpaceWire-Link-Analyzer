library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_textio.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

entity SM2_tb is
end entity;

architecture SM2_tb_arch of SM2_tb is
	signal clk_tb :  std_logic;
	signal clk100mhz_tb : std_logic;
	signal reset_tb : std_logic;
	
	signal FCT_tb : std_logic;
	signal NUL_tb : std_logic;
	signal TS_tb : std_logic;
	signal Nchar_tb : std_logic;
	signal EEP_tb : std_logic;
	signal EOD_tb : std_logic;
	signal p_err_tb :	std_logic;
	
	signal ready_tb : std_logic;
	signal reset_out_tb : std_logic;
	
	component SM2
		port (
			clk : in std_logic;
			clk100mhz : in std_logic;
			reset : in std_logic;
			
			FCT : in std_logic;
			NUL : in std_logic;
			TS : in std_logic;
			Nchar : in std_logic;
			EEP : in std_logic;
			EOD : in std_logic;
			p_err : in	std_logic;
			
			ready : out std_logic;
			reset_out : out std_logic
			);
end component;

begin
	
	
		process
		begin 	
			clk_tb <= '0';
			wait for 20 ns;
			clk_tb <= '1';
			wait for 20 ns;
		end process;
		
		process
		begin 
			clk100mhz_tb <= '0';
			wait for 5 ns;
			clk100mhz_tb <= '1';
			wait for 5 ns;
		end process;
		
		process
		begin
			reset_tb <= '1';
			wait for 8 ns;
			reset_tb <= '0';
			wait;
		end process;
		
		
			DUT : SM2 port map(
				clk => clk_tb,
				clk100mhz => clk100mhz_tb,
				reset => reset_tb,
				
				FCT => FCT_tb,
				NUL => NUL_tb,
				TS => TS_tb,
				Nchar => Nchar_tb,
				EEP => EEP_tb,
				EOD => EOD_tb,
				p_err => p_err_tb,
				
				ready => ready_tb,
				reset_out => reset_out_tb
		);
		
		
		STIMULUS : process(Clk_tb)
		
			file Fin : TEXT open READ_MODE is "input_file_sm2.txt";
			variable current_line : line;
			variable FCT_v : std_logic;
			variable NUL_v : std_logic;
			variable TS_v : std_logic;
			variable Nchar_v : std_logic;
			variable EEP_v : std_logic;
			variable EOD_v : std_logic;
			variable p_err_v : std_logic;
			
			
			
			begin 
				if rising_edge(Clk_tb) then
					if reset_tb = '0' then
					
						readline(Fin, current_line);
						read(current_line, FCT_v);
						read(current_line, NUL_v);
						read(current_line, TS_v);
						read(current_line, Nchar_v);
						read(current_line, EEP_v);
						read(current_line, EOD_v);
						read(current_line, p_err_v);
						
						FCT_tb <= FCT_v;
						NUL_tb <= NUL_v;
						TS_tb <= TS_v;
						Nchar_tb <= Nchar_v;
						EEP_tb <= EEP_v;
						EOD_tb <= EOD_v;
						p_err_tb <= p_err_v;
						
					end if;
				end if;
			end process;
		end architecture;
		
		