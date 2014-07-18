--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:53:00 07/17/2014
-- Design Name:   
-- Module Name:   /home/qfi/Documents/aeshw/aes-core/aes-core/encryption_module_tb.vhd
-- Project Name:  aes-core
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: encryption_module
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
 
ENTITY encryption_module_tb IS
END encryption_module_tb;
 
ARCHITECTURE behavior OF encryption_module_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT encryption_module
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         enc_start : IN  std_logic;
         enc_end : OUT  std_logic;
         din : IN  std_logic_vector(127 downto 0);
         dout : OUT  std_logic_vector(127 downto 0);
         addr_rkey : OUT  std_logic_vector(3 downto 0);
         rkey_in : IN  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal enc_start : std_logic := '0';
   signal din : std_logic_vector(127 downto 0) := (others => '0');
   signal rkey_in : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal enc_end : std_logic;
   signal dout : std_logic_vector(127 downto 0);
   signal addr_rkey : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: encryption_module PORT MAP (
          clk => clk,
          reset => reset,
          enc_start => enc_start,
          enc_end => enc_end,
          din => din,
          dout => dout,
          addr_rkey => addr_rkey,
          rkey_in => rkey_in
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
		
		enc_start <= '1';
		din <= x"00112233445566778899aabbccddeeff"; -- plaintext
		wait for clk_period;
		
		assert addr_rkey = x"0" report "encryption : wrong round key address" severity failure; -- counter initialized
		
		wait for clk_period;
		
		assert addr_rkey = x"1" report "encryption : wrong round key address" severity failure;
		rkey_in <= x"000102030405060708090a0b0c0d0e0f"; -- round 0 now available (one cycle after round key address "0" due to synchronous read)
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- pre round finished
		rkey_in <= x"d6aa74fdd2af72fadaa678f1d6ab76fe"; -- round key 1 now available 
		assert dout = x"00102030405060708090a0b0c0d0e0f0" report "encryption : wrong result in round 0" severity failure; -- pre round finished
		assert addr_rkey = x"2" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 1 finished
		rkey_in <= x"b692cf0b643dbdf1be9bc5006830b3fe"; -- round key 2 now available 
		assert dout = x"89d810e8855ace682d1843d8cb128fe4" report "encryption : wrong result in round 1" severity failure; -- pre round finished
		assert addr_rkey = x"3" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		-- round 2 finished
		
		wait;
   end process;

END;
