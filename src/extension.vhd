library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SignExtend is
  Port ( 
  
  SignImm       : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  SignImm_left  : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  SignIn        : in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  BranchCtrl    : in STD_LOGIC;
  JumpCtrl      : in STD_LOGIC
  );
end SignExtend;

architecture Behavioral of SignExtend is

signal SignExt : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin

process (BranchCtrl,SignIn,JumpCtrl)
begin
if(JumpCtrl='1') then
    if(SignIn(25) ='1') then
        SignExt <= "111111" & SignIn(25 downto 0);
        end if;
    if(SignIn(25) ='0') then
        SignExt <= "000000" & SignIn(25 downto 0);
        end if;   
elsif (BranchCtrl = '0') then 
        if (SignIn(15) = '1') then
            SignExt <= x"FFFF" & SignIn(15 downto 0);
            end if;
        if (SignIn(15) = '0') then
            SignExt <= x"0000" & SignIn(15 downto 0);
            
        end if;    
elsif (BranchCtrl = '1') then
    SignExt <= x"0000" & SignIn(15 downto 0);
end if;    
end process;

SignImm <= SignExt;
SignImm_left <= SignExt(29 downto 0) & "00";

end Behavioral;
