
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.state_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstrMem is
  Port (

  a : in STD_LOGIC_VECTOR(31 downto 0);
  rd : out STD_LOGIC_VECTOR(31 downto 0);
  state : in s_type

  );

end InstrMem;

architecture Behavioral of InstrMem is

-- Opcodes:

constant bool : STD_LOGIC_VECTOR(5 downto 0) := "000000"; --Opcode 00
constant andi : STD_LOGIC_VECTOR(5 downto 0) := "000011"; --Opcode 03
constant ori : STD_LOGIC_VECTOR(5 downto 0) := "000100";  --Opcode 04
constant lw : STD_LOGIC_VECTOR(5 downto 0) := "000111";   --Opcode 07
constant sw : STD_LOGIC_VECTOR(5 downto 0) := "001000";   --Opcode 08
constant blt : STD_LOGIC_VECTOR(5 downto 0) := "001001";  --Opcode 09
constant beq : STD_LOGIC_VECTOR(5 downto 0) := "001010";  --Opcode 0A
constant bne : STD_LOGIC_VECTOR(5 downto 0) := "001011";  --Opcode 0B
constant jmp : STD_LOGIC_VECTOR(5 downto 0) := "001100";  --Opcode 0C
constant hal : STD_LOGIC_VECTOR(5 downto 0) := "111111";  --Opcode 3F

-- Functions:

constant xrlr : STD_LOGIC_VECTOR(5 downto 0) := "010000"; --Function 10
constant rrxr : STD_LOGIC_VECTOR(5 downto 0) := "010001"; --Function 11
constant and1 : STD_LOGIC_VECTOR(5 downto 0) := "010010"; --Function 12
constant or1 : STD_LOGIC_VECTOR(5 downto 0) := "010011";  --Function 13
constant nor1 : STD_LOGIC_VECTOR(5 downto 0) := "010100"; --Function 14
constant lrad : STD_LOGIC_VECTOR(5 downto 0) := "010101"; --Function 15
constant sbrr : STD_LOGIC_VECTOR(5 downto 0) := "010110"; --Function 16

-- Register File:

constant reg0 : STD_LOGIC_VECTOR(4 downto 0) := "00000";
constant reg1 : STD_LOGIC_VECTOR(4 downto 0) := "00001";
constant reg2 : STD_LOGIC_VECTOR(4 downto 0) := "00010";
constant reg3 : STD_LOGIC_VECTOR(4 downto 0) := "00011";
constant reg4 : STD_LOGIC_VECTOR(4 downto 0) := "00100";
constant reg5 : STD_LOGIC_VECTOR(4 downto 0) := "00101";
constant reg6 : STD_LOGIC_VECTOR(4 downto 0) := "00110";
constant reg7 : STD_LOGIC_VECTOR(4 downto 0) := "00111";
constant reg8 : STD_LOGIC_VECTOR(4 downto 0) := "01000";
constant reg9 : STD_LOGIC_VECTOR(4 downto 0) := "01001";
constant reg10 : STD_LOGIC_VECTOR(4 downto 0) := "01010";
constant reg11 : STD_LOGIC_VECTOR(4 downto 0) := "01011";
constant reg12 : STD_LOGIC_VECTOR(4 downto 0) := "01100";
constant reg13 : STD_LOGIC_VECTOR(4 downto 0) := "01101";
constant reg14 : STD_LOGIC_VECTOR(4 downto 0) := "01110";
constant reg15 : STD_LOGIC_VECTOR(4 downto 0) := "01111";
constant reg16 : STD_LOGIC_VECTOR(4 downto 0) := "10000";
constant reg17 : STD_LOGIC_VECTOR(4 downto 0) := "10001";
constant reg18 : STD_LOGIC_VECTOR(4 downto 0) := "10010";
constant reg19 : STD_LOGIC_VECTOR(4 downto 0) := "10011";
constant reg20 : STD_LOGIC_VECTOR(4 downto 0) := "10100";
constant reg21 : STD_LOGIC_VECTOR(4 downto 0) := "10101";
constant reg22 : STD_LOGIC_VECTOR(4 downto 0) := "10110";
constant reg23 : STD_LOGIC_VECTOR(4 downto 0) := "10111";
constant reg24 : STD_LOGIC_VECTOR(4 downto 0) := "11000";
constant reg25 : STD_LOGIC_VECTOR(4 downto 0) := "11001";
constant reg26 : STD_LOGIC_VECTOR(4 downto 0) := "11010";
constant reg27 : STD_LOGIC_VECTOR(4 downto 0) := "11011";
constant reg28 : STD_LOGIC_VECTOR(4 downto 0) := "11100";
constant reg29 : STD_LOGIC_VECTOR(4 downto 0) := "11101";
constant reg30 : STD_LOGIC_VECTOR(4 downto 0) := "11110";
constant reg31 : STD_LOGIC_VECTOR(4 downto 0) := "11111";

