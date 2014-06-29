library ieee;
use ieee.std_logic_1164.all;

package types is

	subtype byte is std_logic_vector(7 downto 0);
	type state is array(0 to 15) of byte;
	type word is array(0 to 3) of byte;
	type sbox_lut is array(0 to 255) of byte;

	function to_state(d_in : std_logic_vector(127 downto 0)) return state;

end types;

package body types is

	function to_state(d_in : std_logic_vector(127 downto 0)) return state is
		variable ret : state;
	begin
		for i in 0 to 15 loop
			ret(i) := d_in(128-i*8-1 downto 128-(i+1)*8);
		end loop;
		return ret;
	end to_state;

end types;
