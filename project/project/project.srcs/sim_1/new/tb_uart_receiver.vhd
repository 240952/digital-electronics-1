library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_receiver_tb is
end entity uart_receiver_tb;

architecture Behavioral of uart_receiver_tb is

    component uart_receiver
        port (
            clk: in std_logic;
            rx: in std_logic;
            rx_en: in std_logic;
            data_out: out std_logic_vector(7 downto 0);
            valid: out std_logic
        );
    end component;

    signal clk: std_logic := '0';
    signal rx: std_logic := '1';
    signal rx_en: std_logic := '0';
    signal data_out: std_logic_vector(7 downto 0);
    signal valid: std_logic := '0';

begin

    dut: uart_receiver port map (
        clk => clk,
        rx => rx,
        rx_en => rx_en,
        data_out => data_out,
        valid => valid
    );

    process
    begin
        wait for 10 ns;
        rx_en <= '1';
        wait for 10 ns;
        rx <= '0';
        wait for 10 ns;
        rx <= '1';
        wait until valid = '1';
        wait for 10 ns;
        assert data_out = x"55";
        wait;
    end process;

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

end Behavioral;
