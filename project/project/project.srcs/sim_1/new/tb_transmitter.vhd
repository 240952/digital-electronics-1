----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 12:07:33 PM
-- Design Name: 
-- Module Name: tb_transmitter - Behavioral
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

entity tb_transmitter is
    Port ( sig_A0 : in STD_LOGIC;
           sig_A1 : in STD_LOGIC;
           sig_A2 : in STD_LOGIC;
           sig_A3 : in STD_LOGIC;
           sig_A4 : in STD_LOGIC;
           sig_A5 : in STD_LOGIC;
           sig_A6 : in STD_LOGIC;
           sig_A7 : in STD_LOGIC;
           sig_S1 : out STD_LOGIC;
           sig_clk : in STD_LOGIC);
end tb_transmitter;

architecture Behavioral of tb_transmitter is

begin
    uut_Behavioral : entity work.transmitter
    Port map(
        A0_i => sig_A0,
        A1_i => sig_A1,
        A2_i => sig_A2,
        A3_i => sig_A3,
        A4_i => sig_A4,
        A5_i => sig_A5,
        A6_i => sig_A6,
        A7_i => sig_A7,
        S1_o => sig_S1,
        clk  => sig_clk
        );
        
 -----------------------------------------
--Clock generation process
-----------------------------------------
 p_clk_gen : process is
  begin

    while now < 1000 ns loop             

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;                              

  end process p_clk_gen;


-----------------------------------------
 --Reset generation process
----------------------------------------
 p_reset_gen : process is
  begin

	sig_rst <= '0';
	wait for 60 ns;
    sig_rst <= '1';
    wait for 50 ns;
    sig_rst <= '0';
    

 wait;

 end process p_reset_gen;
  --------------------------------------------------------
  --Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";
	
	
    sig_btn_send <= '0';
    wait for 20 ns;
    sig_data_in <= "10101001";
    wait for 10 ns;
	sig_btn_send <= '1';
    wait for 20 ns;
	sig_btn_send <= '0';
    
    wait for 100 ns;
    sig_data_in <= "10101110";
    wait for 57 ns;
	sig_btn_send <= '1';
    wait for 20 ns;
	sig_btn_send <= '0';
    
    wait for 400 ns;
    sig_data_in <= "01000100";
    wait for 3 ns;
	sig_btn_send <= '1';
    wait for 15 ns;
	sig_btn_send <= '0';


      


    report "Stimulus process finished";
    wait;

  end process p_stimulus;


end architecture testbench;