-- Unused bit

constant usd : STD_LOGIC := '0';

begin

-- Instruction Formats:

-- Opcode (6 bits)  &   Rs    &  Rt     &  Rd     &  Rot_amt  & Funct (R-TYPE)
-- Opcode (6 bits)  &   Rs    &  Rt     & Address/Immediate           (I-TYPE)
-- Opcode (6 bits)  &   Address (26 bits)                             (J-TYPE)

process(a,state)
begin
if(state=KG) then 
case a(31 downto 0) is

   when x"00000000" => rd <= bool & reg0 & reg0 & reg0 & "0000" & usd & and1; 
   
   -- Load User Key(128 bits) from the data memory
   when x"00000004" => rd <= lw & reg0 & reg21 & "0000000000111100"; 
   when x"00000008" => rd <= lw & reg0 & reg20 & "0000000000111110";
   when x"0000000c" => rd <= lw & reg0 & reg19 & "0000000001000000"; 
   when x"00000010" => rd <= lw & reg0 & reg18 & "0000000001000010";
   
   when x"00000014" => rd <= sw & reg0 & reg18 & "0000000010011000";
   when x"00000018" => rd <= sw & reg0 & reg19 & "0000000010011010";
   when x"0000001c" => rd <= sw & reg0 & reg20 & "0000000010011100";
   when x"00000020" => rd <= sw & reg0 & reg21 & "0000000010011110";
   when x"00000024" => rd <= ori & reg0 & reg10 & "0000000000000010";
   
   when x"00000028" => rd <= ori & reg0 & reg19 & "0000000000000100"; -- c=4
   when x"0000002c" => rd <= ori & reg0 & reg20 & "0000000001100100";--100(Dec)
   when x"00000030" => rd <= ori & reg0 & reg26 & "0000000000111000";-- 56
   
   when x"00000034" => rd <= beq & reg19 & reg26 & "0000000000000101"; --10100
   when x"00000038" => rd <= lw & reg19 & reg21 & "0000000000000000";
   when x"0000003c" => rd <= sw & reg20 & reg21 & "0000000000000000";
   when x"00000040" => rd <= bool & reg19 & reg10 & reg19 & "0000" & usd & lrad; --counter increment for L
   when x"00000044" => rd <= bool & reg20 & reg10 & reg20 & "0000" & usd & lrad; --counter increment for S
   when x"00000048" => rd <= jmp & "11111111111111111111111010";--11101000
   
   when x"0000004c" => rd <= andi & reg0 & reg24 &  "0000000000000000"; -- A=0
   when x"00000050" => rd <= andi & reg0 & reg25 &  "0000000000000000"; --B=0
   
   when x"00000054" => rd <= andi & reg0 & reg26 &  "0000000000000000"; -- i=0
   when x"00000058" => rd <= andi & reg0 & reg27 &  "0000000000000000"; --j=0
   when x"0000005c" => rd <= andi & reg0 & reg28 &  "0000000000000000"; --k=0
   
   when x"00000060" => rd <= ori & reg0 & reg29 & "0000000000011010"; -- t=26
   when x"00000064" => rd <= ori & reg0 & reg30 & "0000000000000100"; -- c=4
   when x"00000068" => rd <= ori & reg0 & reg21 & "0000000001001110"; -- c*t=78
   
   
   --when x"00000068" => rd <= ori & reg0 & reg10 & "0000000000000010"; -- counter for S and L
   when x"0000006c" => rd <= ori & reg0 & reg7 & "0000000000000001";
   when x"00000070" => rd <= ori & reg0 & reg19 & "0000000010011000"; -- offset for L
   when x"00000074" => rd <= ori & reg0 & reg20 & "0000000001100100"; -- offset for S
   
   --when x"0000003c" => rd <= bool & reg22 & reg23 & reg22 & "0000" & usd & lrad;
   --when x"00000004" => rd <= sw & reg0 & reg22 & "0000000000000100";
   

   
   
    
    when x"00000078" => rd <= bool & reg24 & reg25 & reg24 & "0000" & usd & lrad; --A+B store in A
    when x"0000007c" => rd <= lw & reg20 & reg22 & "0000000000000000"; -- Load S from DM
    
    when x"00000080" => rd <= bool & reg24 & reg22 & reg22 & "0000" & usd & lrad; -- S+A+B
    when x"00000084" => rd <= bool & reg22 & reg0 & reg22 & "0011" & usd & xrlr; --(S+A+B)<<<3=>A
    
   when x"00000088" => rd <= bool & reg22 & reg0 & reg24 & "0000" & usd & or1; --A= S[i]
   when x"0000008c" => rd <= sw & reg20 & reg22 & "0000000000000000"; --updating S[i] in DM
   
   
   
   when x"00000090" => rd <= bool & reg24 & reg25 & reg25 & "0000" & usd & lrad; --A+B store in B
   when x"00000094" => rd <= lw & reg19 & reg18 & "0000000000000000"; -- Load L from DM
   when x"00000098" => rd <= bool & reg25 & reg18 & reg18 & "0000" & usd & lrad; -- L+A+B
   
   
   
   when x"0000009c" => rd <= andi & reg25 & reg25 &  "0000000000011111"; -- Rotate Amount
   when x"000000A0" => rd <= beq & reg0 & reg25 & "0000000000000011"; --branch if equal to 00000040
    
