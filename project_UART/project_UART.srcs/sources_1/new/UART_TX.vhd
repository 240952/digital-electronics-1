library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Transmitter is
  generic (
    g_CLKS_PER_BIT : integer := 115    
    );
-----------------------------------------------------------
-- i_TX_DV       platny signal
-- i_TX_Byte     data pro prenos
-- o_TX_Active   aktivni signal na vystupu
-- o_TX_Serial   samotna prenasena data
-- o_TX_Done     dokonceni prenosu dat
-----------------------------------------------------------
  port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end Transmitter;

 
architecture RTL of Transmitter is
------------------------------------------------------
-- stavovehy automat a jeho stavy
------------------------------------------------------
  type t_SM_Main is (s_Idle, s_TX_Start_Bit, s_TX_Data_Bits,
                     s_TX_Stop_Bit, s_Cleanup);
  signal r_SM_Main : t_SM_Main := s_Idle;
-------------------------------------------------------
-- signal r_Clk_Count    clock odpocet
-- signal r_Bit_Index    8 bitu celkove
-- signal r_TX_Data      TX ulozeni odeslanych dat
-- signal r_TX_Done      odesilani dat dokonceno
--------------------------------------------------------

  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0; 
  signal r_Bit_Index : integer range 0 to 7 := 0;  
  signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0'; 
   
begin
   
  p_UART_TX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
         
      case r_SM_Main is
 
----------------------------------------------------
-- nastaveni pocatecnich hodnot
----------------------------------------------------
when s_Idle =>
      o_TX_Active <= '0';
      o_TX_Serial <= '1';         
      r_TX_Done   <= '0';
      r_Clk_Count <= 0;
      r_Bit_Index <= 0;
 
if i_TX_DV = '1' then
      r_TX_Data <= i_TX_Byte;
      r_SM_Main <= s_TX_Start_Bit;
else                       
      r_SM_Main <= s_Idle; end if; -- Posle start bit. 
      o_TX_Active <= '1';
      o_TX_Serial <= '0';
 
--------------------------------------------------------------------
-- Wait g_CLKS_PER_BIT-1 clock cyklus pro startovni bit to finish
--------------------------------------------------------------------
if r_Clk_Count < g_CLKS_PER_BIT-1 then
       r_Clk_Count <= r_Clk_Count + 1;
       r_SM_Main   <= s_TX_Start_Bit;
else
       r_Clk_Count <= 0;
------------------------------------------------------------------------------------
-- Wait g_CLKS_PER_BIT-1 clock cyklus pro data bits to finish when s_TX_Data_Bits =>
-------------------------------------------------------------------------------------
-- r_SM_Main <=s_tx_DataBits;   zmena stavu, priprva na odesilani datovych bytu
-------------------------------------------------------------------------------------
        r_SM_Main   <= s_TX_Data_Bits; 
end if; 
        o_TX_Serial <= r_TX_Data(r_Bit_Index);
           
if r_Clk_Count < g_CLKS_PER_BIT-1 then
        r_Clk_Count <= r_Clk_Count + 1;
        r_SM_Main   <= s_TX_Data_Bits;
else
         r_Clk_Count <= 0;
             
            
if r_Bit_Index < 7 then
         r_Bit_Index <= r_Bit_Index + 1;
         r_SM_Main   <= s_TX_Data_Bits;
else
         r_Bit_Index <= 0;
         r_SM_Main   <= s_TX_Stop_Bit; end if; end if; -- Posle stop bit. 
         o_TX_Serial <= '1';
 
--------------------------------------------------------------
-- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
--------------------------------------------------------------
if r_Clk_Count < g_CLKS_PER_BIT-1 then
          r_Clk_Count <= r_Clk_Count + 1;
          r_SM_Main   <= s_TX_Stop_Bit;
else
          r_TX_Done   <= '1';
          r_Clk_Count <= 0;
          r_SM_Main   <= s_Cleanup; end if; -- stay here 1 clock when s_Cleanup =>
          o_TX_Active <= '0';
          r_TX_Done   <= '1';
          r_SM_Main   <= s_Idle; when others =>
          r_SM_Main <= s_Idle;
 
      end case;
    end if;
  end process p_UART_TX;
 
  o_TX_Done <= r_TX_Done;
   
end RTL;
