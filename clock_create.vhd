library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_create is
port(
D : in std_logic;
S : in std_logic;
Clk : out std_logic
);
end entity clock_create;

architecture clock_create_arch of clock_create is
begin

 Clk <= D xor S;

end architecture clock_create_arch; 