--Left Rotate by 1 
    when x"000000A4" => rd <= bool & reg18 & reg0 & reg18 & "0001" & usd & lrad;
-- Subtract the counter by 1 (Inner Loop1)
    when x"000000A8" => rd <= bool & reg25 & reg7 & reg25 & "0000" & usd & sbrr;
-- Jump to location 34 everytime this is encountered
    when x"000000AC" => rd <= jmp & "11111111111111111111111100";
    
    when x"000000B0" => rd <= bool & reg18 & reg0 & reg25 & "0000" & usd & or1; --B= L[j]
    when x"000000B4" => rd <= sw & reg19 & reg18 & "0000000000000000"; --updating L[j] in DM
   
   
   when x"000000B8" => rd <= bool & reg19 & reg10 & reg19 & "0000" & usd & lrad; --counter increment for L
   when x"000000BC" => rd <= bool & reg20 & reg10 & reg20 & "0000" & usd & lrad; --counter increment for S
   
   
    when x"000000C0" => rd <= bool & reg26 & reg7 & reg26 & "0000" & usd & lrad; --i=i+1
    when x"000000C4" => rd <= bool & reg27 & reg7 & reg27 & "0000" & usd & lrad;--j=j+1
    when x"000000C8" => rd <= bool & reg28 & reg7 & reg28 & "0000" & usd & lrad;--k=k+1
   
   
   when x"000000CC" => rd <= bne & reg29 & reg26 & "0000000000000010"; --branch if equal to 00000040 
   when x"000000D0" => rd <= andi & reg0 & reg26 &  "0000000000000000"; -- i=0
   when x"000000D4" => rd <= ori & reg0 & reg20 & "0000000001100100"; -- offset for S
   
   
   when x"000000D8" => rd <= bne & reg30 & reg27 & "0000000000000010"; --branch if equal to 00000040 
   when x"000000DC" => rd <= andi & reg0 & reg27 & "0000000000000000"; -- j=0
   when x"000000E0" => rd <= ori & reg0 & reg19 & "0000000010011000"; -- offset for L
   
   
   when x"000000E4" => rd <= beq & reg21 & reg28 & "0000000000000001"; --branch if equal to 00000040 
   when x"000000E8" => rd <= jmp & "11111111111111111111100011";
   
   when x"000000EC" => rd <= hal & "00000000000000000000000000";             
   when others => rd <= (others => '0');
  

end case;

end if;

if(state=ENCRYPT) then


case a(31 downto 0) is

    when x"00000000" => rd <= bool & reg0 & reg0 & reg0 & "0000" & usd & and1; 
-- Load A and B from the data memory
    when x"00000004" => rd <= lw & reg0 & reg1 & "0000000000000000"; 
    when x"00000008" => rd <= lw & reg0 & reg2 & "0000000000000010"; 
-- Load skey(0) and add to A => R3
    when x"0000000c" => rd <= lw & reg0 & reg31 & "0000000001100100"; --1100100
    when x"00000010" => rd <= bool & reg1 & reg31 & reg3 & "0000" & usd & lrad;
-- Load skey(1) and add to B => R4
    when x"00000014" => rd <= lw & reg0 & reg31 & "0000000001100110";--1100110
    when x"00000018" => rd <= bool & reg2 & reg31 & reg4 & "0000" & usd & lrad;
--Load R8 with 12 for the main loop and R7 as 1 for decrementing the counters    
    when x"0000001c" => rd <= ori & reg0 & reg8 & "0000000000001100";
    when x"00000020" => rd <= ori & reg0 & reg7 & "0000000000000001";
