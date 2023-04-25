library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_receiver is
    port (
        clk: in std_logic;
        rx: in std_logic;
        rx_en: in std_logic;
        data_out: out std_logic_vector(7 downto 0);
        valid: out std_logic
    );
end entity uart_receiver;

architecture Behavioral of uart_receiver is

    signal rx_data: std_logic_vector(9 downto 0) := (others => '0');
    signal rx_count: integer range 0 to 9 := 0;
    signal start_bit: std_logic := '0';
    signal data_ready: std_logic := '0';
-----
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rx_en = '1' then
                if rx = '0' then
                    if rx_count = 0 then
                        start_bit <= '1';
                    else
                        rx_data(rx_count-1) <= rx;
                    end if;
                    rx_count <= rx_count + 1;
                else
                    if rx_count = 9 then
                        data_ready <= '1';
                        rx_count <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

    data_out <= rx_data(7 downto 0);
    valid <= data_ready;

end Behavioral;
