----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/12/2019 12:28:43 AM
-- Design Name: 
-- Module Name: fsm - Behavioral
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

entity fsm is
 Port ( clk : in std_logic;
        reset : in std_logic;
        key_vld : in std_logic;
        din : in std_logic_vector(63 downto 0);
        din_vld : std_logic;
        dout : out std_logic_vector(63 downto 0);
        key_in : in std_logic_vector(127 downto 0);
        again : in std_logic;
        enc : in std_logic
        );
end fsm;

architecture Behavioral of fsm is
--type s_type is(PKG, KG, IRC, IRD, ENCRYPT, DECRYPT);
signal state, nextstate: s_type;
signal display : std_logic_vector(15 downto 0);
--signal key_vld : std_logic
signal key_rdy : std_logic;

begin
process(state,clk)
begin
if(clk'event and clk='1') then
if(reset='1') then state <= PKG;
else
case state is
when PKG=> if key_vld='1' then state<=KG; end if;
when KG=> if key_rdy = '1' then state <= IRC; end if;
when IRC => if din_vld = '1' then state <= IRD; end if;
when IRD => if enc = '1' then state <=  ENCRYPT; elsif enc = '0' then state <= DECRYPT; end if;
when ENCRYPT => if again = '1' then state <= IRC; end if;
when DECRYPT => if again = '1' then state <= IRC; end if;
end case;
end if;
end if;
end process;


end Behavioral;
