library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

package math is

	function mul2(din : byte) return byte;
	function mul3(din : byte) return byte;
	function mul9(din : byte) return byte;
	function mulb(din : byte) return byte;
	function muld(din : byte) return byte;
	function mule(din : byte) return byte;

end math;

package body math is

	function mul2(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(7);
		ret(1) := din(0) xor din(7);
		ret(2) := din(1);
		ret(3) := din(2) xor din(7);
		ret(4) := din(3) xor din(7);
		ret(5) := din(4);
		ret(6) := din(5);
		ret(7) := din(6);

		return ret;
	end mul2;

	function mul3(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(7);
		ret(1) := din(0) xor din(1) xor din(7);
		ret(2) := din(1) xor din(2);
		ret(3) := din(2) xor din(3) xor din(7);
		ret(4) := din(3) xor din(4) xor din(7);
		ret(5) := din(4) xor din(5);
		ret(6) := din(5) xor din(6);
		ret(7) := din(6) xor din(7);

		return ret;
	end mul3;

	function mul9(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(5);
		ret(1) := din(1) xor din(5) xor din(6);
		ret(2) := din(2) xor din(6) xor din(7);
		ret(3) := din(0) xor din(3) xor din(5) xor din(7);
		ret(4) := din(1) xor din(4) xor din(5) xor din(6);
		ret(5) := din(2) xor din(5) xor din(6) xor din(7);
		ret(6) := din(3) xor din(6) xor din(7);
		ret(7) := din(4) xor din(7);

		return ret;
	end mul9;

	function mulb(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(5) xor din(7);
		ret(1) := din(0) xor din(1) xor din(5) xor din(6) xor din(7);
		ret(2) := din(1) xor din(2) xor din(6) xor din(7);
		ret(3) := din(0) xor din(2) xor din(3) xor din(5);
		ret(4) := din(1) xor din(3) xor din(4) xor din(5) xor din(6) xor din(7);
		ret(5) := din(2) xor din(4) xor din(5) xor din(6) xor din(7);
		ret(6) := din(3) xor din(5) xor din(6) xor din(7);
		ret(7) := din(4) xor din(6) xor din(7);

		return ret;
	end mulb;

	function muld(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(5) xor din(6);
		ret(1) := din(1) xor din(5) xor din(7);
		ret(2) := din(0) xor din(2) xor din(6);
		ret(3) := din(0) xor din(1) xor din(3) xor din(5) xor din(6) xor din(7);
		ret(4) := din(1) xor din(2) xor din(4) xor din(5) xor din(7);
		ret(5) := din(2) xor din(3) xor din(5) xor din(6);
		ret(6) := din(3) xor din(4) xor din(6) xor din(7);
		ret(7) := din(4) xor din(5) xor din(7);

		return ret;
	end muld;

	function mule(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(5) xor din(6) xor din(7);
		ret(1) := din(0) xor din(5);
		ret(2) := din(0) xor din(1) xor din(6);
		ret(3) := din(0) xor din(1) xor din(2) xor din(5) xor din(6);
		ret(4) := din(1) xor din(2) xor din(3) xor din(5);
		ret(5) := din(2) xor din(3) xor din(4) xor din(6);
		ret(6) := din(3) xor din(4) xor din(5) xor din(7);
		ret(7) := din(4) xor din(5) xor din(6);

		return ret;
	end mule;

end math;
