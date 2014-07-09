library ieee;
use ieee.std_logic_1164.all;

package types is

	subtype byte is std_logic_vector(7 downto 0);
	subtype state is std_logic_vector(127 downto 0);
	type list is array(0 to 15) of byte;
	type word is array(0 to 3) of byte;
	type lut is array(0 to 255) of byte;

	function to_state(din : list) return state;
	function to_list(din : state) return list;
	function "XOR" (a, b : word) return word;

end types;

package body types is

   function "XOR" (a, b : word) return word is
		variable ret : word;
	begin
	   for i in 0 to 3 loop
			ret(i) := a(i) xor b(i);
		end loop;
		return ret;
	end "XOR";

	function to_state(din : list) return state is
		variable ret : state;
	begin
		for i in 0 to 15 loop
			ret(128-i*8-1 downto 128-(i+1)*8) := din(i);
		end loop;
		return ret;
	end to_state;

	function to_list(din : state) return list is
		variable ret : list;
	begin
		for i in 0 to 15 loop
			ret(i) := din(128-i*8-1 downto 128-(i+1)*8);
		end loop;
		return ret;
	end to_list;

end types;
