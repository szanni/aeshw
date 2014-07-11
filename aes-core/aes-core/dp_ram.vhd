----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:29:02 07/09/2014 
-- Design Name: 
-- Module Name:    expansion_ram_dp - Behavioral 
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
use ieee.numeric_std.all;
use work.types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dp_ram is
	generic(
		address_width : integer := 4
	);
	port (
		clk : std_logic;
		address_read  : std_logic_vector(address_width -1 downto 0);
		address_write : std_logic_vector(address_width -1 downto 0);
		en_write: in std_logic;
		din_write:  in  state;
		q : out state
	);
end dp_ram;

architecture Behavioral of dp_ram is
type ram_memory is array(0 to (2**address_width)-1) of state;
signal ram : ram_memory;
signal address_read_reg : std_logic_vector(address_width -1 downto 0);
begin
	
	write_p : process(clk)
	begin
		if rising_edge(clk) then
			if (en_write = '1') then
				ram(to_integer(unsigned(address_write))) <= din_write;
			end if;
		end if;
		address_read_reg <= address_read;
	end process write_p;
		
	q <= ram(to_integer(unsigned(address_read_reg)));

end Behavioral;

