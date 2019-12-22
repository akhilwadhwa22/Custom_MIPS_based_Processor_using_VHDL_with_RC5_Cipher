
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--------  Program Counter -------
entity PCPlus4 is
  Port ( PC: in std_logic_vector(31 downto 0);
  pcplus4: out std_logic_vector(31 downto 0)
  );
end PCPlus4;

architecture Behavioral of PCPlus4 is
begin
pcplus4<= PC + x"00000004"; 
end Behavioral;