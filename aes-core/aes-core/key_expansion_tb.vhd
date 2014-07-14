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
		
		exp_start <= '0';
		
		-- wait until expansion is finished
		for i in 1 to 11 loop
			assert exp_end = '0' report "key expansion module: failure" severity failure;
			wait for clk_period;
		end loop;
		
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


      wait;
   end process;

END;
