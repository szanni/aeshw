library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

package math is

	function mul2(d_in : byte) return byte;
	function mul3(d_in : byte) return byte;

end math;

package body math is

	function mul2(d_in : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := d_in(7);
		ret(1) := d_in(0) xor d_in(7);
		ret(2) := d_in(1);
		ret(3) := d_in(2) xor d_in(7);
		ret(4) := d_in(3) xor d_in(7);
		ret(5) := d_in(4);
		ret(6) := d_in(5);
		ret(7) := d_in(6);

		return ret;
	end mul2;

	function mul3(d_in : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := d_in(0) xor d_in(7);
		ret(1) := d_in(0) xor d_in(1) xor d_in(7);
		ret(2) := d_in(1) xor d_in(2);
		ret(3) := d_in(2) xor d_in(3) xor d_in(7);
		ret(4) := d_in(3) xor d_in(4) xor d_in(7);
		ret(5) := d_in(4) xor d_in(5);
		ret(6) := d_in(5) xor d_in(6);
		ret(7) := d_in(6) xor d_in(7);

		return ret;
	end mul3;

end math;
