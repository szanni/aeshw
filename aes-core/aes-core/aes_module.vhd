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
    port ( clk :      in  std_logic;
			  reset :    in  std_logic;
			  din :      in  state; -- 128 bit key or plaintext/cyphertext block
           dout :     out state; -- 128 bit plaintext/cyphertext block
           ctrl_in :  in  byte; 
           ctrl_out : in  byte
			 );
end aes_module;

architecture Behavioral of aes_module is
 type aes_mode is (ENCRYPT, DECRYPT, EXPAND_KEY);
 attribute enum_encoding of aes_mode : type is "00 01 10";
 signal rkey : state;
 signal rkey_addr, rkey_addr_enc, rkey_addr_dec : std_logic_vector(3 downto 0);
 signal dout_enc, dout_dec : state;
 signal start_enc, start_dec, start_exp : std_logic;
 signal end_enc, end_dec, end_exp : std_logic;
begin
	
	
	dout_mux : process()
	begin
		case data_in_ctrl is 
			when ENCRYPT => dout <= dout_enc;
			when DECRYPT => dout <= dout_dec;
			when others => null;
		end case;
	end process dout;
	
	rkey_addr_mux : process(rkey_addr_enc, rkey_addr_dec)
	begin
		case data_in_ctrl is 
			when ENCRYPT => rkey_addr <= rkey_addr_enc;
			when DECRYPT => rkey_addr <= rkey_addr_dec;
			when others => null;
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

end Behavioral;

