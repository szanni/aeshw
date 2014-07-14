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
use work.sbox.all;


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
		y       : in  std_logic_vector(1 downto 0); 
      rcon_in : in  byte;   
		key_in  : in  state;
		key_out : out state
 	); 
 	
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
	
	function sub_word (d_in : word) return word is
		variable t_in, t_out : w_list;
	begin
		t_in := to_w_list(d_in);
		
		for i in 0 to 3 loop
			t_out(i):= sbox(t_in(i));
		end loop;
		return to_word(t_out);
	end sub_word;
	
	function rot_word (d_in : word) return word is
		variable t_in, t_out : w_list;
	begin		
		t_in := to_w_list(d_in);

		t_out := w_list(t_in(1 to 3) & t_in(0));
		return to_word(t_out);
	end rot_word;
	
end key_expander;

architecture Behavioral of key_expander is

signal col_0, col_1, col_2, col_3 : word;
signal col_0_new, col_1_new, col_2_new, col_3_new : word;
signal tmp : word;
signal state_list : s_list;
signal exp_sn_out : state;
signal reg_D, reg_Q : state;


begin
	 
	col_0 <= state_column(reg_Q, 0);
	col_1 <= state_column(reg_Q, 1);
	col_2 <= state_column(reg_Q, 2);
	col_3 <= state_column(reg_Q, 3);
	
	tmp <=  sub_word(rot_word(col_3)) xor (rcon(rcon_in) & x"000000");
	
	col_0_new <= tmp xor col_0;
	col_1_new <= col_0_new xor col_1;
	col_2_new <= col_1_new xor col_2;
   col_3_new <= col_2_new xor col_3;
	
	exp_sn_out <= col_0_new & col_1_new & col_2_new & col_3_new;
	
	
	mux_4_1 : process(y, key_in, exp_sn_out, reg_Q)
	begin
		case y is 
			when "00"   => reg_D <= key_in;
			when "01"   => reg_D <= exp_sn_out;
			when others => reg_D <= reg_Q;
		end case;
	end process mux_4_1;
	

	reg : process (reset, clk, reg_D)
	begin
			if reset = '1' then
				reg_Q <= (others => '0');
			elsif rising_edge(clk) then
				reg_Q <= reg_D;
			end if;
	end process reg;
	
	
	key_out <= reg_Q;

end Behavioral;
