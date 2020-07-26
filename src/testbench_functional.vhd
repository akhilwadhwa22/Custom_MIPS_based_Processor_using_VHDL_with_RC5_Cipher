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

ENTITY processor_tb IS
END processor_tb;

ARCHITECTURE behavior OF processor_tb IS 

COMPONENT TopModule

    Port ( out_ALU : out std_logic_vector(31 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        key_in : in std_logic_vector(127 DOWNTO 0);
        key_vld : in std_logic;
        din : in std_logic_vector(63 downto 0);
        din_vld : in std_logic;
        again : out std_logic;
        dout : out std_logic_vector(63 downto 0);
        enc : in std_logic;
        key_rdy: out std_logic
           );
end COMPONENT;

SIGNAL enc :  std_logic;
SIGNAL clk :  std_logic;
SIGNAL reset :  std_logic;
SIGNAL key_in :  std_logic_vector(127 downto 0);
SIGNAL key_vld :  std_logic;
SIGNAL din :  std_logic_vector(63 downto 0);
SIGNAL dout :  std_logic_vector(63 downto 0);
SIGNAL data_rdy :  std_logic;
SIGNAL again: std_logic;
SIGNAL out_ALU: std_logic_vector(31 downto 0);
SIGNAL din_vld: std_logic;

BEGIN
	uut: TopModule PORT MAP(
		enc      => enc,
		clk      => clk,
		reset      => reset,
		key_in      => key_in,
		key_vld  => key_vld,
		din      => din,
		dout     => dout,
		out_ALU => out_ALU,
		din_vld => din_vld,
        again   => again,
        key_rdy => key_rdy
	   );
TB: PROCESS
	BEGIN
		wait for 120ns;
		reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        enc <= '1';
        key_in <= x"00000000000000000000000000000000";
        din <= x"FEDCBA9876543210";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';

        wait until key_rdy='1';
        wait for 100ns;
        din_vld <= '1';
        wait until again ='1';
        din_vld <= '0';

        din <= x"eedba5216d8f4b15";

        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        din <= x"EA04BFBEB6EB797B";
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        din <= x"1122334455667788";
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        din <= x"0000000000000000";
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        din <= x"1111111111111111";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        key_in <= x"0123456789abcdef0123456789abcdef";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait until key_rdy='1';

        wait for 100ns;

        din <= x"FEDCBA9876543210";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        reset <= '1';
		key_vld <= '0';
		wait for 100ns;
        key_in <= x"000000000000000eabcd20000000ffff";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait until key_rdy='1';

        wait for 100ns;

        din <= x"1111111111111111";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        key_in <= x"00000000000000001111111111111111";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait for 800ns;
        wait until key_rdy='1';

        wait for 100ns;

        din <= x"FEDCBA9876543210";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        key_in <= x"0000000feda000000000000123400000";
        wait for 100ns;

        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait until key_rdy= '1';

        wait for 100ns;
        din <= x"eedba5216d8f4b15";
        wait for 100ns;

        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

--*********************DECRYPTION*********************************
        wait for 120ns;
		reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        enc <= '0';
        key_in <= x"00000000000000000000000000000000";
        din <= x"FEDCBA9876543210";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait until key_rdy='1';

        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        din <= x"eedba5216d8f4b15";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';

        din_vld <= '0';
        din <= x"EA04BFBEB6EB797B";
        wait for 100ns;

        din_vld <= '1';
        wait until again='1';

        din_vld <= '0';

        din <= x"1122334455667788";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        din <= x"0000000000000000";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';

        din <= x"1111111111111111";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';

        din_vld <= '0';

        reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        key_in <= x"0123456789abcdef0123456789abcdef";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait until key_rdy='1';

        wait for 100ns;

        din <= x"FEDCBA9876543210";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';

        din_vld <= '0';
        reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        key_in <= x"000000000000000eabcd20000000ffff";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';

        wait until key_rdy='1';
        wait for 100ns;
        din <= x"1111111111111111";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';

        din_vld <= '0';

        reset <= '1';
		key_vld <= '0';
		wait for 100ns;
        key_in <= x"00000000000000001111111111111111";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait until key_rdy='1';
        wait for 100ns;

        din <= x"FEDCBA9876543210";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1'
        din_vld <= '0';

        reset <= '1';
		key_vld <= '0';
		wait for 100ns;

        key_in <= x"0000000feda000000000000123400000";
        wait for 100ns;
        reset <= '0';
        wait for 100ns;
        key_vld <= '1';
        wait until key_rdy='1';

        wait for 100ns;

        din <= x"eedba5216d8f4b15";
        wait for 100ns;
        din_vld <= '1';
        wait until again='1';
        din_vld <= '0';
        wait;
	END PROCESS;
   ClkGen : PROCESS
   BEGIN

      wait for 50ns; 
		if clk = '1' then
			clk <= '0';
		else
			clk <= '1';
		end if;
   END PROCESS;
END;