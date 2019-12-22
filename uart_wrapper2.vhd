----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/05/2019 03:43:02 PM
-- Design Name: 
-- Module Name: uart_wrapper2 - Behavioral
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

            use ieee.std_logic_1164.all;
        
            use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_wrapper2 is
 Generic (
        CLK_FREQ      : integer := 50000000;   -- system clock frequency in Hz
        BAUD_RATE     : integer := 115200; -- baud rate value
        PARITY_BIT    : string  := "none"; -- type of parity: "none", "even", "odd", "mark", "space"
         NO_BYTE_SEND : integer := 1     
    );
 Port (
 CLK: in std_logic;
 CPU_RESET: in std_logic;
 USB_UART_TX: in std_logic;
 USB_UART_RX2: out std_logic;
 O_RX_OUT2: out std_logic_vector(7 downto 0);
 O_RX_VLD2: out std_logic;
 O_FRAME_ERROR2: out std_logic;
-- RST: in std_logic;
 I_TX_DATA: in std_logic_vector(7 downto 0);
--(* mark_debug = "true" *)     input  [07:0] I_TX_DATA,  // ///
--(* mark_debug = "true" *)     input         I_TX_START, // ///
I_TX_START: in std_logic;
  O_BUSY2: out std_logic );
end uart_wrapper2;

architecture Behavioral of uart_wrapper2 is
attribute mark_debug : string;
attribute keep : string;
attribute mark_debug of I_TX_DATA : signal is "true";
attribute mark_debug of I_TX_START : signal is "true";
constant SIZE : integer :=  2;
constant IDLE  :std_logic_vector (1 downto 0):= "00";
constant  START_TASK :std_logic_vector (1 downto 0):= "01";
constant TASK_PROGRESS  :std_logic_vector (1 downto 0):= "10";
constant TASK_END  :std_logic_vector (1 downto 0):= "11";

 --START_TASK = 2'b01, TASK_PROGRESS = 2'b10, TASK_END = 2'b11;
signal state_d: std_logic_vector (SIZE-1 downto 0);
signal next_state: std_logic_vector (SIZE-1 downto 0);
signal tx_start: std_logic;
signal tx_busy: std_logic;

--reg [SIZE-1 downto 0] state_d;
--reg [SIZE-1:0] next_state;
signal counter_d: std_logic_vector (1 downto 0);
--reg [01:0] counter_d;
signal counter: std_logic_vector (4 downto 0);
signal tx_data_d: std_logic_vector (15 downto 0);
begin

process (CLK,CPU_RESET)
begin
if (rising_edge(CLK)) then
if (CPU_RESET = '1') then
counter_d <= "00";
elsif(I_TX_START = '1') then
counter_d <= "00";
elsif(next_state = TASK_END) then
counter_d <=  counter_d + '1'; 
end if;
end if;
end process;

--always @(*) begin
--   counter = #1 counter_d;
--if(I_TX_START) begin
--   counter = #1 'd0;
--end else if(next_state == TASK_END) begin
--   counter = #1 counter_d + 1;
--end
--end

--always @(posedge CLK or posedge CPU_RESET) begin
--if(CPU_RESET) begin
--   counter_d <= #1 'd0;
--end else begin
--   counter_d <= #1 counter;
--end
--end
process (state_d,next_state)
begin
if (state_d /= IDLE or next_state /= IDLE) then
O_BUSY2 <= '1';
else O_BUSY2 <= '0';
end if;
end process;

process (state_d, counter_d, tx_busy, I_TX_START)
begin
next_state <= IDLE;
case(state_d) is
WHEN IDLE =>
IF I_TX_START = '1' THEN 
next_state <= START_TASK;
ELSE next_state <= IDLE;
end if;

WHEN START_TASK =>
next_state <= TASK_PROGRESS;

WHEN TASK_PROGRESS =>

IF tx_busy = '1' THEN 
next_state <= TASK_PROGRESS;
ELSE next_state <= TASK_END;
end if;

WHEN TASK_END => 
IF counter_d = "00" or counter_d = "11" or counter_d = "10"   THEN 
next_state <= START_TASK;
ELSE next_state <= IDLE;
end if;
WHEN OTHERS => next_state <= IDLE;
end case;
end process;
--always @(*) begin
--next_state = IDLE;
-- case(state_d)
--    IDLE          : if (I_TX_START) begin
--                          next_state = START_TASK;
--                    end else begin
--                      next_state = IDLE;
--                    end
--    START_TASK    : next_state = TASK_PROGRESS;
--    TASK_PROGRESS : if (tx_busy) begin
--                      next_state = TASK_PROGRESS;
--                    end else begin
--                      next_state = TASK_END;
--                    end
--    TASK_END      : if(counter_d != NO_BYTE_SEND) begin
--                       next_state = START_TASK;
--                    end else begin
--                       next_state = IDLE;
--                    end
--    default       : next_state = IDLE;
--  endcase
--end  
PROCESS (CLK, CPU_RESET)
begin 
if (rising_edge(CLK)) then
if(CPU_RESET = '1') then
tx_data_d <= "0000000000000000";
else
tx_data_d <= "00000000" & I_TX_DATA;
end if;
end if;
end process;    

PROCESS (CLK, CPU_RESET)
begin
if (rising_edge(CLK)) then
if(CPU_RESET= '1') then
state_d <= IDLE;
 else
 state_d <= next_state;
end if;
end if;
end process; 

PROCESS (next_state)
begin
if(next_state = START_TASK)then
tx_start <= '1';
ELSE tx_start <= '0';
end if;
end process; 

--assign tx_start = (next_state == START_TASK);
--assign tx_data  = tx_data_d;//(counter_d[0] == 1) ? tx_data_d[7:0] : I_TX_DATA[15:8];

uart: entity work.UART  
generic map( PARITY_BIT => PARITY_BIT,
              BAUD_RATE =>BAUD_RATE,
              CLK_FREQ=>CLK_FREQ)
              port map (CLK=>CLK, RST=>CPU_RESET, UART_TXD => USB_UART_RX2, UART_RXD => USB_UART_TX, 
              DATA_OUT => O_RX_OUT2, DATA_VLD => O_RX_VLD2,
               FRAME_ERROR => O_FRAME_ERROR2,DATA_IN => TX_DATA_D( 7 downto 0), 
               DATA_SEND =>TX_START, BUSY=> TX_BUSY); 
               


end Behavioral;
