----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:04:20 07/16/2014 
-- Design Name: 
-- Module Name:    encryption_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use work.types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encryption_module is
	port(
		clk       : in  std_logic;
      reset     : in  std_logic;
		enc_start : in  std_logic;
		enc_end   : out std_logic;
		din       : in  state;
		dout      : out state;
		addr_rkey : out std_logic_vector (3 downto 0);
		rkey_in   : in  state
	);
end encryption_module;

architecture Behavioral of encryption_module is
signal x_last_round : std_logic;
signal y_1_2, y_3_4 : std_logic_vector (1 downto 0);
signal addr_rkey_tmp : byte; 
 

begin

 control_unit : entity work.cipher_cu port map (clk => clk,    
																reset => reset,  
																x_start => enc_start, 
																x_comp => x_last_round,  
																y_1_2  => y_1_2, 
																y_3_4  => y_3_4, 
																y_end => enc_end 
																);
 
 cipher_unit : entity work.cipher port map (clk => clk,     
														  reset => reset,    
														  y => y_1_2,															  
														  din => din,    
														  rkey_in => rkey_in,
														  dout => dout      
														  );
 
 counter : entity work.counter port map (clk => clk,   
													  reset => reset,
													  y => y_3_4,     
													  d_out => addr_rkey_tmp, 
													  x => x_last_round    
													  );
 
 addr_rkey <= addr_rkey_tmp(3 downto 0);
 
end Behavioral;

