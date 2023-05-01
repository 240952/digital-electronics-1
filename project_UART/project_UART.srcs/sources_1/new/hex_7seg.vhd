library ieee;
use ieee.std_logic_1164.all;


entity hex_7seg is
  port (
    blank : in    std_logic;                    --! Display is clear if blank = 1
    hex   : in    std_logic_vector(3 downto 0); --! Binary representation of one hexadecimal symbol
    seg   : out   std_logic_vector(6 downto 0)  --! Seven active-low segments in the order: a, b, ..., g
  );
end entity hex_7seg;

------------------------------------------------------------
-- Architecture body for seven-segment display decoder
------------------------------------------------------------

architecture behavioral of hex_7seg is

begin

  --------------------------------------------------------
  -- p_7seg_decoder:
  -- A combinational process for 7-segment display (Common
  -- Anode) decoder. Any time "hex" or "blank" is changed,
  -- the process is "executed". Output pin seg(6) controls
  -- segment A, seg(5) segment B, etc.
  --     segment A
  --      | segment B
  --      |  | segment C
  --      +-+|  |   ...   segment G
  --        ||+-+          |
  --        |||            |
  -- seg = "0000001"-------+
  --
  -- Display is clear/blank if signal blank = 1.
  --------------------------------------------------------

  p_7seg_decoder : process (blank, hex) is

  begin

    if (blank = '1') then
      seg <= "1111111";     -- Blanking display
    else

      case hex is

        when "0000" =>

          seg <= "0000001"; -- 0

        when "0001" =>

          seg <= "1001111"; -- 1

        -- WRITE YOUR CODE HERE
        -- 2, 3, 4, 5, 6, 7
        when "0010" =>

          seg <= "0010010"; -- 2

        when "0011" =>

          seg <= "0000110"; -- 3

        when "0100" =>

          seg <= "1001100"; -- 4

        when "0101" =>

          seg <= "0100100"; -- 5

        when "0110" =>

          seg <= "0100000"; -- 6

        when "0111" =>

          seg <= "0001111"; -- 7

        when "1000" =>

          seg <= "0000000"; -- 8

        -- WRITE YOUR CODE HERE
        -- 9, A, b, C, d
        when "1001" =>

          seg <= "0000100"; -- 9

        when "1010" =>

          seg <= "0001000"; -- A (10)

        when "1011" =>

          seg <= "1100000"; -- b (11)

        when "1100" =>

          seg <= "0110001"; -- C (12)

        when "1101" =>

          seg <= "1000010"; -- d (13)

        when "1110" =>

          seg <= "0110000"; -- E

        when others =>

          seg <= "0111000"; -- F

      end case;

    end if;

  end process p_7seg_decoder;

end architecture behavioral;