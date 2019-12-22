----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2019 02:03:15 PM
-- Design Name: 
-- Module Name: right_rot - Behavioral
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

entity right_rot is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           outx : out STD_LOGIC_VECTOR (31 downto 0));
end right_rot;

architecture Behavioral of right_rot is

begin

    WITH b(3 DOWNTO 0) SELECT
    outx<=	a(0) & a(31 DOWNTO 1) WHEN "0001",
	a(1 DOWNTO 0) & a(31 DOWNTO 2) WHEN "0010",
	a(2 DOWNTO 0) & a(31 DOWNTO 3) WHEN "0011",
	a(3 DOWNTO 0) & a(31 DOWNTO 4) WHEN "0100",
	a(4 DOWNTO 0) & a(31 DOWNTO 5) WHEN "0101",
	a(5 DOWNTO 0) & a(31 DOWNTO 6) WHEN "0110",
	a(6 DOWNTO 0) & a(31 DOWNTO 7) WHEN "0111",
	a(7 DOWNTO 0) & a(31 DOWNTO 8) WHEN "1000",
	a(8 DOWNTO 0) & a(31 DOWNTO 9) WHEN "1001",
	a(9 DOWNTO 0) & a(31 DOWNTO 10) WHEN "1010",
	a(10 DOWNTO 0) & a(31 DOWNTO 11) WHEN "1011",
	a(11 DOWNTO 0) & a(31 DOWNTO 12) WHEN "1100",
	a(12 DOWNTO 0) & a(31 DOWNTO 13) WHEN "1101",
	a(13 DOWNTO 0) & a(31 DOWNTO 14) WHEN "1110",
	a(14 DOWNTO 0) & a(31 DOWNTO 15) WHEN "1111",
	a WHEN OTHERS;


end Behavioral;
