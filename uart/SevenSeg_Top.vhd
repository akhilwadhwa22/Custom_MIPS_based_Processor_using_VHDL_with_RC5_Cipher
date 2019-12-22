library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity SevenSeg_Top is
    Port ( 
           CLK 			: in  STD_LOGIC;
--           data_in      : in   STD_LOGIC_VECTOR (31 downto 0); --For Nexsys4-DDR
           data_in      : in   STD_LOGIC_VECTOR (15 downto 0); --For Basys3
           SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN 		: out  STD_LOGIC_VECTOR (3 downto 0) --For Basys3
--           SSEG_AN 		: out  STD_LOGIC_VECTOR (7 downto 0) --For Nexsys4-DDR
			);
end SevenSeg_Top;

architecture Behavioral of SevenSeg_Top is

component Hex2LED --Converts a 4 bit hex value into the pattern to be displayed on the 7seg
port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component; 

type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;
signal Val : std_logic_vector(3 downto 0) := (others => '0');
--signal HexVal: std_logic_vector(31 downto 0); --For NExsys4-DDR
signal HexVal: std_logic_vector(15 downto 0);
signal slowCLK: std_logic:='0';
signal i_cnt: std_logic_vector(19 downto 0):=x"00000";

begin
-----Creating a slowCLK of 500Hz using the board's 100MHz clock----
process(CLK)
begin
if (rising_edge(CLK)) then
--if (i_cnt=x"186A0")then --Hex(186A0)=Dec(100,000)
if (i_cnt=x"C350")then --Hex(186A0)=Dec(100,000)
slowCLK<=not slowCLK; --slowCLK toggles once after we see 100000 rising edges of CLK. 2 toggles is one period.
i_cnt<=x"00000";
else
i_cnt<=i_cnt+'1';
end if;
end if;
end process;

-----We use the 500Hz slowCLK to run our 7seg display at roughly 60Hz-----
timer_inc_process : process (slowCLK)
begin
	if (rising_edge(slowCLK)) then
				if(Val="1000") then
				Val<="0001";
				else
				Val <= Val + '1'; --Val runs from 1,2,3,...8 on every rising edge of slowCLK
			end if;
		end if;
	--end if;
end process;

--This select statement selects one of the 7-segment diplay anode(active low) at a time. 
--with Val select
--	SSEG_AN <= "01111111" when "0001",
--				  "10111111" when "0010",
--				  "11011111" when "0011",
--				  "11101111" when "0100",
--				  "11110111" when "0101",
--				  "11111011" when "0110",
--				  "11111101" when "0111",
--				  "11111110" when "1000",
--				  "11111111" when others;
with Val select
	SSEG_AN <= "0111" when "0001",
				  "1011" when "0010",
				  "1101" when "0011",
				  "1110" when "0100",
				  "1111" when others;

--This select statement selects the value of HexVal to the necessary
--cathode signals to display it on the 7-segment
--with Val select
--	SSEG_CA <= NAME(0) when "0001", --NAME contains the pattern for each hex value to be displayed.
--				  NAME(1) when "0010", --See below for the conversion
--				  NAME(2) when "0011",
--				  NAME(3) when "0100",
--				  NAME(4) when "0101",
--				  NAME(5) when "0110",
--				  NAME(6) when "0111",
--				  NAME(7) when "1000",
--				  NAME(0) when others;

with Val select
	SSEG_CA <= NAME(0) when "0001", --NAME contains the pattern for each hex value to be displayed.
				  NAME(1) when "0010", --See below for the conversion
				  NAME(2) when "0011",
				  NAME(3) when "0100",
				  NAME(0) when others;
				  
HexVal<=data_in;--x"CCCCAAAA";
--Trying to display CCCCAAAA on the 7segment display by first sending it to 
--Hex2LED for converting each Hex value to a pattern to be given to the cathode.
--CONV1: Hex2LED port map (CLK => CLK, X => HexVal(31 downto 28), Y => NAME(0));
--CONV2: Hex2LED port map (CLK => CLK, X => HexVal(27 downto 24), Y => NAME(1));
--CONV3: Hex2LED port map (CLK => CLK, X => HexVal(23 downto 20), Y => NAME(2));
--CONV4: Hex2LED port map (CLK => CLK, X => HexVal(19 downto 16), Y => NAME(3));		
--CONV5: Hex2LED port map (CLK => CLK, X => HexVal(15 downto 12), Y => NAME(4));
--CONV6: Hex2LED port map (CLK => CLK, X => HexVal(11 downto 8), Y => NAME(5));
--CONV7: Hex2LED port map (CLK => CLK, X => HexVal(7 downto 4), Y => NAME(6));
--CONV8: Hex2LED port map (CLK => CLK, X => HexVal(3 downto 0), Y => NAME(7));
	
CONV1: Hex2LED port map (CLK => CLK, X => HexVal(15 downto 12), Y => NAME(0));
CONV2: Hex2LED port map (CLK => CLK, X => HexVal(11 downto 8), Y => NAME(1));
CONV3: Hex2LED port map (CLK => CLK, X => HexVal(7 downto 4), Y => NAME(2));
CONV4: Hex2LED port map (CLK => CLK, X => HexVal(3 downto 0), Y => NAME(3));
end Behavioral;