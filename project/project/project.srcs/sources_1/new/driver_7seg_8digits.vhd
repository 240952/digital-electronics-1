----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2023 11:28:18 AM
-- Design Name: 
-- Module Name: driver_7seg_8digits - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity driver_7seg_8digits is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           d1 : in STD_LOGIC;
           d2 : in STD_LOGIC;
           seg : out STD_LOGIC;
           dig : out STD_LOGIC);
           
end entity driver_7seg_8digits;

----------------------------------------------------------
-- Architecture declaration for display driver
----------------------------------------------------------

architecture behavioral of driver_7seg_2digits is

  -- Internal clock enable
  signal sig_en_4ms : std_logic;
  -- Internal 3-bit counter for multiplexing 4 digits
  signal sig_cnt_1bit : std_logic;
  -- Internal 4-bit value for 7-segment decoder
  signal sig_hex : std_logic_vector(3 downto 0);

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 4 ms
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
    generic map (
      -- FOR SIMULATION, KEEP THIS VALUE TO 2
      -- FOR IMPLEMENTATION, CHANGE THIS VALUE TO 200,000
      -- 2      @ 2 ns
      -- 200000 @ 2 ms
      g_max => 800000
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en_4ms
    );

  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity performs
  -- a 2-bit down counter
  --------------------------------------------------------
  bin_cnt0 : entity work.cnt_up_down
    port map (
      clk => clk,
      rst => rst,
      en => sig_en_4ms,
      cnt_up => '0',
      cnt => sig_cnt_1bit
    );

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
  -- A sequential process that implements a multiplexer for
  -- selecting data for a single digit, a decimal point,
  -- and switches the common anodes of each display.
  --------------------------------------------------------
  p_mux : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        sig_hex <= data0;
        dig     <= "10";
      else

        case sig_cnt_1bit is
            
          when '1' =>
            sig_hex <= data1;
            dig     <= "01";
            
          when others =>
            sig_hex <= data0;
            dig     <= "10";
            
        end case;

      end if;
    end if;

  end process p_mux;

end architecture behavioral;
