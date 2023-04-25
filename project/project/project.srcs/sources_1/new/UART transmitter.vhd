library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_transmitter is
    port (
        clk: in std_logic;
        tx: out std_logic;
        tx_en: in std_logic;
        data_in: in std_logic_vector(7 downto 0);
        ready: out std_logic
    );
end entity uart_transmitter;

architecture Behavioral of uart_transmitter is

    signal tx_data: std_logic_vector(9 downto 0) := (others => '0');
    signal tx_count: integer range 0 to 9 := 0;
    signal start_bit: std_logic := '0';
    signal data_ready: std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if tx_en = '1' then
                if tx_count = 0 then
                    tx <= '0';
                    start_bit <= '1';
                    tx_data <= data_in & '0';
                    tx_count <= 10;
                else
                    tx <= tx_data(tx_count-1);
                    tx_count <= tx_count - 1;
                    if tx_count = 0 then
                        ready <= '1';
                    else
                        ready <= '0';
                    end if;
                end if;
            else
                tx <= '1';
                ready <= '0';
                tx_data <= (others => '0');
                tx_count <= 0;
            end if;
        end if;
    end process;

end Behavioral;
