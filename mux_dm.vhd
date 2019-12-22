library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity mux_dm is
port(x,y : in STD_LOGIC_VECTOR(31 downto 0);
s: in STD_LOGIC;
z: out STD_LOGIC_VECTOR(31 downto 0));
end mux_dm ;
 
architecture Behavioral of mux_dm is
 
begin
 
process (x,y,s) is
begin
if (s ='0') then
z <= x;
else
z <= y;
end if;
end process;
 
end Behavioral;
