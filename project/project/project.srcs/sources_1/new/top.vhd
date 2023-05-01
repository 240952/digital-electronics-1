library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_top is
    port (
        clk: in std_logic;
        rx: in std_logic;
        rx_en: in std_logic;
        tx: out std_logic;
        tx_en: in std_logic;
        data_in: in std_logic_vector(7 downto 0);
        data_out: out std_logic_vector(7 downto 0);
        rx_valid: out std_logic;
        tx_ready: out std_logic
    );
end entity uart_top;

architecture Behavioral of uart_top is

    component uart_receiver
        port (
            clk: in std_logic;
            rx: in std_logic;
            rx_en: in std_logic;
            data_out: out std_logic_vector(7 downto 0);
            valid: out std_logic
        );
    end component;

    component uart_transmitter
        port (
            clk: in std_logic;
            tx: out std_logic;
            tx_en: in std_logic;
            data_in: in std_logic_vector(7 downto 0);
            ready: out std_logic
        );
    end component;

    signal tx_ready_int: std_logic := '0';
    signal rx_valid_int: std_logic := '0';
    signal rx_data_int: std_logic_vector(7 downto 0) := (others => '0');

begin

    uart_rx: uart_receiver port map (
        clk => clk,
        rx => rx,
        rx_en => rx_en,
        data_out => rx_data_int,
        valid => rx_valid_int
    );

    uart_tx: uart_transmitter port map (
        clk => clk,
        tx => tx,
        tx_en => tx_en,
        data_in => data_in,
        ready => tx_ready_int
    );

    data_out <= rx_data_int;
    tx_ready <= tx_ready_int;
    rx_valid <= rx_valid_int;

end Behavioral;
