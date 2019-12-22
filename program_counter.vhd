library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.state_pkg.all;
--------  Program Counter -------
entity program_counter is
  Port ( reset: in std_logic;
  pcbranch_pc,pcplus4_pc : in std_logic_vector(31 downto 0) := x"00000000";
  isjump,isbranch,ishalt : in std_logic;
  pcdash : out std_logic_vector(31 downto 0)
  --state: s_type
  );
end program_counter;

architecture Behavioral of program_counter is

signal pctemp:std_logic_vector(31 downto 0);
signal jumpbranch_temp:std_logic;
begin

jumpbranch_temp <= isjump or isbranch;

process(reset,jumpbranch_temp, pcbranch_pc, pcplus4_pc, ishalt)
begin
if (reset='1') then pctemp<= x"00000000";
--elsif (state=KG or state= ENCRYPT or state= DECRYPT) then
--pctemp<= x"00000000";
 elsif(jumpbranch_temp='1') then pctemp<=pcbranch_pc;
 elsif(ishalt='1') then pctemp<=pcplus4_pc-x"4"; 
 else pctemp<=pcplus4_pc;
 end if;
--end if;
end process;
pcdash<= pctemp; 
end Behavioral;