----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2019 12:59:20 PM
-- Design Name: 
-- Module Name: assign1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity left_rot is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           outx : out STD_LOGIC_VECTOR (31 downto 0));
end left_rot;

architecture Behavioral of left_rot is

begin
WITH b(3 DOWNTO 0) SELECT
    outx<=	a(30 DOWNTO 0) & a(31) WHEN "0001",
	a(29 DOWNTO 0) & a(31 DOWNTO 30) WHEN "0010",
	a(28 DOWNTO 0) & a(31 DOWNTO 29) WHEN "0011",
	a(27 DOWNTO 0) & a(31 DOWNTO 28) WHEN "0100",
	a(26 DOWNTO 0) & a(31 DOWNTO 27) WHEN "0101",
	a(25 DOWNTO 0) & a(31 DOWNTO 26) WHEN "0110",
	a(24 DOWNTO 0) & a(31 DOWNTO 25) WHEN "0111",
	a(23 DOWNTO 0) & a(31 DOWNTO 24) WHEN "1000",
	a(22 DOWNTO 0) & a(31 DOWNTO 23) WHEN "1001",
	a(21 DOWNTO 0) & a(31 DOWNTO 22) WHEN "1010",
	a(20 DOWNTO 0) & a(31 DOWNTO 21) WHEN "1011",
	a(19 DOWNTO 0) & a(31 DOWNTO 20) WHEN "1100",
	a(18 DOWNTO 0) & a(31 DOWNTO 19) WHEN "1101",
	a(17 DOWNTO 0) & a(31 DOWNTO 18) WHEN "1110",
	a(16 DOWNTO 0) & a(31 DOWNTO 17) WHEN "1111",
	a WHEN OTHERS;


end Behavioral;
