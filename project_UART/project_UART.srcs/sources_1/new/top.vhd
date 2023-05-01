----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.04.2023 15:18:47
-- Design Name: 
-- Module Name: top - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is

port(
    RESET_syn   : in std_logic;
    BTNC        : in std_logic;
    SW          : in std_logic_vector(8-1 downto 0);
    CLK100MHZ   : in std_logic;  
    rx_T          : in std_logic;
    LED         : out std_logic_vector(8-1 downto 0);
    tx_T          : out std_logic;
    tx_end_T      : out std_logic;
    tx_A_T        : out std_logic
    
         );  
end top;

architecture Behavioral of top is
    signal BTreset : std_logic;
    signal s_data : std_logic_vector(8-1 downto 0);
    signal s_bound : std_logic_vector(16-1 downto 0);
    signal s_enable	 	: std_logic;
begin
    s_data(0) <= SW(0);
    s_data(1) <= SW(1);
    s_data(2) <= SW(2);
    s_data(3) <= SW(3);
    s_data(4) <= SW(4);
    s_data(5) <= SW(5);
    s_data(6) <= SW(6);
    s_data(7) <= SW(7);
       
        
    RX_UART: entity work.receiver
    port map(
        Clk=>CLK100MHZ,
        rx_serial=>rx_T,
        rx_dout=>LED

    );    
    
    TX_UART: entity work.Transmitter
    port map(
         i_Clk=>CLK100MHZ,
         i_TX_DV=>BTNC,
         o_TX_Active=>tx_A_T,
         o_TX_Done=>tx_end_T,
         o_TX_Serial=>tx_T,
         i_TX_Byte=>s_data
    );
    
     clock: entity work.Clock_enable
        port map(
        Num_clkPer => s_bound,
        RESET=>RESET_syn,
        ce=>s_enable,
        Clk=> CLK100MHZ
        
      );
      
  UART_Speed : process (CLK100MHZ)
    begin		
		if CLK100MHZ'event and CLK100MHZ ='1' then
		  s_bound <= x"28a0";	--10400
		end if;
    end process UART_Speed;	    
end Behavioral;