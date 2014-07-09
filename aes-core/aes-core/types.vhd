library ieee;
use ieee.std_logic_1164.all;

package types is

	subtype byte is std_logic_vector(7 downto 0);
	subtype state is std_logic_vector(127 downto 0);
	subtype word is std_logic_vector(31 downto 0);
	
	type s_list is array(0 to 15) of byte;
	type w_list is array(0 to 3) of byte;
	type matrix is array(0 to 3, 0 to 3) of byte;
	type lut is array(0 to 255) of byte;

	function to_state(din : s_list) return state;
	function to_state(din : matrix) return state;
	function state_column(din : state; i : integer) return word;
	function to_word(din : w_list) return word;
	function to_s_list(din : state) return s_list;
	function to_w_list(din : word) return w_list;
	function to_matrix(din : state) return matrix;
end types;

package body types is

	function to_state(din : s_list) return state is
		variable ret : state;
	begin
		for i in 0 to 15 loop
			ret(128-i*8-1 downto 128-(i+1)*8) := din(i);
		end loop;
		return ret;
	end to_state;

	
	function to_state(din : matrix) return state is
		variable ret : state;
		variable i : integer;
	begin
		for row in 0 to 3 loop
			for col in 0 to 3 loop
				i := row + col * 4;
				ret(128-i*8-1 downto 128-(i+1)*8) := din(row, col);
			end loop;
		end loop;
		return ret;
	end to_state;
	
	function state_column(din : state; i : integer) return word is
		variable ret : word;
	begin
		ret := din(128-i*32-1 downto 128-(i+1)*32);
		return ret;
	end state_column;
	
	function to_s_list(din : state) return s_list is
		variable ret : s_list;
	begin
		for i in 0 to 15 loop
			ret(i) := din(128-i*8-1 downto 128-(i+1)*8);
		end loop;
		return ret;
	end to_s_list;
	
	function to_word(din : w_list) return word is
		variable ret : word;
	begin
		for i in 0 to 3 loop
			ret(32-i*8-1 downto 32-(i+1)*8) := din(i);
		end loop;
		return ret;
	end to_word;
	
	function to_w_list(din : word) return w_list is
		variable ret : w_list;
	begin
		for i in 0 to 3 loop
			ret(i) := din(32-i*8-1 downto 32-(i+1)*8);
		end loop;
		return ret;
	end to_w_list;


	function to_matrix(din : state) return matrix is
		variable ret : matrix;
		variable i : integer;
	begin
		for row in 0 to 3 loop
			for col in 0 to 3 loop
				i := row + col * 4;
				ret(row, col) := din(128-i*8-1 downto 128-(i+1)*8);
			end loop;
		end loop;
		return ret;
	end to_matrix;
end types;
