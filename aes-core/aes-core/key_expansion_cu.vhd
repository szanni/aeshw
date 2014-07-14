----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:32:17 07/13/2014 
-- Design Name: 
-- Module Name:    key_expansion_cu - Behavioral 
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

entity key_expansion_cu is
	port(
	   clk      : in  std_logic;
		reset    : in  std_logic;
		cu_start : in  std_logic; -- start key expansion
		cu_end   : out std_logic; -- key expansion finished
		x_comp   : in  std_logic; -- expansion finished (notification from operational unit)
		y_we		: out std_logic; -- controlling signal for write enable
		y_1_2    : out std_logic_vector(1 downto 0); -- controlling signal for key empander mux
		y_3_4    : out std_logic_vector(1 downto 0)  -- controlling signal for counter mux
		

	);
end key_expansion_cu;

architecture Behavioral of key_expansion_cu is

type States is (S1, S2);
signal S, S_next : States;

begin
	
	delta_lambda : process (S, cu_start, x_comp)
	begin
		case S is 
			when S1 => if cu_start = '0' then
							  S_next <= S1;
							  y_1_2 <= "--"; 
						     y_3_4 <= "--";
						     y_we <= '0';
						     cu_end <= '0';
						  else
							  S_next <= S2;
							  y_1_2 <= "00"; 
						     y_3_4 <= "00";
						     y_we <= '0';
						     cu_end <= '0';
						  end if;	  
			when S2 => if x_comp = '0' then
							  S_next <= S2;
							  y_1_2 <= "01";
							  y_3_4 <= "01";
							  y_we <= '1';
							  cu_end <= '0';
						  else
							  S_next <= S1;
							  y_1_2 <= "--";
							  y_3_4 <= "--";
							  y_we <= '0';
							  cu_end <= '1';
						  end if;
		end case;
	end process delta_lambda;

	feedback_loop : process (clk, reset, S_next)
	begin
		if reset = '1' then
			S <= S1;
		elsif rising_edge(clk) then
			S <= S_next;
		end if;
	end process feedback_loop;
end Behavioral;

