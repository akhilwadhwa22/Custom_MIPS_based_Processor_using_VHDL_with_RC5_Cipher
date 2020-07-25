

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DecodeUnit is
    Port ( opcode  	: in STD_LOGIC_VECTOR(5 downto 0);
	   func 	: in STD_LOGIC_VECTOR(5 downto 0);
           MemtoReg 	: out  STD_LOGIC;
           MemWrite 	: out  STD_LOGIC;
           Branch 	: out  STD_LOGIC;
           ALUControl 	: out  STD_LOGIC_VECTOR(3 downto 0);
           ALUsrc 	: out  STD_LOGIC;
           RegDst 	: out  STD_LOGIC;
           RegWrite 	: out  STD_LOGIC;
           jmp      	: out  STD_LOGIC;
           halt		: out STD_LOGIC
           );
end DecodeUnit;

architecture Behavioral of DecodeUnit is

SIGNAL MemtoRegS: STD_LOGIC 	:= '0';
SIGNAL MemWriteS: STD_LOGIC 	:= '0';
SIGNAL BranchS:  STD_LOGIC 	:= '0';
SIGNAL ALUControlS		: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL ALUsrcS: STD_LOGIC 	:= '0';
SIGNAL RegDstS: STD_LOGIC 	:= '0';
SIGNAL RegWriteS: STD_LOGIC 	:= '0';
SIGNAL jmpS: STD_LOGIC 		:= '0';
SIGNAL halts: STD_LOGIC		:= '0';

begin
Process(opcode, func)
BEGIN
IF(opcode = "000000")	THEN	
	ALUSrcS	 		<= '0';
	MemtoRegS 		<= '0';
	MemWriteS 		<= '0';
	BranchS 		<= '0';
	RegWriteS 		<= '1';
	RegDstS 		<= '1';
	jmpS 			<= '0';
	halts			<= '0';

	IF(func = "010010") THEN
		ALUControlS 	<= "0000";     --AND
	ELSIF(func = "010011") THEN
		ALUControlS 	<= "0001";     --OR
	ELSIF(func = "010100") THEN
		ALUControlS 	<= "0010";      --NOR
	ELSIF(func = "010000") THEN
		ALUControlS 	<= "0011";     --ExOR-LEFT
	ELSIF(func = "010001") THEN
		ALUControlS 	<= "0100";      --RIGHT-EXOR
	ELSIF(func = "010101") THEN
		ALUControlS 	<= "0101";     ---LEFT ROTATE -ADD
	ELSIF(func = "010110") THEN
		ALUControlS 	<= "0110";     ---SUB-RIGHT		
	END IF;
ELSE      
	-------   RegDstS is '1' when Instruction is I type '0' otherwise
	IF(opcode = "000011") THEN
		ALUControlS 	<= "0000";   ----ANDI
		RegDstS 	<= '0';
		ALUSrcS 	<= '1';
		MemtoRegS 	<= '0';
		MemWriteS 	<= '0';
		BranchS 	<= '0';
		RegWriteS	<= '1';
		jmpS 		<= '0';
		halts		<= '0';

	ELSIF(opcode = "000100") THEN
		ALUControlS 	<= "0001";     ----ORI
		RegDstS 	<= '0';
		ALUSrcS 	<= '1';
		MemtoRegS 	<= '0';
		MemWriteS 	<= '0';
		BranchS 	<= '0';
		RegWriteS 	<= '1';
		jmpS 		<= '0';
		halts		<= '0';

	ELSIF(opcode = "000111") THEN
		ALUControlS 	<= "0111";    ---LW
		RegDstS 	<= '0';
		RegWriteS 	<= '1';
     		ALUSrcS 	<= '1';
     		MemtoRegS 	<= '1';
     		BranchS		<= '0';
     		MemWriteS	<= '0';
     		jmpS  		<= '0';
     		halts		<= '0';

	ELSIF(opcode = "001000") THEN
		ALUControlS 	<= "0111";    ----SW
		RegDstS 	<= '0';
        	MemWriteS	<= '1';
		ALUSrcS 	<= '1';
		MemtoRegS 	<= '0';
		BranchS 	<= '0';
		RegWriteS 	<= '0';
		jmpS 		<= '0';
		halts		<= '0';

	ELSIF(opcode = "001001") THEN
		ALUControlS 	<= "1000";    ----BLT
		RegDstS 	<= '0';
		BranchS		<= '1';
		MemtoRegS 	<= '0';
		MemWriteS 	<= '0';
		RegWriteS 	<= '0';
		ALUSrcS 	<= '0';
		jmpS 		<= '0';
        	halts		<= '0';

	ELSIF(opcode = "001010") THEN
		ALUControlS 	<= "1001";    ---BEQ
		RegDstS 	<= '0';
		BranchS		<= '1';
        	halts   	<= '0';
		MemtoRegS 	<= '0';
		MemWriteS 	<= '0';
		RegWriteS 	<= '0';
		ALUSrcS 	<= '0';
		jmpS 		<= '0';

	ELSIF(opcode = "001011") THEN
		ALUControlS 	<= "1010";    ----BNE
		RegDstS 	<= '0';
		BranchS		<= '1';
		MemtoRegS 	<= '0';
		MemWriteS 	<= '0';
		RegWriteS 	<= '0';
		ALUSrcS 	<= '0';
		jmpS 		<= '0';
		halts		<= '0';
		
	ELSIF(opcode = "001100") THEN
	    	jmpS 		<= '1';
	    	ALUControlS 	<= "1110";   -- JMP
		RegDstS 	<= '0';
		BranchS		<= '0';
		MemtoRegS 	<= '0';
		MemWriteS 	<= '0';
		RegWriteS 	<= '0';
		ALUSrcS 	<= '1';
		haltS		<= '0';
		
	ELSIF(opcode = "111111") THEN
	   	ALUControlS 	<= "1111"; -- HLT
	   	haltS		<= '1';
	   	RegDstS 	<= '0';
		BranchS		<= '0';
		MemtoRegS 	<= '0';
		MemWriteS 	<= '0';
		RegWriteS 	<= '0';
		ALUSrcS 	<= '0';
		jmpS 		<= '0';
	END IF;
END IF;
end process;

MemtoReg 	<= MemtoRegS;
MemWrite 	<= MemWriteS;
Branch 		<= BranchS;
ALUControl 	<= ALUControlS;
ALUsrc 		<= ALUsrcS;
RegDst		<= RegDstS;
RegWrite 	<= RegWriteS;
jmp		<=jmpS;
halt		<=haltS;

end Behavioral;



