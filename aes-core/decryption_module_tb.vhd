--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:50:28 07/21/2014
-- Design Name:   
-- Module Name:   /home/qfi/Documents/aeshw/aes-core/aes-core/decryption_module_tb.vhd
-- Project Name:  aes-core
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decryption_module
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
 
ENTITY decryption_module_tb IS
END decryption_module_tb;
 
ARCHITECTURE behavior OF decryption_module_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decryption_module
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         dec_start : IN  std_logic;
         dec_end : OUT  std_logic;
         din : IN  std_logic_vector(127 downto 0);
         dout : OUT  std_logic_vector(127 downto 0);
         addr_rkey : OUT  std_logic_vector(3 downto 0);
         rkey_in : IN  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal dec_start : std_logic := '0';
   signal din : std_logic_vector(127 downto 0) := (others => '0');
   signal rkey_in : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal dec_end : std_logic;
   signal dout : std_logic_vector(127 downto 0);
   signal addr_rkey : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decryption_module PORT MAP (
          clk => clk,
          reset => reset,
          dec_start => dec_start,
          dec_end => dec_end,
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
		
		dec_start <= '1';
		din <= x"69c4e0d86a7b0430d8cdb78070b4c55a"; -- plaintext
		wait for clk_period;
		
		assert addr_rkey = x"A" report "decryption : wrong round key address" severity failure; -- counter initialized
		
		wait for clk_period;
		
		assert addr_rkey = x"9" report "decryption : wrong round key address" severity failure;
		rkey_in <= x"13111d7fe3944a17f307a78b4d2b30c5"; -- round key 0 now available (one cycle after round key address "A" due to synchronous read)
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- pre round finished
		rkey_in <= x"549932d1f08557681093ed9cbe2c974e"; -- round key 1 now available 
		assert dout = x"7ad5fda789ef4e272bca100b3d9ff59f" report "decryption : wrong result in round 0" severity failure; -- pre round finished
		assert addr_rkey = x"8" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 1 finished
		rkey_in <= x"47438735a41c65b9e016baf4aebf7ad2"; -- round key 2 now available 
		assert dout = x"54d990a16ba09ab596bbf40ea111702f" report "decryption : wrong result in round 1" severity failure; 
		assert addr_rkey = x"7" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 2 finished
		rkey_in <= x"14f9701ae35fe28c440adf4d4ea9c026"; -- round key 3 now available 
		assert dout = x"3e1c22c0b6fcbf768da85067f6170495" report "decryption : wrong result in round 2" severity failure; 
		assert addr_rkey = x"6" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 3 finished
		rkey_in <= x"5e390f7df7a69296a7553dc10aa31f6b"; -- round key 4 now available 
		assert dout = x"b458124c68b68a014b99f82e5f15554c" report "decryption : wrong result in round 3" severity failure; 
		assert addr_rkey = x"5" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 4 finished
		rkey_in <= x"3caaa3e8a99f9deb50f3af57adf622aa"; -- round key 5 now available 
		assert dout = x"e8dab6901477d4653ff7f5e2e747dd4f" report "decryption : wrong result in round 4" severity failure; 
		assert addr_rkey = x"4" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 5 finished
		rkey_in <= x"47f7f7bc95353e03f96c32bcfd058dfd"; -- round key 6 now available 
		assert dout = x"36339d50f9b539269f2c092dc4406d23" report "decryption : wrong result in round 5" severity failure;
		assert addr_rkey = x"3" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 6 finished 
		rkey_in <= x"b6ff744ed2c2c9bf6c590cbf0469bf41"; -- round key 7 now available 
		assert dout = x"2d6d7ef03f33e334093602dd5bfb12c7" report "decryption : wrong result in round 6" severity failure; 
		assert addr_rkey = x"2" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 7 finished
		rkey_in <= x"b692cf0b643dbdf1be9bc5006830b3fe"; -- round key 8 now available 
		assert dout = x"3bd92268fc74fb735767cbe0c0590e2d" report "decryption : wrong result in round 7" severity failure; 
		assert addr_rkey = x"1" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 8 finished
		rkey_in <= x"d6aa74fdd2af72fadaa678f1d6ab76fe"; -- round key 9 now available 
		assert dout = x"a7be1a6997ad739bd8c9ca451f618b61" report "decryption : wrong result in round 8" severity failure; 
		assert addr_rkey = x"0" report "decryption : wrong round key address" severity failure;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 9 finished
		rkey_in <= x"000102030405060708090a0b0c0d0e0f"; -- round key 10 now available 
		assert dout = x"6353e08c0960e104cd70b751bacad0e7" report "decryption : wrong result in round 9" severity failure; 
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 10 finished
		assert dout = x"00112233445566778899aabbccddeeff" report "decryption : wrong result in round 10" severity failure; 
		assert dec_end = '1' report "decryption : wrong end signal" severity failure; -- finished
		
		wait for clk_period;
		assert dec_end = '0' report "decryption : wrong end signal" severity failure; -- ready

      wait;
   end process;

END;
