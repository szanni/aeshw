----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:25:50 07/14/2014 
-- Design Name: 
-- Module Name:    key_expansion_module - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;
use work.types.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_expansion is
	port(
		clk : in std_logic;
		reset : in std_logic;
		exp_start : in std_logic;
		exp_end : out std_logic;
		address_in : in std_logic_vector(3 downto 0); 
		key_in : in state;
		key_out : out state
	);
end key_expansion;

architecture Structural of key_expansion is

signal y_1_2, y_3_4 : std_logic_vector (1 downto 0);
signal y_we : std_logic;
signal x_comp : std_logic;
signal count : byte;
signal round_key : state;
signal rcon_in : byte;

begin
	rcon_in <= count + 1;
		
	expander : entity work.key_expander port map(clk => clk,
																reset => reset,
																y => y_1_2,
																rcon_in => rcon_in,
																key_in => key_in,
																key_out => round_key
																);

	counter : entity work.counter port map (clk => clk,
														 reset => reset,
														 y => y_3_4,
														 x => x_comp,
														 d_out => count 
														 );
														 	
	ram : entity work.dp_ram port map(clk => clk, 
												 address_read => address_in,
												 address_write => count (3 downto 0),
												 en_write => y_we,
												 din_write => round_key,
												 q => key_out
												 );
												 		 
	control_unit : entity work.key_expansion_cu port map (clk => clk,
										    							  reset => reset,
																		  y_1_2 => y_1_2,
																		  y_3_4 => y_3_4,
																		  y_we => y_we,
																		  y_end => exp_end,
																		  x_start => exp_start,
																		  x_comp => x_comp
																			);
end Structural;

