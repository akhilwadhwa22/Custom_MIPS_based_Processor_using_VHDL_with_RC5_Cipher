
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--------  Program Counter -------
entity PCBranch is
  Port ( SignImm_left: in std_logic_vector(31 downto 0);
  pcplus4: in std_logic_vector(31 downto 0);
  PCBranch_sign : out std_logic_vector(31 downto 0)
  );
end PCBranch;

architecture Behavioral of PCBranch is
signal pcbranchS: std_logic_vector(31 downto 0):= (others=> '0') ;
begin
process (pcplus4, SignImm_left)
begin
PCBranchs<= pcplus4 + SignImm_left; 
end process;
PCBranch_sign<=std_logic_vector(PCBranchs);
end Behavioral;
