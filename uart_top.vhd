----------------------------------------------------------------------------------
-- Company: NYU Wireless
-- Engineer: Siddharth Murali
-- 
-- Create Date: 10/10/2018 01:05:02 AM
-- Design Name: 
-- Module Name: uart_TOP - Behavioral
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.state_pkg.all;

entity uart_top is
    Port ( 
           CLK100MHZ : in STD_LOGIC; --System Clock
           BTNC : in STD_LOGIC; -- Center button for RESET
           BTND : in STD_LOGIC; -- Right Button for Register File Display + sw(6)
           BTNL : in STD_LOGIC; -- Right Button for SlowClk + sw(5) for single-stepping
           SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0); -- 7Segment LED cathode port. Common for all 7Segment. (7 display + 1 decimal point (DP))
           sw : in STD_LOGIC_VECTOR(15 downto 0);
           SSEG_AN : out  STD_LOGIC_VECTOR (3 downto 0); --For Basys3, 7Segment LED anode port. One for each 7Segment LED
           UART_TXD_IN : in STD_LOGIC; -- UART receiver for FPGA.
           UART_RXD_OUT : out STD_LOGIC;
           LED : OUT std_logic_vector(15 downto 0)); -- UART transmitter for FPGA.
end uart_top;

architecture Behavioral of uart_top is
signal CLK50MHZ: std_logic; -- Clockc reduction as combinational logic does not fit into 100MHz.
signal tx_vld: std_logic; -- start transmitting data from UART.
signal a: std_logic_vector(127 downto 0); -- First input
signal c: std_logic_vector(63 downto 0); -- output of the RC5
signal o_rx_out: std_logic_vector(7 downto 0); -- Received value from UART which goes to input of RC5.
signal tx_data: std_logic_vector(7 downto 0); -- Trasnitting data to UART. It is output of RC5 for this code.
signal o_frame_error: std_logic; --If UART not working, value "1".
signal uart_busy: std_logic; -- When uart transmitts, it is '1'.
signal uart_busy_d: std_logic; -- 1 clock cycle delay of uart_busy.
signal vld: std_logic; -- Valid Received Signal
signal k1:std_logic; -- output of RC5 is ready.
signal k1_d:std_logic; -- output of RC5 is ready.
signal rx_counter: std_logic_vector(3 downto 0); --Couting the received values. It should recieve 8-bytes.
signal tx_counter: std_logic_vector(2 downto 0); --Couting the transmitted values. It should recieve 4-bytes.
signal tx_start: std_logic; -- Start of the transmission.
signal delay_counter: std_logic_vector(15 downto 0); -- Delay to wait for 0xFFFE clock cycle to wait for additional inputs from UART.
signal display1 : std_logic_vector(15 downto 0);
signal display2 : std_logic_vector(15 downto 0);
signal display : std_logic_vector(15 downto 0);
signal display_ctrl_1 : std_logic_vector(4 downto 0);
signal state: s_type;
signal dout1 : STD_LOGIC_VECTOR(63 downto 0);
signal dout2 : STD_LOGIC_VECTOR(127 downto 0);
signal a_d: std_logic_vector(127 downto 0); -- Register the first input of RC5.
signal sel1 : std_logic_vector(4 downto 0) := "00000";
signal ram_disp : std_logic_vector(31 downto 0);
signal clkselect : std_logic_vector(1 downto 0);
signal fastCnt : std_logic_vector(25 downto 0);
signal slwclk : std_logic := '0';
signal PC_val : std_logic_vector(31 downto 0);

component TopModule is
    Port (  clk : in std_logic;
            reset : in std_logic;
            din : in std_logic_vector(127 downto 0);
            din_vld :in  std_logic;
            d_out : out std_logic_vector(63 downto 0);
            d_out1 : out std_logic_vector(63 downto 0);
            d_out2 : out std_logic_vector(127 downto 0);
            again : in std_logic;
            enc : in std_logic;
            state_temp: out s_type;
            key_rdy: out  std_logic;
            PC_val : out std_logic_vector(31 downto 0);
            sel1 : in std_logic_vector(4 downto 0);
            regfile1 : out std_logic_vector(31 downto 0)   
        );
