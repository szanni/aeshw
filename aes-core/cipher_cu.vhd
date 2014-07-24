----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:06:05 07/16/2014 
-- Design Name: 
-- Module Name:    cipher_cu - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cipher_cu is
	port(
		clk     : in  std_logic;
		reset   : in  std_logic;
		x_start : in  std_logic;  -- start encryption
		x_comp  : in  std_logic;  -- '1' if last round is reached
		y_1_2   : out std_logic_vector(1 downto 0); -- controlling values for cipher
		y_3_4   : out std_logic_vector(1 downto 0); -- controlling values for counter	
	   y_end   : out std_logic -- encryption finished
	);
end cipher_cu;

architecture Behavioral of cipher_cu is

type States is (S0, S1, S2, S3, S4, S5);
signal S, S_next : States;

begin

	delta : process (S, x_start, x_comp)
	begin
		case S is 
			when S0 => y_1_2 <="--"; 
						  y_3_4 <="00"; -- initialize counter
						  y_end <= '0';
						  if x_start = '1' then
							S_next <= S1;
						  else 
						   S_next <= S0;
						  end if;
			
			when S1 => y_1_2 <= "--"; -- round key 0 not yet available (due to synchonous read)
						  y_3_4 <= "01"; -- increment counter
						  y_end <= '0';
						  S_next <= S2;
						  
			when S2 => y_1_2 <= "00"; -- load in plaintext (round key 0 now available) 
						  y_3_4 <= "01"; -- increment counter
						  y_end <= '0';
						  S_next <= S3;
			
			when S3 => y_1_2 <= "01"; -- include mix columns stage
						  y_3_4 <= "01"; 
						  y_end <= '0';  
						  if x_comp = '1' then
						   	S_next <= S4; -- last round starts after the next cycle
						  else 
								S_next <= S3;
						  end if;
			
			when S4 => y_1_2 <= "10"; -- leave out mix columns stage
						  y_3_4 <= "--"; 
						  y_end <= '0';
						  S_next <= S5;
			
			when S5 => y_1_2 <= "--"; 
						  y_3_4 <= "--"; 
						  y_end <= '1'; -- finished (output valid for one cycle)
						  S_next <= S0;
		end case;
	end process delta;

	feedback_loop : process (clk, reset, S_next)
	begin
		if reset = '1' then
			S <= S0;
		elsif rising_edge(clk) then
			S <= S_next;
		end if;
	end process feedback_loop;


end Behavioral;

