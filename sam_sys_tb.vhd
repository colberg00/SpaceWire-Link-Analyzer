library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_textio.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

entity sam_sys_tb is
end entity;


architecture Sam_sys_tb_arch of sam_sys_tb is
	signal reset_in_tb : std_logic :='0';
	signal clk50mhz_tb : std_logic :='0';
	signal clk25mhz_tb : std_logic :='0';

	signal data_out_tb : std_logic_vector(7 downto 0) := "00000000";
	signal EEP_out_tb : std_logic :='0';
	signal EOD_out_tb : std_logic :='0';
	signal Nchar_out_tb : std_logic :='0';
	signal p_err_out_tb : std_logic :='0';
	signal valid_out_tb : std_logic :='0';
	
	signal count : std_logic_vector(1 downto 0) := "00";
	
component sam_sys is
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
	
end component sam_sys;


begin

		process
		begin 	
			clk50mhz_tb <= '0';
			wait for 10 ns;
			clk50mhz_tb <= '1';
			wait for 10 ns;
		end process;
		
			process
		begin 	
			clk25mhz_tb <= '0';
			wait for 20 ns;
			clk25mhz_tb <= '1';
			wait for 20 ns;
		end process;
		
		process
		begin
			reset_in_tb <= '0';
			wait for 40 ns;
			reset_in_tb <= '1';
			wait for 20 ns;
			reset_in_tb <= '0';
			wait;
		end process;
		
		
	DUT : sam_sys
    port map(
			reset_in => reset_in_tb,
			clk50mhz => clk50mhz_tb,
			
			data_out => data_out_tb,
			EEP_out => EEP_out_tb,
			EOD_out => EOD_out_tb, 
			Nchar_out => Nchar_out_tb,
			p_err_out => p_err_out_tb,
			valid_out => valid_out_tb);
			
	STIMULUS : process(clk25mhz_tb)
			file Fout : TEXT open WRITE_MODE is "output_file.txt";
			variable current_write_line : line;
		
			
			begin 
				if rising_edge(clk25mhz_tb) then
						write(current_write_line, data_out_tb);
						write(current_write_line, EEP_out_tb);
						write(current_write_line, EOD_out_tb);
						write(current_write_line, Nchar_out_tb);
						write(current_write_line, p_err_out_tb);
						write(current_write_line, valid_out_tb);
						writeline(Fout, current_write_line);
						
				end if;
			end process;

			
end architecture sam_sys_tb_arch;