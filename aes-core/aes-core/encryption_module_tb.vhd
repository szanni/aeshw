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
	for i in 0 to 15 loop
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end loop;
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
		assert dout = x"89d810e8855ace682d1843d8cb128fe4" report "encryption : wrong result in round 1" severity failure; 
		assert addr_rkey = x"3" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 2 finished
		rkey_in <= x"b6ff744ed2c2c9bf6c590cbf0469bf41"; -- round key 3 now available 
		assert dout = x"4915598f55e5d7a0daca94fa1f0a63f7" report "encryption : wrong result in round 2" severity failure; 
		assert addr_rkey = x"4" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 3 finished
		rkey_in <= x"47f7f7bc95353e03f96c32bcfd058dfd"; -- round key 4 now available 
		assert dout = x"fa636a2825b339c940668a3157244d17" report "encryption : wrong result in round 3" severity failure; 
		assert addr_rkey = x"5" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 4 finished
		rkey_in <= x"3caaa3e8a99f9deb50f3af57adf622aa"; -- round key 5 now available 
		assert dout = x"247240236966b3fa6ed2753288425b6c" report "encryption : wrong result in round 4" severity failure; 
		assert addr_rkey = x"6" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 5 finished
		rkey_in <= x"5e390f7df7a69296a7553dc10aa31f6b"; -- round key 6 now available 
		assert dout = x"c81677bc9b7ac93b25027992b0261996" report "encryption : wrong result in round 5" severity failure;
		assert addr_rkey = x"7" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 6 finished 
		rkey_in <= x"14f9701ae35fe28c440adf4d4ea9c026"; -- round key 7 now available 
		assert dout = x"c62fe109f75eedc3cc79395d84f9cf5d" report "encryption : wrong result in round 6" severity failure; 
		assert addr_rkey = x"8" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 7 finished
		rkey_in <= x"47438735a41c65b9e016baf4aebf7ad2"; -- round key 8 now available 
		assert dout = x"d1876c0f79c4300ab45594add66ff41f" report "encryption : wrong result in round 7" severity failure; 
		assert addr_rkey = x"9" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 8 finished
		rkey_in <= x"549932d1f08557681093ed9cbe2c974e"; -- round key 9 now available 
		assert dout = x"fde3bad205e5d0d73547964ef1fe37f1" report "encryption : wrong result in round 8" severity failure; 
		assert addr_rkey = x"A" report "encryption : wrong round key address" severity failure;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 9 finished
		rkey_in <= x"13111d7fe3944a17f307a78b4d2b30c5"; -- round key 10 now available 
		assert dout = x"bd6e7c3df2b5779e0b61216e8b10b689" report "encryption : wrong result in round 9" severity failure; 
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- not yet finished
		
		wait for clk_period;
		
		-- round 10 finished
		assert dout = x"69c4e0d86a7b0430d8cdb78070b4c55a" report "encryption : wrong result in round 10" severity failure; 
		assert enc_end = '1' report "encryption : wrong end signal" severity failure; -- finished
		
		wait for clk_period;
		assert enc_end = '0' report "encryption : wrong end signal" severity failure; -- ready
		
		wait;
   end process;

END;
