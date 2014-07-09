--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:11:17 07/07/2014
-- Design Name:   
-- Module Name:   /home/qfi/Documents/aeshw/aes-core/aes-core/key_expander_tb.vhd
-- Project Name:  aes-core
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: key_expander
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
library ieee;
use ieee.std_logic_1164.all;
use work.types.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity key_expander_tb is
end key_expander_tb;
 
architecture behavior of key_expander_tb is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component key_expander
    port(
         clk : in  std_logic;
         reset : in  std_logic;
			x : in std_logic_vector(1 downto 0);
         rcon_in : in  byte;
         key_in : in  state;
         key_out : out  state
        );
    end component;
    
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal x : std_logic_vector(1 downto 0) := "00";
   signal rcon_in : byte := (others => '0');
  
	signal key_in : state;

	--Outputs
	signal key_out : state;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: key_expander port map (
          clk => clk,
          reset => reset,
			 x => x,
          rcon_in => rcon_in,
          key_in => key_in,
          key_out => key_out
        );

   -- clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- stimulus process
   stim_proc: process
   begin
      -- load initial key into the registers
		x <= "00"; -- load new key	
		key_in <= x"2b7e151628aed2a6abf7158809cf4f3c";
		
		wait for 10 ns;
		-- key loaded
		x <= "01"; -- feed register with previous values passed through expansion-SN

		-- round 1
		rcon_in <= x"01";			
		wait for 10 ns;
		assert key_out = x"a0fafe1788542cb123a339392a6c7605" report "key expension round(1) : failure" severity failure;
		
		-- round 2 (use key_out of round 1)
		rcon_in <= x"02";
		wait for 10 ns;
		assert key_out = x"f2c295f27a96b9435935807a7359f67f" report "key expension round(2) : failure" severity failure;
      wait;
	
   end process;

end;
