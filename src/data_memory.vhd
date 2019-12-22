----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2019 11:38:27 PM
-- Design Name: 
-- Module Name: data_memory - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.state_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_memory is
  Port (clk: in STD_LOGIC;
        ALUResult: in STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteData: in STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemWrite: in STD_LOGIC;
        ReadData: out STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_in: in STD_LOGIC_VECTOR(127 downto 0);
        data_out : out STD_LOGIC_VECTOR(63 downto 0);
        data_out1 : out STD_LOGIC_VECTOR(63 downto 0);
        data_out2 : out std_logic_vector(127 downto 0);
        state: s_type
         );
end data_memory;

architecture Behavioral of data_memory is

signal ram_address: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal data_in_temp :STD_LOGIC_VECTOR(127 downto 0);
signal data_out_temp : STD_LOGIC_VECTOR(63 downto 0);

TYPE ram IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
--signal 
--signal ram1: ram:=((others=>(others=>'0')));
    signal ram1: ram:=ram'( 0=> x"ffff",1=> x"fffe",-- A and B (Inputs)
                            2=> x"fffd",3=> x"fffc",
                            
                            4 => x"b7e1", 5 => x"5163",
                            6 => x"5618", 7 => x"cb1c",
                            8 => x"f450", 9 => x"44d5",
                            10 => x"9287", 11 => x"be8e",
                            12 => x"30bf", 13 => x"3847",
                            14 => x"cef6", 15 => x"b200",
                            16 => x"6d2e", 17 => x"2bb9",
                            18 => x"0b65", 19 => x"a572",
                            20 => x"a99d", 21 => x"1f2b",
                            22 => x"47d4", 23 => x"98e4",
                            24 => x"e60c", 25 => x"129d",
                            26 => x"8443", 27 => x"8c56",
                            28 => x"227b", 29 => x"060f",
                            30 => x"c0b2", 31 => x"7fc8",
                            32 => x"5ee9", 33 => x"f981",
                            34 => x"fd21", 35 => x"733a",
                            36 => x"9b58", 37 => x"ecf3",
                            38 => x"3990", 39 => x"66ac",
                            40 => x"d7c7", 41 => x"e065",
                            42 => x"75ff", 43 => x"5a1e",
                            44 => x"1436", 45 => x"d3d7",
                            46 => x"b26e", 47 => x"4d90",
                            48 => x"50a5", 49 => x"c749",
                            50 => x"eedd", 51 => x"4102",
                            52 => x"8d14", 53 => x"babb",
                            54 => x"2b4c", 55 => x"3474",
                            
                            56=>x"EA04", 57=> x"BFBE",
                            58=> x"B6EB", 59=> x"797B", -- i/p to decryption
                            
                            60=>x"1234", 61=> x"5678", --User Key
                            62=> x"9abc", 63=> x"def0",
                            64=>x"1234", 65=> x"5678",
                            66=> x"9abc", 67=> x"def0",
                            
                            68=>x"B7E1", 69=> x"5163",-- P and Q(Magic numbers)
                            70=> x"9E37", 71=> x"79B9", 
                                                           
                            others => x"8888"); 
begin

ram_address <= ALUResult(7 DOWNTO 0);
data_in_temp<=data_in;
data_out <= data_out_temp;
data_out1 <= ram1(100) & ram1(101) & ram1(102) & ram1(151);
data_out2 <= ram1(60) & ram1(61) & ram1(62) & ram1(63) &ram1(64) &ram1(65) & ram1(66) & ram1(67);

process(clk, MemWrite, state,data_in_temp,ram1,WriteData)
begin
    if (state= PKG) then
        ram1(60) <= data_in_temp(127 downto 112);
        ram1(61) <= data_in_temp(111 downto 96);
        ram1(62) <= data_in_temp(95 downto 80);
        ram1(63) <= data_in_temp(79 downto 64);
        ram1(64) <= data_in_temp(63 downto 48);
        ram1(65) <= data_in_temp(47 downto 32);
        ram1(66) <= data_in_temp(31 downto 16);
        ram1(67) <= data_in_temp(15 downto 0);
        
    elsif (state = IRC) then
        ram1(0) <= data_in_temp(63 downto 48);
        ram1(1) <= data_in_temp(47 downto 32);
        ram1(2) <= data_in_temp(31 downto 16);
        ram1(3) <= data_in_temp(15 downto 0);
--        data_out_temp(63 downto 48) <= ram1(56);
--        data_out_temp(47 downto 32) <= ram1(57);
--        data_out_temp(31 downto 16) <= ram1(58);
--        data_out_temp(15 downto 0)  <= ram1(59);
        
    elsif (state = ENCRYPT or state = DECRYPT) then
        data_out_temp(63 downto 48) <= ram1(56);
        data_out_temp(47 downto 32) <= ram1(57);
        data_out_temp(31 downto 16) <= ram1(58);
        data_out_temp(15 downto 0)  <= ram1(59);
        end if;
    if(clk'EVENT AND clk='1') then
        if(MemWrite='1') then
            ram1(TO_INTEGER(unsigned(ram_address)+1)) <= WriteData(15 downto 0);
            ram1(TO_INTEGER(unsigned(ram_address))) <= WriteData(31 downto 16);
                           
        end if;
    
    end if;
end process;

--        data_out(63 downto 48) <= ram1(56);
--        data_out(47 downto 32) <= ram1(57);
--        data_out(31 downto 16) <= ram1(58);
--        data_out(15 downto 0)  <= ram1(59);

--process(state)
--begin
--    if (state= PKG) then
--        ram1(60) <= data_in_temp(127 downto 112);
--        ram1(61) <= data_in_temp(111 downto 96);
--        ram1(62) <= data_in_temp(95 downto 80);
--        ram1(63) <= data_in_temp(79 downto 64);
--        ram1(64) <= data_in_temp(63 downto 48);
--        ram1(65) <= data_in_temp(47 downto 32);
--        ram1(66) <= data_in_temp(31 downto 16);
--        ram1(67) <= data_in_temp(15 downto 0);
        
--    elsif (state = IRC) then
--        ram1(0) <= data_in_temp(63 downto 48);
--        ram1(1) <= data_in_temp(47 downto 32);
--        ram1(2) <= data_in_temp(31 downto 16);
--        ram1(3) <= data_in_temp(15 downto 0);
        
--    elsif (state = ENCRYPT or state = DECRYPT) then
--        data_out_temp(63 downto 48) <= ram1(56);
--        data_out_temp(47 downto 32) <= ram1(57);
--        data_out_temp(31 downto 16) <= ram1(58);
--        data_out_temp(15 downto 0)  <= ram1(59);
        
--    end if;
--end process;

ReadData(15 downto 0)<= ram1(TO_INTEGER(unsigned(ram_address)+1));
ReadData(31 downto 16)<= ram1(TO_INTEGER(unsigned(ram_address))); --x"0000";

end Behavioral;
