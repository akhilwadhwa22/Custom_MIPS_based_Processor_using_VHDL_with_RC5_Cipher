----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/24/2019 11:12:11 AM
-- Design Name: 
-- Module Name: rc5_test - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;


--library textutil;       -- Synposys Text I/O package
--use textutil.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity final_test is
--  Port ( );
end final_test;

architecture Behavioral of final_test is

component final port
( clr : in STD_LOGIC;
           clk : in STD_LOGIC;
           CLK100M : in STD_LOGIC;
           SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0); -- 7Segment LED cathode port. Common for all 7Segment. (7 display + 1 decimal point (DP))
         --  SSEG_AN : out  STD_LOGIC_VECTOR (7 downto 0); --For nexsys4-DDR, 7Segment LED anode port. One for each 7Segment LED
              SSEG_AN : out  STD_LOGIC_VECTOR (3 downto 0); --For Basys3, 7Segment LED anode port. One for each 7Segment LED           
           data : in STD_LOGIC;
           detect : out STD_LOGIC);
end component;

signal main_clock : std_logic;
signal btnc       : std_logic;
signal btnu       : std_logic;
signal cur_in     : std_logic_vector(15 downto 0);
signal led        : std_logic_vector(15 downto 0);
signal sseg_ca    : std_logic_vector(07 downto 0);
signal sseg_an    : std_logic_vector(03 downto 0);

--internal signals
signal key_rdy1 : std_logic;
signal enc_rdy1 : std_logic;
signal out_ref  : std_logic;

--File operation
  file file_enc_in : text;
  file file_enc_out : text;
  file file_enc_out2 : text;
  signal input_ref : std_logic_vector(15 downto 0);
  

--function

constant main_clock_period : time := 20ns; --change the clock period of the clock, HERE.


begin

process --File operation process
    variable enc_in : line;
    variable enc_op : line;
    variable enc_input : std_logic_vector(15 downto 0);

begin

    -- File operations.
    report "in process loop";
    file_open(file_enc_in,  "/home/parallels/Documents/Vivado_Projects/input_pattern.txt",  read_mode);
    
    --Run the loop till all the file content is not read.
    while not endfile(file_enc_in) loop
	   report "in while loop";
	   --Read from the file.
	   readline(file_enc_in, enc_in);
	   read(enc_in, enc_input);

	   --next when enc_input'length = 0;  -- Skip empty lines
	   input_ref  <= enc_input;
	   -- Stimulation of RC5 starting with Key Generation. 
	   btnc <= '0';
	   out_ref <= '0';
       btnu <= '1'; 
       --wait for 20ns;
	   btnc <= '1';
	   wait for 20ns;
	   btnc <= '0';
	   wait for 20ns;
	   wait for 100ns;
	   --Print input data to TCL console.
	   --report "input = " & to_hstring(input_ref); 
	   --Give input for the RC5 encryption
       cur_in   <= input_ref(15 downto 0);
       for I in 15 downto 0 loop
           btnu <= '0';
           wait for 20ns;
           btnc <= '1';
           
           if(I > 11) then
              out_ref <= '0';
           else
              if(input_ref(3 downto 0) = "1010") then
                  out_ref <= '1';
              else
                  out_ref <= '0';
              end if;
              if(input_ref(3 downto 0) = "1011") then
                  out_ref <= '1';
              else
                  out_ref <= '0';
              end if;
              input_ref <= input_ref(14 downto 0)& '0';
           end if;
              
           if(led(0) = out_ref)  then
           --print to TCL console
                report "Input pattern correct."; --& (to_hstring(input_ref));
           else
           --print to TCL console
                report "Input pattern is NOT correct.";-- & to_hstring(input_ref) severity error;
           end if; 
           cur_in <= cur_in(14 downto 0)& '0';  
           wait for 20ns;
           btnc <= '0';
           --wait for 20ns;
           
           
           
       end loop;
	   wait for 20ns;
	   btnc <= '1';
	   wait for 20ns;
	   btnc <= '0';
	   wait for 20ns;
    end loop;
    file_close(file_enc_in);
    wait; -- put wait for EVERY process that you dont want to repeat continously.
end process;

--This process generates the 100MHz clock. As soon as the process ends, it again starts from the beginning. Hence, clock changes continously between '0' and '1'.
process begin
    main_clock  <= '0';
    wait for main_clock_period/2;
    main_clock  <= '1';
    wait for main_clock_period/2;
end process;

--Instantiation of module
dut: final port map(CLK100M => main_clock, clk  => btnc, clr => btnu, data => cur_in(15), detect => led(0), SSEG_AN => sseg_an, SSEG_CA => sseg_ca);	



end Behavioral;
