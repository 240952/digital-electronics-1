
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity top is

port(
    BTNC        : in std_logic;
    SW          : in std_logic_vector(8-1 downto 0);
    CA        : out   std_logic; --! Katoda A
    CB        : out   std_logic; --! Katoda B
    CC        : out   std_logic; --! Katoda C
    CD        : out   std_logic; --! Katoda D
    CE        : out   std_logic; --! Katoda E
    CF        : out   std_logic; --! Katoda F
    CG        : out   std_logic; --! Katoda G
    DP        : out   std_logic; 
    AN        : out   std_logic_vector(7 downto 0);
    CLK100MHZ   : in std_logic;  
    RX_T          : in std_logic;
    LED         : out std_logic_vector(8-1 downto 0);
    TX_T          : out std_logic;
    TX_End_T      : out std_logic;
    TX_A_T        : out std_logic;
    syn        : in std_logic
         );  
end top;

architecture Behavioral of top is
    signal BTreset : std_logic;
    signal s_data : std_logic_vector(8-1 downto 0);
    signal s_bound : std_logic_vector(16-1 downto 0);
    signal s_enable	 	: std_logic;
begin
  driver_seg_4 : entity work.driver_7seg_4digits
      port map (
          clk      => CLK100MHZ,
          rst      => BTNC,
          data3(3) => s_data(7),
          data3(2) => s_data(6),
          data3(1) => s_data(5),
          data3(0) => s_data(4),
          
          data2(3) => s_data(3),
          data2(2) => s_data(2),
          data2(1) => s_data(1),
          data2(0) => s_data(0),
          
          data1(3) => SW(7),
          data1(2) => SW(6),
          data1(1) => SW(5),
          data1(0) => SW(4),
          
          data0(3) => SW(3),
          data0(2) => SW(2),
          data0(1) => SW(1),
          data0(0) => SW(0),

          -- DECIMAL POINT
          dp_vect => "1111",
          dp      => DP,

          seg(6) => CA,      
          seg(5) => CB,
          seg(4) => CC,
          seg(3) => CD,
          seg(2) => CE,
          seg(1) => CF,
          seg(0) => CG,


          -- DIGITS
          dig(7 downto 0) => AN(7 downto 0)
      );       

-----------------------------------------------
--Propojeni Receiver a Transmitter do topu
-----------------------------------------------
        
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
        RESET=>syn,
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
