----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2019 05:55:43 PM
-- Design Name: 
-- Module Name: buffer - Behavioral
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
use work.state_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buff is
  Port (clk: IN STD_LOGIC;  -- Clock/enable signal
        reset : IN STD_LOGIC;
  	  din: IN STD_LOGIC_VECTOR(31 downto 0) := x"00000000";--1-bit input
  	  dout: OUT STD_LOGIC_VECTOR(31 downto 0); --1-bit output
  	  state: s_type
 );
end buff;

architecture Behavioral of buff is
begin
PROCESS (clk, reset,state)  
BEGIN

IF(reset = '1') then
dout <= x"00000000";
--IF (state = PKG) then
--dout<= x"00000000";
elsif(state=PKG or state= IRD) then -- MODIFY THIS_STATE EVENT MISSING
dout<= x"00000000";
ELSIF (clk'EVENT AND clk='1') THEN 
  dout<=din;
END If;  
--END IF;
END PROCESS;
end Behavioral;
