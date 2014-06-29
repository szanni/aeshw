----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:08:24 06/29/2014 
-- Design Name: 
-- Module Name:    reg_32 - Behavioral 
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

entity reg_32 is
port (
                clk   : in  std_logic;
                reset : in  std_logic;
					 D     : in  std_logic_vector(31 downto 0);
					 Q     : out std_logic_vector(31 downto 0)
        );
end reg_32;

architecture Behavioral of reg_32 is

begin

	REG: process(clk, reset)
		begin
			if reset = '1' then
				Q <= (others => '0');
			elsif rising_edge(clk) then
				Q <= D;
			end if;
	end process REG;		

end Behavioral;

