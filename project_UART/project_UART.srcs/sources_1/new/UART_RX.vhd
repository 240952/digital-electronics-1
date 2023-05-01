library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver is
    generic(
        Clk_per_bit   :     integer := 650
    );
    port(
        Clk           :     in  std_logic;    -- Vstupní hodinový signál
        rx_serial     :     in  std_logic;    -- Vstupní sériový datový signál
        rx_data_valid :     out std_logic;    -- Výstupní indikátor platného datového signálu
        rx_dout       :     out std_logic_vector(7 downto 0) -- Výstupní osmibitový datový signál
    );    
    end receiver;

architecture Behavioral of receiver is
-- Definice stavového automatu  pro p?íjem UART signálu
type t_SM_Main is (s_idle, s_StartBit_rx, s_DataBits_rx,
                     s_StopBit_rx, s_clear);  
  signal r_SM_Main : t_SM_Main := s_idle;
 
  -- Pomocné signály pro p?íjem dat
  signal H_data   : std_logic := '0';  -- Pomocný registr pro p?ijatá data
  signal A_data   : std_logic := '0';  -- Aktuální bit dat p?ijatých z UART
 
  -- Signály pro ?ízení p?ijetí dat
  signal s_ClkCount     :   integer range 0 to Clk_per_bit-1 := 0;  -- Po?ítadlo hodinových cykl?
  signal s_indexBitA    :   integer range 0 to 7 := 0;  -- Index aktuáln? p?ijatého bitu (z 8)
  signal s_bytes        :   std_logic_vector(7 downto 0) := (others => '0');  -- P?ijatý byte (8 bit?)
  signal s_data_valid           :   std_logic := '0';  -- Indikátor platnosti p?ijatého bytu
begin
    --Vzorkovani serieoveho vstupu
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
                end case; 
            end if;
    end process;
rx_data_valid <=s_data_valid;
rx_dout<=s_bytes;    
end Behavioral;