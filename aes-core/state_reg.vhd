----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:04:17 07/16/2014 
-- Design Name: 
-- Module Name:    state_reg - Behavioral 
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

entity state_reg is
port (
		clk   : in std_logic;
		reset : in std_logic;
		D     : in state;
		Q     : out state
	);
end state_reg;

architecture Behavioral of state_reg is
begin
	
	reg : process (reset, clk, D)
	begin
			if reset = '1' then
				Q <= (others => '0');
			elsif rising_edge(clk) then
				Q <= D;
			end if;
	end process reg;

end Behavioral;

