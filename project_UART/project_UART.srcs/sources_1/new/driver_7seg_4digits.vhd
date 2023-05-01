library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for display driver
--
--             +-------------------+
--        -----|> clk              |
--        -----| rst            dp |-----
--             |          seg(6:0) |--/--
--        --/--| data0(3:0)        |  7
--        --/--| data1(3:0)        |
--        --/--| data2(3:0)        |
--        --/--| data3(3:0)        |
--          4  |           dig(3:0)|--/--
--        --/--| dp_vect(3:0)      |  4
--          4  +-------------------+
--
-- Inputs:
--   clk          -- Main clock
--   rst          -- Synchronous reset
--   dataX(3:0)   -- Data values for individual digits
--   dp_vect(3:0) -- Decimal points for individual digits
--
-- Outputs:
--   dp:          -- Decimal point for specific digit
--   seg(6:0)     -- Cathode values for individual segments
--   dig(3:0)     -- Common anode signals to individual digits
--
----------------------------------------------------------

entity driver_7seg_4digits is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;
    data0   : in    std_logic_vector(3 downto 0);
    data1   : in    std_logic_vector(3 downto 0);
    data2   : in    std_logic_vector(3 downto 0);
    data3   : in    std_logic_vector(3 downto 0);
    dp_vect : in    std_logic_vector(3 downto 0);
    dp      : out   std_logic;
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(7 downto 0)
  );
end entity driver_7seg_4digits;

----------------------------------------------------------
-- Architecture declaration for display driver
----------------------------------------------------------

architecture behavioral of driver_7seg_4digits is

  -- Internal clock enable
  signal sig_en_4ms : std_logic;
  -- Internal 2-bit counter for multiplexing 4 digits
  signal sig_cnt_2bit : std_logic_vector(1 downto 0);
  -- Internal 4-bit value for 7-segment decoder
  signal sig_hex : std_logic_vector(3 downto 0);

begin

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity performs
  -- a 7-segment display decoder
  --------------------------------------------------------
  hex2seg : entity work.hex_7seg
    port map (
      blank => rst,
      hex   => sig_hex,
      seg   => seg
    );

  --------------------------------------------------------
  -- p_mux:
  -- Sekvenční proces, který implementuje multiplexer pro
  -- výběr dat pro jednu číslici, desetinnou čárku,
  -- a přepíná společné anody každého displeje.
  --------------------------------------------------------
  p_mux : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        sig_hex <= data0;
        dp      <= dp_vect(0);
        dig     <= "11111110";
      else

        case sig_cnt_2bit is

          when "11" =>
            sig_hex <= data3;
            dp      <= dp_vect(3);
            dig     <= "01111111";

          when "10" =>
            -- DEFINE ALL OUTPUTS FOR "10" HERE
            sig_hex <= data2;
            dp      <= dp_vect(2);
            dig     <= "10111111";

          when "01" =>
            -- DEFINE ALL OUTPUTS FOR "01" HERE
            sig_hex <= data1;
            dp      <= dp_vect(1);
            dig     <= "11111101";

          when others =>
            -- DEFINE ALL OUTPUTS FOR "00" HERE
            sig_hex <= data0;
            dp      <= dp_vect(0);
            dig     <= "11111110";

        end case;

      end if;
    end if;

  end process p_mux;

end architecture behavioral;
