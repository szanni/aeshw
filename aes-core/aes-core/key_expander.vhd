----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:58:47 06/29/2014 
-- Design Name: 
-- Module Name:    key_expander - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_expander is
   port (
		clk     : in  std_logic;
      reset   : in  std_logic;
      rcon_in : in  byte;   
		key_in  : in  state;
		key_out : out state
 	); 
 
	function sbox (d_in : byte) return byte is
		constant sbox_lut : lut := (
			x"63", x"7C", x"77", x"7B", x"F2", x"6B", x"6F", x"C5", x"30", x"01", x"67", x"2B", x"FE", x"D7", x"AB", x"76",
			x"CA", x"82", x"C9", x"7D", x"FA", x"59", x"47", x"F0", x"AD", x"D4", x"A2", x"AF", x"9C", x"A4", x"72", x"C0",
			x"B7", x"FD", x"93", x"26", x"36", x"3F", x"F7", x"CC", x"34", x"A5", x"E5", x"F1", x"71", x"D8", x"31", x"15",
			x"04", x"C7", x"23", x"C3", x"18", x"96", x"05", x"9A", x"07", x"12", x"80", x"E2", x"EB", x"27", x"B2", x"75",
			x"09", x"83", x"2C", x"1A", x"1B", x"6E", x"5A", x"A0", x"52", x"3B", x"D6", x"B3", x"29", x"E3", x"2F", x"84",
			x"53", x"D1", x"00", x"ED", x"20", x"FC", x"B1", x"5B", x"6A", x"CB", x"BE", x"39", x"4A", x"4C", x"58", x"CF",
			x"D0", x"EF", x"AA", x"FB", x"43", x"4D", x"33", x"85", x"45", x"F9", x"02", x"7F", x"50", x"3C", x"9F", x"A8",
			x"51", x"A3", x"40", x"8F", x"92", x"9D", x"38", x"F5", x"BC", x"B6", x"DA", x"21", x"10", x"FF", x"F3", x"D2",
			x"CD", x"0C", x"13", x"EC", x"5F", x"97", x"44", x"17", x"C4", x"A7", x"7E", x"3D", x"64", x"5D", x"19", x"73",
			x"60", x"81", x"4F", x"DC", x"22", x"2A", x"90", x"88", x"46", x"EE", x"B8", x"14", x"DE", x"5E", x"0B", x"DB",
			x"E0", x"32", x"3A", x"0A", x"49", x"06", x"24", x"5C", x"C2", x"D3", x"AC", x"62", x"91", x"95", x"E4", x"79",
			x"E7", x"C8", x"37", x"6D", x"8D", x"D5", x"4E", x"A9", x"6C", x"56", x"F4", x"EA", x"65", x"7A", x"AE", x"08",
			x"BA", x"78", x"25", x"2E", x"1C", x"A6", x"B4", x"C6", x"E8", x"DD", x"74", x"1F", x"4B", x"BD", x"8B", x"8A",
			x"70", x"3E", x"B5", x"66", x"48", x"03", x"F6", x"0E", x"61", x"35", x"57", x"B9", x"86", x"C1", x"1D", x"9E",
			x"E1", x"F8", x"98", x"11", x"69", x"D9", x"8E", x"94", x"9B", x"1E", x"87", x"E9", x"CE", x"55", x"28", x"DF",
			x"8C", x"A1", x"89", x"0D", x"BF", x"E6", x"42", x"68", x"41", x"99", x"2D", x"0F", x"B0", x"54", x"BB", x"16"
		);
	begin
		return sbox_lut(to_integer(unsigned(d_in)));
	end sbox;
	
	function rcon(d_in : byte ) return byte is
	   constant rcon_lut : lut := (
			x"8D", x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", x"36", x"6C", x"D8", x"AB", x"4D", x"9A", 
         x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", x"C5", x"91", x"39", 
         x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", x"25", x"4A", x"94", x"33", x"66", x"CC", x"83", x"1D", x"3A", 
         x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", x"36", x"6C", x"D8", 
         x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", 
         x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", x"25", x"4A", x"94", x"33", x"66", x"CC", 
         x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", 
         x"36", x"6C", x"D8", x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", x"6A", x"D4", x"B3", 
         x"7D", x"FA", x"EF", x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", x"25", x"4A", x"94", 
         x"33", x"66", x"CC", x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", x"08", x"10", x"20", 
         x"40", x"80", x"1B", x"36", x"6C", x"D8", x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", 
         x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", 
         x"25", x"4A", x"94", x"33", x"66", x"CC", x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", 
         x"08", x"10", x"20", x"40", x"80", x"1B", x"36", x"6C", x"D8", x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", 
         x"C6", x"97", x"35", x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", 
         x"61", x"C2", x"9F", x"25", x"4A", x"94", x"33", x"66", x"CC", x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D"
		);
	begin
		return rcon_lut(to_integer(unsigned(d_in)));
	end rcon;
	
	function add_rcon (rcon_in : byte; column : word) return word is
		variable ret : word;
	begin
		ret:= word((rcon(rcon_in) xor column(0)) & column(1 to 3));
		return ret;
	end add_rcon;
	
	function sub_word (d_in : word) return word is
		variable ret : word;
	begin
		for i in 0 to 3 loop
			ret(i):= sbox(d_in(i));
		end loop;
		return ret;
	end sub_word;
	
	function rot_word (d_in : word) return word is
		variable ret : word;
	begin
		ret := d_in(1 to 3) & d_in(0);
		return ret;
	end rot_word;
	
end key_expander;

architecture Behavioral of key_expander is

signal col_0, col_1, col_2, col_3 : word;
signal col_0_new, col_1_new, col_2_new, col_3_new : word;
signal tmp : word;

begin
	
	col_0 <= word(key_in(0 to 3));
	col_1 <= word(key_in(4 to 7));
	col_2 <= word(key_in(8 to 11));
	col_3 <= word(key_in(12 to 15));
	
	tmp <= add_rcon(rcon_in, sub_word(rot_word(col_3)));
	
	col_0_new <= tmp xor col_0;
	col_1_new <= col_0_new xor col_1;
	col_2_new <= col_1_new xor col_2;
   col_3_new <= col_2_new xor col_3;	
	
	key_out <= state(col_0_new & col_1_new & col_2_new & col_3_new);
	
end Behavioral;
