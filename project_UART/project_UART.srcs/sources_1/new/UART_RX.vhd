library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity receiver is
    generic(
        Clk_per_bit   :     integer := 650
    );
    
-----------------------------------------------------------------
-- Clk              Vstupní hodinový signál
-- rx_serial        Vstupní sériový datový signál
-- rx_data_valid    Výstupní indikátor platného datového signálu
-- rx_dout          Výstupní osmibitový datový signál
-----------------------------------------------------------------
    port(
        Clk           :     in  std_logic;    
        rx_serial     :     in  std_logic;    
        rx_data_valid :     out std_logic;    
        rx_dout       :     out std_logic_vector(7 downto 0) 
    );    
    end receiver;

architecture Behavioral of receiver is

---------------------------------------------------------
-- stavovovy automat pro prijem UART signalu
---------------------------------------------------------

-- signal H_data        Pomocný registr pro p?ijatá data
-- signal A_data        Aktuální bit dat p?ijatých z UART
---------------------------------------------------------
type t_SM_Main is (s_idle, s_StartBit_rx, s_DataBits_rx,
                     s_StopBit_rx, s_clear);  
  signal r_SM_Main : t_SM_Main := s_idle;
 
  -- Pomocné signály pro p?íjem dat
  signal H_data   : std_logic := '0';  
  signal A_data   : std_logic := '0';  
 
-----------------------------------------------------------
-- Signaly pro rizeni prijeti dat
-----------------------------------------------------------

-- signal s_indexBitA       Index aktualni prijateho bitu
-- signal s_bytes           Prijaty byte 
-----------------------------------------------------------
  signal s_ClkCount     :   integer range 0 to Clk_per_bit-1 := 0;  
  signal s_indexBitA    :   integer range 0 to 7 := 0;  
  signal s_bytes        :   std_logic_vector(7 downto 0) := (others => '0');  
  signal s_data_valid           :   std_logic := '0';  
  
begin

----------------------------------------------
-- Vzorkovani serieoveho vstupu
--------------------------------------------

 IN_sample : process(Clk)

begin
   if Clk'event and Clk ='1' then
       H_data <= rx_serial;
       A_data <= H_data;
end if;    
    end process;
  UART_receiver : process(Clk)
begin
    if Clk'event and Clk = '1' then
       case r_SM_Main is 
                
------------------------------------------------
-- Vstupni stav
------------------------------------------------

when s_idle => -- Vstuoni stav
     s_data_valid<=  '0'; -- Nula do platnych dat
     s_ClkCount  <=   0;  -- Nula do pocitadla
     s_indexBitA <=   0;  -- Nula do aktualniho indexu bitu
                        
if A_data = '0' then -- pokud je aktulani hodnota signalu 0
     r_SM_Main <= s_StartBit_rx; --do stavu start
else
      r_SM_Main <= s_idle; -- jinak v idle
end if;        
     when s_StartBit_rx =>
if s_ClkCount = (Clk_per_bit-1)/2 then -- zda uplynula doba trvani 1 bitu
if A_data = '0' then --hodnota aktualni hodnota signalu 0
       s_ClkCount <=0; -- reset clkcount
       r_SM_Main <= s_DataBits_rx; -- do stavu dataBits
else
       r_SM_Main <= s_idle;   
end if;
       s_ClkCount <= s_ClkCount +1; -- inkrementuj count
       r_SM_Main <= s_StartBit_rx;                            
end if;  
     when  s_DataBits_rx => -- stav pro zpracovani bitu
if s_ClkCount < Clk_per_bit-1 then -- pokud neuplynulo  
       s_ClkCount <= s_ClkCount +1;
       r_SM_Main <= s_DataBits_rx; -- zustavame v tomto stavu
else
       s_ClkCount <= 0;
       s_bytes(s_indexBitA) <= A_data;  --ulozeni prijeteho bitu
if s_indexBitA<7 then -- zde kontroluju,zda jsem prijal vsechny bity
       s_indexBitA <= s_indexBitA+1;
       r_SM_Main <=s_DataBits_rx;
else
       s_indexBitA <=0;
       r_SM_Main <=s_StopBit_rx; 
end if;  
   end if;    
when s_StopBit_rx => --stav pro zpracovani stop bitu
 if s_ClkCount < Clk_per_bit-1 then
        s_ClkCount <= s_ClkCOunt + 1;
        r_SM_Main <= s_StopBit_rx;
else  
        s_data_valid <= '1'; -- oznacim si, ze znam nove data
        s_ClkCount <= 0;
        r_SM_Main <=s_clear;
end if;
      when  s_clear =>
         r_SM_Main <= s_idle;
         s_data_valid <='0';
      when others =>
         r_SM_Main <= s_idle;                                                    

----------------------------------------------------------------
-- Vstupni stav
----------------------------------------------------------------
                    
-- |84| s_data_valid                    nula do platnych dat
-- |86| s_indexBitA                     nula do aktualniho indexu bitu
-- |93| s_StartBit_rx;                  do stavu start
-- |95| A_data = '0'                    aktualni hodnota signalu
-- |96| s_ClkCount <=0;                 reset clkcount
-----------------------------------------------------------------
    when s_idle => 
          s_data_valid<=  '0'; 
          s_ClkCount  <=   0;  
          s_indexBitA <=   0;  
                        
     if A_data = '0' then 
          r_SM_Main <= s_StartBit_rx; 
     else
           r_SM_Main <= s_idle; 
     end if;        
       when s_StartBit_rx =>
          if s_ClkCount = (Clk_per_bit-1)/2 then 
          if A_data = '0' then 
             s_ClkCount <=0; 
             r_SM_Main <= s_DataBits_rx; 
      else
             r_SM_Main <= s_idle;   
      end if;
             s_ClkCount <= s_ClkCount +1; 
             r_SM_Main <= s_StartBit_rx;                            
      end if;  
      when   s_DataBits_rx => 
      if s_ClkCount < Clk_per_bit-1 then 
             s_ClkCount <= s_ClkCount +1;
             r_SM_Main <= s_DataBits_rx; 
      else
             s_ClkCount <= 0;
             s_bytes(s_indexBitA) <= A_data;  
      if s_indexBitA<7 then 
             s_indexBitA <= s_indexBitA+1;
             r_SM_Main <=s_DataBits_rx;
      else
             s_indexBitA <=0;
             r_SM_Main <=s_StopBit_rx;
----------------------------------------------------------------------------
-- |101|s_ClkCount <= s_ClkCount +1;    inkrementace count
-- |110|s_bytes(s_indexBitA) <= A_data; ulozeni prijeteho bitu
-- |111|if s_indexBitA<7                zde kontroluju,zda jsem prijal vsechny bity
-- |124|s_data_valid <= '1';            oznacim si, ze znam nove data
-----------------------------------------------------------------------------
      end if;  
      end if;    
      when s_StopBit_rx => 
      if s_ClkCount < Clk_per_bit-1 then
               s_ClkCount <= s_ClkCOunt + 1;
               r_SM_Main <= s_StopBit_rx;
       else  
               s_data_valid <= '1'; 
               s_ClkCount <= 0;
               r_SM_Main <=s_clear;
      end if;
        when  s_clear =>
                r_SM_Main <= s_idle;
                s_data_valid <='0';
        when others =>
                 r_SM_Main <= s_idle;                                                    

                end case; 
            end if;
    end process;
rx_data_valid <=s_data_valid;
rx_dout<=s_bytes;    
end Behavioral;
