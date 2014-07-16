--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:02:57 07/14/2014
-- Design Name:   
-- Module Name:   /home/qfi/Documents/aeshw/aes-core/aes-core/key_expansion_tb.vhd
-- Project Name:  aes-core
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: key_expansion
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY key_expansion_tb IS
END key_expansion_tb;
 
ARCHITECTURE behavior OF key_expansion_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT key_expansion
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         exp_start : IN  std_logic;
         exp_end : OUT  std_logic;
         address_in : IN  std_logic_vector(3 downto 0);
         key_in : IN  std_logic_vector(127 downto 0);
         key_out : OUT  std_logic_vector(127 downto 0)
		);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal exp_start : std_logic := '0';
   signal address_in : std_logic_vector(3 downto 0) := (others => '0');
   signal key_in : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal exp_end : std_logic;
   signal key_out : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: key_expansion PORT MAP (
          clk => clk,
          reset => reset,
          exp_start => exp_start,
          exp_end => exp_end,
          address_in => address_in,
          key_in => key_in,
          key_out => key_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
		wait for clk_period;	
		
		exp_start <= '1';
		key_in <= x"2b7e151628aed2a6abf7158809cf4f3c";
		
		wait for clk_period;
		assert exp_end = '0' report "key expansion module: failure" severity failure;
		-- expander and counter now initialized

		exp_start <= '0';
		
		-- wait until expansion is finished
		for i in 1 to 10 loop
			wait for clk_period;
			assert exp_end = '0' report "key expansion module: failure" severity failure;
		end loop;
		
		
		wait for clk_period;
		-- expansion should now be finished
		assert exp_end = '1' report "key expansion module: failure" severity failure;
		wait for clk_period;
		
		-- expansion is ready again
		assert exp_end = '0' report "key expansion module: failure" severity failure;
		
		wait for clk_period*10;
		
		-- lookup ram values
		address_in <= x"0";
		wait for clk_period;
		assert key_out = x"2b7e151628aed2a6abf7158809cf4f3c" report "ram module : lookup failure (address 0)" severity failure;
		
		address_in <= x"1";
		wait for clk_period;
		assert key_out = x"a0fafe1788542cb123a339392a6c7605" report "ram module : lookup failure (address 1)" severity failure;
		
		address_in <= x"2";
		wait for clk_period;
		assert key_out = x"f2c295f27a96b9435935807a7359f67f" report "ram module : lookup failure (address 2)" severity failure;

		address_in <= x"3";
		wait for clk_period;
		assert key_out = x"3d80477d4716fe3e1e237e446d7a883b" report "ram module : lookup failure (address 3)" severity failure;
		
		address_in <= x"4";
		wait for clk_period;
		assert key_out = x"ef44a541a8525b7fb671253bdb0bad00" report "ram module : lookup failure (address 4)" severity failure;
		
		address_in <= x"5";
		wait for clk_period;
		assert key_out = x"d4d1c6f87c839d87caf2b8bc11f915bc" report "ram module : lookup failure (address 5)" severity failure;
		
		address_in <= x"6";
		wait for clk_period;
		assert key_out = x"6d88a37a110b3efddbf98641ca0093fd" report "ram module : lookup failure (address 6)" severity failure;
		
		address_in <= x"7";
		wait for clk_period;
		assert key_out = x"4e54f70e5f5fc9f384a64fb24ea6dc4f" report "ram module : lookup failure (address 7)" severity failure;
		
		address_in <= x"8";
		wait for clk_period;
		assert key_out = x"ead27321b58dbad2312bf5607f8d292f" report "ram module : lookup failure (address 8)" severity failure;
		
		address_in <= x"9";
		wait for clk_period;
		assert key_out = x"ac7766f319fadc2128d12941575c006e" report "ram module : lookup failure (address 9)" severity failure;
		
		address_in <= x"A";
		wait for clk_period;
		assert key_out = x"d014f9a8c9ee2589e13f0cc8b6630ca6" report "ram module : lookup failure (address A)" severity failure;
				
      wait;
   end process;

END;
