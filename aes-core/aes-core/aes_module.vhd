----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:10 07/21/2014 
-- Design Name: 
-- Module Name:    aes_module - Behavioral 
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

entity aes_module is
    port ( clk       : in     std_logic;
			  reset     : in     std_logic;
			  din       : in     state; -- 128 bit key or plaintext/cyphertext block
           dout      : out    state; -- 128 bit plaintext/cyphertext block
			  mode      : in     aes_mode;
           aes_start : in     std_logic;
			  aes_done  : out    std_logic
			 );
end aes_module;

architecture Behavioral of aes_module is

 signal rkey : state;
 signal rkey_addr, rkey_addr_enc, rkey_addr_dec : std_logic_vector(3 downto 0);
 signal dout_enc, dout_dec : state;
 signal start_enc, start_dec, start_exp : std_logic;
 signal end_enc, end_dec, end_exp : std_logic;
 signal mux_ctrl : aes_mode;
 signal aes_result : state;

begin
	dout <= aes_result;
	
	dout_mux : process(mux_ctrl, aes_result, dout_enc, dout_dec)
	begin
		case mux_ctrl is 
			when ENCRYPT => aes_result <= dout_enc;
			when DECRYPT => aes_result <= dout_dec;
			when others  => aes_result  <= aes_result;
		end case;
	end process dout_mux;
	
	rkey_addr_mux : process(mux_ctrl, rkey_addr_enc, rkey_addr_dec)
	begin
		case mux_ctrl is 
			when ENCRYPT => rkey_addr <= rkey_addr_enc;
			when others  => rkey_addr <= rkey_addr_dec;
		end case;
	end process rkey_addr_mux;
	
	encryption_module: entity work.encryption_module port map (clk => clk,    
																				  reset => reset,    
																				  enc_start => start_enc,
																				  enc_end => end_enc,
																				  din => din,    
																				  dout => dout_enc,
																				  addr_rkey => rkey_addr_enc,
																				  rkey_in => rkey
																				);
	
	decryption_module: entity work.decryption_module port map (clk => clk, 
																				  reset => reset,
																				  dec_start => start_dec,
																				  dec_end => end_dec,
																				  din => din,
																				  dout => dout_dec,
																				  addr_rkey => rkey_addr_dec,
																				  rkey_in => rkey
																				  );
	
	key_expansion: entity work.key_expansion port map (clk => clk,
																		reset => reset,
																		exp_start => start_exp,
																		exp_end => end_exp,
																		address_in => rkey_addr,
																		key_in => din,
																		key_out => rkey
																	  );
	
	control_unit: entity work.aes_module_cu port map(clk => clk,
																	 reset => reset,
																	 x_start => aes_start,
																	 x_mode => mode,
																	 x_end_enc => end_enc,
																	 x_end_dec => end_dec,
																	 x_end_exp => end_exp,
																	 y_done => aes_done,      
																	 y_start_enc => start_enc,
																	 y_start_dec => start_dec,
																	 y_start_exp => start_exp,
																	 y_mux_ctrl => mux_ctrl
																	 );
																	 
end Behavioral;

