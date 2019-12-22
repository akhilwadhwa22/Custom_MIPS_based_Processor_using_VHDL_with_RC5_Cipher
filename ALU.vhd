----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2019 05:28:55 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
Port ( 
SrcA : in STD_LOGIC_VECTOR(31 DOWNTO 0);
SrcB : in STD_LOGIC_VECTOR(31 DOWNTO 0);
CU_output : in STD_LOGIC_VECTOR(3 DOWNTO 0);
rot_amt : in STD_LOGIC_VECTOR(3 DOWNTO 0);
ALUResult : out STD_LOGIC_VECTOR(31 DOWNTO 0);
BranchTaken : out STD_LOGIC:= '0');
end ALU;

architecture Behavioral of ALU is
component left_rot is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           outx : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component right_rot is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           outx : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal xrlr_result: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal sbrr_result: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal right_rotate_result: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal left_rotate_result: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal SrcA_SrcB_xor: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal SrcA_SrcB_sub: STD_LOGIC_VECTOR (31 DOWNTO 0);
signal AluOut : STD_LOGIC_VECTOR(31 downto 0);
signal branch_temp : STD_LOGIC;

begin
xrlr: left_rot
Port Map(a=>SrcA_SrcB_xor,
        b=>rot_amt,
        outx=>xrlr_result);
        
sbrr: right_rot
Port Map(a=>SrcA_SrcB_sub,
        b=>rot_amt,
        outx=>sbrr_result);
        
right_rotate: right_rot
Port Map(a=>SrcA,
        b=>rot_amt,
        outx=>right_rotate_result);
        
left_rotate: left_rot
Port Map(a=>SrcA,
        b=>rot_amt,
        outx=>left_rotate_result);
        
SrcA_SrcB_xor <= SrcA XOR SrcB;
SrcA_SrcB_sub <= SrcA - SrcB;        
PROCESS(CU_output,SrcA,SrcB,SrcA_SrcB_sub,xrlr_result,right_rotate_result,left_rotate_result,sbrr_result)
BEGIN
    
    

    case CU_output is
        when "0000" => AluOut <= SrcA AND SrcB;
        when "0001" => AluOut <= SrcA OR SrcB;
        when "0010" => AluOut <= SrcA NOR SrcB;
        when "0111" => AluOut <= SrcA + SrcB;
        --when "0100" => ALUResult <= SrcB - SrcA;
        when "1000" => if(SrcA < SrcB) then branch_temp <= '1'; else branch_temp <= '0'; end if;
        when "1001" => if(SrcA = SrcB) then branch_temp <= '1'; else branch_temp <= '0'; end if;
        when "1010" => if(conv_integer(SrcA)/= conv_integer(SrcB)) then branch_temp <= '1'; else branch_temp <='0'; end if;
        when "0011" => AluOut <= xrlr_result;
        when "0100" => AluOut <= right_rotate_result XOR SrcB;
        when "0101" => AluOut <= left_rotate_result + SrcB;
        when "0110" => AluOut <= sbrr_result;
        when others => AluOut <= (others => 'X');
    end case;
END PROCESS;

AluResult <= AluOut;
BranchTaken <= branch_temp;

end Behavioral;