-- Load R9 and R10 with initial DM location for Skey and the counter
    when x"00000024" => rd <= ori & reg0 & reg9 & "0000000001101000";-- 1101000
    when x"00000028" => rd <= ori & reg0 & reg10 & "0000000000000010";    
--Make a copy of A to implement the counters for left-rotates.  We use only the LSB 5 bits for rotation 

--	****************************************    Main loop start  ****************************************

    when x"0000002c" => rd <= andi & reg4 & reg5 &  "0000000000011111";  
-- Xor A and B
    when x"00000030" => rd <= bool & reg3 & reg4 & reg3 & "0000" & usd & xrlr;    
-- Branch to location 44 when the counter is zero

--	****************************************  Label for start of Inner loop 1  ****************************************

    when x"00000034" => rd <= beq & reg0 & reg5 & "0000000000000011"; --branch if equal to 00000040
--Left Rotate by 1 
    when x"00000038" => rd <= bool & reg3 & reg0 & reg3 & "0001" & usd & lrad;
-- Subtract the counter by 1 (Inner Loop1)
    when x"0000003c" => rd <= bool & reg5 & reg7 & reg5 & "0000" & usd & sbrr;
-- Jump to location 34 everytime this is encountered
    when x"00000040" => rd <= jmp & "11111111111111111111111100";

--	****************************************  End of Inner Loop 1  ****************************************

-- Load the new Skey from the DM
    when x"00000044" => rd <= lw & reg9 & reg31 & "0000000000000000";
-- Increase the Skey address counter  by 2
    when x"00000048" => rd <= bool & reg9 & reg10 & reg9 & "0000" & usd & lrad;
-- Post round addition of the Skey to Reg3 => (Updated A)
    when x"0000004c" => rd <= bool & reg3 & reg31 & reg3 & "0000" & usd & lrad;
--Make a copy of B to implement the counters for left-rotates.  We use only the LSB 5 bits for rotation 
    when x"00000050" => rd <= andi & reg3 & reg6 &  "0000000000011111";
-- Xor the updated value of A and the previous value of B
    when x"00000054" => rd <= bool & reg3 & reg4 & reg4 & "0000" & usd & xrlr; 


--	****************************************   Label for start of Inner loop 2   ****************************************

-- Branch to location 68 when the counter is zero
    when x"00000058" => rd <= beq & reg0 & reg6 & "0000000000000011";
--Left Rotate by 1
    when x"0000005c" => rd <= bool & reg4 & reg0 & reg4 & "0001" & usd & lrad; 
-- Subtract the counter by 1 (Inner Loop2)
    when x"00000060" => rd <= bool & reg6 & reg7 & reg6 & "0000" & usd & sbrr;
-- Jump to location 58 everytime this is encountered
    when x"00000064" => rd <= jmp & "11111111111111111111111100";

--	****************************************  End of Inner Loop 2  ****************************************

-- Update the value of the Skey into register R31
    when x"00000068" => rd <= lw & reg9 & reg31 & "0000000000000000";
-- Increase the Skey address counter  by 2
    when x"0000006c" => rd <= bool & reg9 & reg10 & reg9 & "0000" & usd & lrad;
-- Post round addition of the Skey to Reg3 => (Updated B)
    when x"00000070" => rd <= bool & reg4 & reg31 & reg4 & "0000" & usd & lrad;

-- Decrement the Main loop counter by 1
    when x"00000074" => rd <= bool & reg8 & reg7 & reg8 & "0000" & usd & sbrr;
-- If the counter is zero, Branch to location 80 which is the Halt instruction
    when x"00000078" => rd <= beq & reg0 & reg8 & "0000000000000001";
--Jump to Location 2c everytime this is encountered
    when x"0000007c" => rd <= jmp & "11111111111111111111101011";

--	****************************************  End of Main Loop   ****************************************

-- Halt the processor
    when x"00000080" => rd <= sw & reg0 & reg3 & "0000000000111000";
    when x"00000084" => rd <= sw & reg0 & reg4 & "0000000000111010";
    when x"00000088" => rd <= hal & "00000000000000000000000000";             
    when others => rd <= (others => '0');

end case;


 end if;
 
if(state=DECRYPT) then

case a(31 downto 0) is

   when x"00000000" => rd <= bool & reg0 & reg0 & reg0 & "0000" & usd & and1; 
-- Load X and Y from the data memory
   when x"00000004" => rd <= lw & reg0 & reg13 & "0000000000000000"; 
   when x"00000008" => rd <= lw & reg0 & reg14 & "0000000000000010"; 
