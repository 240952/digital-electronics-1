library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_transmitter_tb is
end entity uart_transmitter_tb;

architecture Behavioral of uart_transmitter_tb is

    component uart_transmitter
        port (
            clk: in std_logic;
            tx: out std_logic;
            tx_en: in std_logic;
            data_in: in std_logic_vector(7 downto 0);
            ready: out std_logic
        );
    end component;

    signal clk: std_logic := '0';
    signal tx: std_logic;
    signal tx_en: std_logic := '0';
    signal data_in: std_logic_vector(7 downto 0) := x"55";
    signal ready: std_logic := '0';

begin

    dut: uart_transmitter port map (
        clk => clk,
        tx => tx,
        tx_en => tx_en,
        data_in => data_in,
        ready => ready
    );

    process
    begin
        wait for 10 ns;
        tx_en <= '1';
        wait until ready = '1';
        wait for 5 ns;
        assert tx = '0';
        wait for 5 ns;
        for i in 0 to 7 loop
            assert tx = data_in(i);
            wait for 5 ns;
        end loop;
        assert tx = '1' ;
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
