----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:40:13 07/21/2014 
-- Design Name: 
-- Module Name:    aes_module_cu - Behavioral 
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

entity aes_module_cu is
	port (clk         : in  std_logic;
			reset       : in  std_logic;
			x_start     : in  std_logic;
			x_mode      : in  aes_mode;
			x_end_enc   : in  std_logic;
			x_end_dec   : in  std_logic;
			x_end_exp   : in  std_logic;
		   y_end       : out std_logic;
			y_done      : out std_logic;
			y_start_enc : out std_logic;
			y_start_dec : out std_logic;
			y_start_exp : out std_logic;
			y_mux_ctrl  : out aes_mode
			);
end aes_module_cu;

architecture Behavioral of aes_module_cu is
	type States is (S_READY, S_ENC, S_DEC, S_EXP, S_DONE);
	signal S, S_next : States;
	
begin
	
	delta : process (S, x_start, x_mode, x_end_enc, x_end_dec, x_end_exp)
	begin
		case S is 
			when S_READY => y_done <= '0';
								 y_end  <= '0';
								 y_start_enc <= '0';
								 y_start_dec <= '0';
								 y_start_exp <= '0';	
								
								 if x_start = '1' then
									case x_mode is 
										when ENCRYPT    => y_start_enc <= '1';
																 S_next <= S_ENC;
										when DECRYPT    => y_start_dec <= '1';
																 S_next <= S_DEC;
										when EXPAND_KEY => y_start_exp <= '1';
																 S_next <= S_EXP;
										when others     => S_next <= S_READY;				  
									end case;	
								 else
										S_next <= S_READY;								  	
								 end if;
							
			when S_ENC  => y_done <= '0';
								y_end <= '0';
								y_start_enc <= '0';
								y_start_dec <= '0';
								y_start_exp <= '0';	
								y_mux_ctrl <= ENCRYPT;
								
								if x_end_enc = '1' then
									y_end <= '1';									
									S_next <= S_DONE;
								else
									S_next <= S_ENC;
								end if;
			
			when S_DEC  => y_done <= '0';
								y_end <= '0';
								y_start_enc <= '0';
								y_start_dec <= '0';
								y_start_exp <= '0';	
								y_mux_ctrl <= DECRYPT;
								
								if x_end_dec = '1' then
									y_end <= '1';
									S_next <= S_DONE;
								else
									S_next <= S_DEC;
								end if;
			
			when S_EXP  => y_done <= '0';
								y_end <= '0';
								y_start_enc <= '0';
								y_start_dec <= '0';
								y_start_exp <= '0';
			
								if x_end_exp = '1' then
									y_end <= '1';
									S_next <= S_DONE;
								else
								
									S_next <= S_EXP;
								end if;
			
			when S_DONE  => y_done <= '1';
								 y_end <= '0';
								 y_start_enc <= '0';
								 y_start_dec <= '0';
								 y_start_exp <= '0';	
								
								 if x_start = '1' then
									case x_mode is 
										when ENCRYPT    => y_start_enc <= '1';
																 S_next <= S_ENC;
										when DECRYPT    => y_start_dec <= '1';
																 S_next <= S_DEC;
										when EXPAND_KEY => y_start_exp <= '1';
																 S_next <= S_EXP;
										when others     => S_next <= S_DONE;				  
									end case;	
								 else
										S_next <= S_DONE;								  	
								 end if;			 
		end case;
	end process delta;
	
	feedback_loop : process (clk, reset, S_next)
	begin
		if reset = '1' then
			S <= S_READY;
		elsif rising_edge(clk) then
			S <= S_next;
		end if;
	end process feedback_loop;

end Behavioral;

