library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;   

------------------------------------------------------------------------
-- Entity deklarace pro clock enable
------------------------------------------------------------------------
entity clock_enable is

port (
    Num_clkPer	    : in std_logic_vector(16-1 downto 0);--pocet cyklu pred vytvorenim pulsu
    Clk             : in  std_logic;--hodinovy signal
    RESET           : in  std_logic;-- reset                                      
    ce              : out std_logic--vystupni signal
   
);
end entity clock_enable;

------------------------------------------------------------------------
-- Deklarace architektury pro povolení clock
------------------------------------------------------------------------
architecture Behavioral of clock_enable is
    signal s_Num_cnt : std_logic_vector(16-1 downto 0) := x"0000"; --signal pro pocitani cyklu
begin

    --------------------------------------------------------------------
    -- p_clk_enable:
    -- Vygenerujte signál povolení hodin namísto vytváření dalších hodin
    -- doména. Ve výchozím nastavení je signál povolení nízký a generovaný pulz je
    -- vždy jednu hodinu dlouhé.
    --------------------------------------------------------------------
    p_clk_enable : process(Clk)
    begin
        if Clk'event and Clk ='1' then                                 
            if RESET = '0' then                                          
                s_Num_cnt <= (others => '0');--vynuluje vsechny bity                               
                ce <= '0';-- vystupni signal ma 0
            else
                if s_Num_cnt >= Num_clkPer-1 then
                    s_Num_cnt <= (others => '0');
                    ce <= '1';
                else
                    s_Num_cnt <= s_Num_cnt + x"0001";--inkrementace citace
                    ce <= '0';
                end if;
            end if;
        end if;
    end process p_clk_enable;

end architecture Behavioral;