--Load R17 with 54 for the main loop   
   when x"0000000c" => rd <= ori & reg0 & reg17 & "0000000010010110";--10010110
-- LOad R10 as 2 for decrementing the skey counter
   when x"00000010" => rd <= ori & reg0 & reg10 & "0000000000000010";
-- LOad R7 as 1 for decrementing the Main Loop   
   when x"00000014" => rd <= ori & reg0 & reg7 & "0000000000000001";
--Load R8 with 12 for the main loop 
   when x"00000018" => rd <= ori & reg0 & reg8 & "0000000000001100";
--Make a copy of X to implement the counters for left-rotates.  We use only the LSB 5 bits for rotation
 --	****************************************  Start of Main Loop   ****************************************  
 
   when x"0000001c" => rd <= andi & reg13 & reg16 &  "0000000000011111";
 -- Load skey(n) and subtract R17 by 2
   when x"00000020" => rd <= lw & reg17 & reg31 & "0000000000000000"; 
   when x"00000024" => rd <= bool & reg17 & reg10 & reg17 & "0000" & usd & sbrr;
   when x"00000028" => rd <= bool & reg14 & reg31 & reg14 & "0000" & usd & sbrr;
--	****************************************  Label for start of Inner loop 1  ****************************************
   when x"0000002c" => rd <= beq & reg0 & reg16 & "0000000000000011";
-- Right Rotate R14(Ys) by 1
   when x"00000030" =>rd <= bool & reg14 & reg0 & reg14 & "0001" & usd & sbrr;
-- Subtract the counter by 1 (Inner Loop1)
   when x"00000034" => rd <= bool & reg16 & reg7 & reg16 & "0000" & usd & sbrr;
-- Jump to location 34 everytime this is encountered
   when x"00000038" => rd <= jmp & "11111111111111111111111100";
-- Xor the updated value of A and the previous value of B
   when x"0000003c" => rd <= bool & reg14 & reg13 & reg14 & "0000" & usd & xrlr;
   
    
 -- Load skey(n-1) and subtract R17 by 2
   when x"00000040" => rd <= lw & reg17 & reg31 & "0000000000000000"; 
   when x"00000044" => rd <= bool & reg17 & reg10 & reg17 & "0000" & usd & sbrr;
   when x"00000048" => rd <= bool & reg13 & reg31 & reg13 & "0000" & usd & sbrr;
   
   
   when x"0000004c" => rd <= andi & reg14 & reg15 &  "0000000000011111";
    when x"00000050" => rd <= beq & reg0 & reg15 & "0000000000000011";
-- Right Rotate R14(Ys) by 1
   when x"00000054" =>rd <= bool & reg13 & reg0 & reg13 & "0001" & usd & sbrr;
-- Subtract the counter by 1 (Inner Loop2)
   when x"00000058" => rd <= bool & reg15 & reg7 & reg15 & "0000" & usd & sbrr;
-- Jump to location 34 everytime this is encountered
   when x"0000005c" => rd <= jmp & "11111111111111111111111100";
-- Xor the updated value of A and the previous value of B
   when x"00000060" => rd <= bool & reg14 & reg13 & reg13 & "0000" & usd & xrlr;
   
   
   -- Decrement the Main loop counter by 1
    when x"00000064" => rd <= bool & reg8 & reg7 & reg8 & "0000" & usd & sbrr;
    -- If the counter is zero, Branch to location 80 which is the Halt instruction
    when x"00000068" => rd <= beq & reg0 & reg8 & "0000000000000001";
--Jump to Location 2c everytime this is encountered
    when x"0000006c" => rd <= jmp & "11111111111111111111101011";
 
 --	****************************************  End of Main Loop   ****************************************   
    
    when x"00000070" => rd <= lw & reg17 & reg31 & "0000000000000000";
     when x"00000074" => rd <= bool & reg14 & reg31 & reg12 & "0000" & usd & sbrr;
      when x"00000078" => rd <= bool & reg17 & reg10 & reg17 & "0000" & usd & sbrr;
      when x"0000007c" => rd <= lw & reg17 & reg31 & "0000000000000000";
      when x"00000080" => rd <= bool & reg13 & reg31 & reg11 & "0000" & usd & sbrr;
-- Halt the processor

    when x"00000084" => rd <= sw & reg0 & reg11 & "0000000000111000";
    when x"00000088" => rd <= sw & reg0 & reg12 & "0000000000111010";
    when x"0000008c" => rd <= hal & "00000000000000000000000000";             
    when others => rd <= (others => '0');

end case;



end if;

end process;

end Behavioral;