end component TopModule;

component SevenSeg_Top is
    Port ( 
           CLK 			: in  STD_LOGIC; -- system clock
           data_in      : in   STD_LOGIC_VECTOR (15 downto 0); --For Basys3, datato be displayed on 7Seg
           SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0); -- 7Segment cathode.
           SSEG_AN      : out  STD_LOGIC_VECTOR (3 downto 0) --For Basys3, 7Segment Anode.
			);
end component;

component debounce port(
    clk     : IN  STD_LOGIC;  --input clock
    reset_n : IN  STD_LOGIC;  --asynchronous active low reset
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
end component;

component clk_wiz_0 port (
  -- Clock out ports
  clk_out1 : out STD_LOGIC;
 -- Clock in ports
  clk_in1 : in STD_LOGIC);
end component;

component uart_wrapper2 port(
    CLK: in std_logic; --clock in ports
    CPU_RESET: in std_logic; -- reset port
    USB_UART_TX: in std_logic; -- UART receiving for FPGA.
    USB_UART_RX2: out std_logic; -- UART transmitting from FPGA.
    O_RX_OUT2: out std_logic_vector(7 downto 0); -- The received value in 8-bits (1-byte).
    O_RX_VLD2: out std_logic; -- The received 8-bits are valid.
    O_FRAME_ERROR2: out std_logic; -- Error in UART.
    I_TX_DATA: in std_logic_vector(7 downto 0); -- Transmit value.
    I_TX_START: in std_logic; -- Start the transmittion of the I_TX_DATA when '1'.
    O_BUSY2: out std_logic -- When '1', UART is busy transmissting and cannot transmitt other data.
 );
    end component;

begin

u_uart_wrapper: uart_wrapper2 port map(
    CLK           => CLK50MHZ       ,
    CPU_RESET     => BTNC   ,
    USB_UART_TX   => UART_TXD_IN   ,
    USB_UART_RX2   => UART_RXD_OUT  ,
    O_RX_OUT2      => o_rx_out      , 
    O_RX_VLD2      => vld      ,
    O_FRAME_ERROR2 => o_frame_error ,
    I_TX_DATA     => tx_data ,
    I_TX_START    => tx_vld,
    O_BUSY2        => uart_busy     
    );
    

u_sevenSeg_inst: SevenSeg_Top Port map ( 
               CLK           => CLK50MHZ,
               data_in      => display, -- For Basys3
               SSEG_CA      => SSEG_CA,
               SSEG_AN      => SSEG_AN
);
        
u_clk_inst: clk_wiz_0 port map(
      -- Clock out ports
      clk_out1 => CLK50MHZ,
     -- Clock in ports
      clk_in1 => CLK100MHZ);

with rx_counter select
a <= o_rx_out & a(119 downto 0) when "0000",
  a(127 downto 120) & o_rx_out & a(111 downto 0) when "0001",
  a(127 downto 112) & o_rx_out & a(103 downto 0) when "0010",
  a(127 downto 104) & o_rx_out & a(95 downto 0) when "0011",
  a(127 downto 96) & o_rx_out & a(87 downto 0) when "0100",
  a(127 downto 88) & o_rx_out & a(79 downto 0) when "0101",
  a(127 downto 80) & o_rx_out & a(71 downto 0) when "0110",
  a(127 downto 72) & o_rx_out & a(63 downto 0) when "0111",
  a(127 downto 64) & o_rx_out & a(55 downto 0) when "1000",
  a(127 downto 56) & o_rx_out & a(47 downto 0) when "1001",
  a(127 downto 48) & o_rx_out & a(39 downto 0) when "1010",
  a(127 downto 40) & o_rx_out & a(31 downto 0) when "1011",
  a(127 downto 32) & o_rx_out & a(23 downto 0) when "1100",
  a(127 downto 24) & o_rx_out & a(15 downto 0) when "1101",
  a(127 downto 16) & o_rx_out & a(07 downto 0) when "1110",
  a(127 downto 08) & o_rx_out when "1111",
  a when others;


PROCESS(CLK50MHZ, BTNC) begin
if(rising_edge(CLK50MHZ)) then
   if(BTNC = '1') then
        k1_d <= '0';
   else
        k1_d <= k1;
   end if;
   end if;
end process;

PROCESS(CLK50MHZ, BTNC) begin
if(rising_edge(CLK50MHZ)) then
   if(BTNC = '1') then
        a_d <= x"00000000000000000000000000000000";
        rx_counter <= "0000";
   elsif(vld = '1') then
        a_d <= a;
        rx_counter <= rx_counter + '1';
   end if;
   end if;
end process;

PROCESS(CLK50MHZ, BTNC) begin
if(rising_edge(CLK50MHZ)) then
   if(BTNC = '1') then
        delay_counter <= x"FFFF";
   elsif(vld = '1') then
        delay_counter <= x"0000";
   elsif(delay_counter < x"FFFF") then
        delay_counter <= delay_counter + '1';
   end if;
   end if;
end process;


process(delay_counter) begin
if(delay_counter = x"FFFE") then
    tx_start <= '1';
else 
    tx_start <= '0';
end if;
end process;

process(tx_start, uart_busy_d, tx_counter) begin
if((k1_d = '1')  or ((uart_busy_d = '0') and (tx_counter /= "000")) )  then
    tx_vld <= '1';
else 
    tx_vld <= '0';
end if;
end process;

PROCESS(CLK50MHZ, BTNC) begin
if(rising_edge(CLK50MHZ)) then
   if(BTNC = '1') then
    uart_busy_d <= '1';
   else
    uart_busy_d <= uart_busy;
   end if;
   end if;
end process;

with tx_counter select
tx_data <= c(63 downto 56) when "000",
          c(55 downto 48) when "001",
          c(47 downto 40) when "010",
          c(39 downto 32) when "011",
          c(31 downto 24) when "100",
          c(23 downto 16) when "101",
          c(15 downto 08) when "110",
          c(07 downto 00) when "111",
          c(63 downto 56) when others;

PROCESS(CLK50MHZ,BTNC) begin
if(rising_edge(CLK50MHZ)) then
       if(BTNC = '1') then 
            tx_counter <= "000";
       elsif(tx_vld = '1') then
            tx_counter <= tx_counter + '1';
       end if;
   end if;
end process;

processor: TopModule port map(
    clk         => CLK50MHZ,
    reset       => BTNC,
    din         => a_d,
    din_vld     => tx_start,
    d_out       => c,
    d_out1      => dout1,
    d_out2      => dout2,
    state_temp  => state,
    again       => sw(15),                   
    enc         => sw(14),                
    key_rdy     => k1,
    PC_val      => PC_val,
    sel1        => sel1,
    regfile1    => ram_disp
);

-- Display Settings

with state select
display1 <= x"8888" when PKG,
           x"8881" when KG,
           x"8810" when IRC,
           x"8101" when IRD,
           x"1010" when ENCRYPT,
           x"1011" when DECRYPT,
           x"abcd" when others;
           

display2 <= c(15 downto 0);
          
display_ctrl_1 <= sw(4) & sw(3) & sw(2) & sw(1) & sw(0);

process(BTND, sw)
begin

    if(BTND = '1' and rising_edge(sw(6))) then
        if (sel1 = "11111") then
            sel1 <= "00000";
        else
            sel1 <= sel1+'1';
        end if;
    end if;
end process;

process(display_ctrl_1, BTND, sw)
begin

if (BTND = '1') then
    display <= ram_disp(15 downto 0);

else 
    case display_ctrl_1 is
        when "00000" => display <= dout2(127 downto 112);
        when "00001" => display <= dout2(111 downto 96);
        when "00010" => display <= dout2(95 downto 80);
        when "00011" => display <= dout2(79 downto 64);
        when "00100" => display <= dout2(63 downto 48);
        when "00101" => display <= dout2(47 downto 32);
        when "00110" => display <= dout2(31 downto 16);
        when "00111" => display <= dout2(15 downto 0);
        when "10000" => display <= display2;
        when "11000" => display <= display1;
        when "11100" => display <= PC_val(15 downto 0);
        when "01000" => display <= dout1(15 downto 0);
        when others  => display <= x"fefe";

    end case;
end if;

end process;
            
LED <= sw;

end Behavioral;