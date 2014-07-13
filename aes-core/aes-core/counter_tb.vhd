--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:29:38 07/13/2014
-- Design Name:   
-- Module Name:   /home/qfi/Documents/aeshw/aes-core/aes-core/counter_tb.vhd
-- Project Name:  aes-core
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: counter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY counter_tb IS
END counter_tb;
 
ARCHITECTURE behavior OF counter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT counter
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         y : IN  std_logic_vector(1 downto 0);
         d_out : OUT  std_logic_vector(7 downto 0);
			x : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal y : std_logic_vector(1 downto 0) := (others => '0');
	signal x : std_logic;

 	--Outputs
   signal d_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: counter PORT MAP (
          clk => clk,
          reset => reset,
          y => y,
          d_out => d_out,
			 x => x
        );

   -- Clock process definitions
   clk_process :process
   begin
		for i in 0 to 11 loop
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end loop;
		wait;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

      wait for clk_period;	
		
		-- load 0 into the register	
		y <= "00";

      wait for clk_period;
		assert d_out = x"00" report "counter : failure" severity failure;
		assert x = '0' report "counter : failure" severity failure;

		-- increment value
		y <= "01";
		
		for i in 1 to 9 loop
			wait for clk_period;
			assert d_out = std_logic_vector(to_unsigned(i, d_out'length)) report "counter : failure" severity failure;
			assert x = '0' report "counter : failure" severity failure;
		end loop;
		
		wait for clk_period;
		assert d_out = x"0A" report "counter : failure" severity failure;
		assert x = '1' report "counter : failure" severity failure;
		
      wait;
   end process;

END;
