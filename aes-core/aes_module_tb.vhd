--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:06:23 07/21/2014
-- Design Name:   
-- Module Name:   /home/qfi/Documents/aeshw/aes-core/aes-core/aes_module_tb.vhd
-- Project Name:  aes-core
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: aes_module
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
use work.types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY aes_module_tb IS
END aes_module_tb;
 
ARCHITECTURE behavior OF aes_module_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT aes_module
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         din : IN  std_logic_vector(127 downto 0);
         dout : OUT  std_logic_vector(127 downto 0);
         mode : IN  aes_mode;
         aes_start : IN  std_logic;
         aes_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal din : std_logic_vector(127 downto 0) := (others => '0');
   signal mode : aes_mode := ENCRYPT;
   signal aes_start : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(127 downto 0);
   signal aes_done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: aes_module PORT MAP (
          clk => clk,
          reset => reset,
          din => din,
          dout => dout,
          mode => mode,
          aes_start => aes_start,
          aes_done => aes_done
			 );

   -- Clock process definitions
   clk_process :process
   begin
		for i in 0 to 50 loop
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end loop;
   end process;
 

   stim_proc: process
   begin		
      
		-- key expansion
		mode <= EXPAND_KEY;
		din <= x"000102030405060708090a0b0c0d0e0f";
		aes_start <= '1';
		
      wait for clk_period;
		assert aes_done = '0' report "key expansion : wrong done signal" severity failure;
		wait for clk_period*11;
		assert aes_done = '0' report "key expansion : wrong done signal" severity failure;
		wait for clk_period;
		assert aes_done = '1' report "key expansion :  wrong done signal" severity failure;
		
		aes_start <= '0';
		wait for clk_period;
		assert aes_done = '1' report "key expansion : wrong done signal" severity failure;

		
		
		-- encryption (first time)
		mode <= ENCRYPT;
		din <= x"00112233445566778899aabbccddeeff";
		aes_start <= '1';
		
		wait for clk_period;
		assert aes_done = '0' report "encryption : wrong done signal" severity failure;
		wait for clk_period*12;
		assert aes_done = '0' report "encryption : wrong done signal" severity failure;
		wait for clk_period;
		assert aes_done = '1' report "encryption :  wrong done signal" severity failure;
		
		assert dout = x"69c4e0d86a7b0430d8cdb78070b4c55a" report "encryption : wrong result" severity failure;
		aes_start <= '0';
		
		
		
		-- idle (hold previous result)
		wait for clk_period*10;
		assert aes_done = '1' report "idle: failure" severity failure;
		assert dout = x"69c4e0d86a7b0430d8cdb78070b4c55a" report "idle: wrong result" severity failure;
		
		
		
		-- encryption (second time)
		mode <= ENCRYPT;
		din <= x"00112233445566778899aabbccddeeff";
		aes_start <= '1';
		
		wait for clk_period;
		assert aes_done = '0' report "encryption : wrong done signal" severity failure;
		wait for clk_period*12;
		assert aes_done = '0' report "encryption : wrong done signal" severity failure;
		wait for clk_period;
		assert aes_done = '1' report "encryption : wrong done signal" severity failure;
		
		assert dout = x"69c4e0d86a7b0430d8cdb78070b4c55a" report "encryption module: wrong result" severity failure;
		aes_start <= '0';
		
		
		
		-- decryption (first time)
		mode <= DECRYPT;
		din <= x"69c4e0d86a7b0430d8cdb78070b4c55a";
		aes_start <= '1';
		
		wait for clk_period;
		assert aes_done = '0' report "decryption : wrong done signal" severity failure;
		wait for clk_period*12;
		assert aes_done = '0' report "decryption : wrong done signal" severity failure;
		wait for clk_period;
		assert aes_done = '1' report "decryption : wrong done signal" severity failure;
		
		assert dout = x"00112233445566778899aabbccddeeff" report "decryption : wrong result" severity failure;
		aes_start <= '0';
		
		
      wait;
   end process;

END;
