library ieee;
use ieee.std_logic_1164.all;
use work.types.all;
use work.math.all;
use work.sbox.all;

entity inv_cipher is
	port (
		clk     : in  std_logic;
		reset   : in  std_logic;
		y	     : in  std_logic_vector(1 downto 0);	
		din     : in  state;
		rkey_in : in  state; 
		dout    : out state
	);

	function inv_sub_bytes (din : state) return state is
		variable tin : s_list;
		variable tout : s_list;
	begin
		tin := to_s_list(din);

		for i in 0 to 15 loop
			tout(i) := inv_sbox(tin(i));
		end loop;

		return to_state(tout);
	end inv_sub_bytes;

	function inv_shift_rows (din : state) return state is
		variable tin : matrix;
		variable tout : matrix;
	begin
		tin := to_matrix(din);

		tout(0, 0) := tin(0, 0);
		tout(0, 1) := tin(0, 1);
		tout(0, 2) := tin(0, 2);
		tout(0, 3) := tin(0, 3);

		tout(1, 0) := tin(1, 3);
		tout(1, 1) := tin(1, 0);
		tout(1, 2) := tin(1, 1);
		tout(1, 3) := tin(1, 2);

		tout(2, 0) := tin(2, 2);
		tout(2, 1) := tin(2, 3);
		tout(2, 2) := tin(2, 0);
		tout(2, 3) := tin(2, 1);

		tout(3, 0) := tin(3, 1);
		tout(3, 1) := tin(3, 2);
		tout(3, 2) := tin(3, 3);
		tout(3, 3) := tin(3, 0);

		return to_state(tout);
	end inv_shift_rows;

	function inv_mix_columns (din : state) return state is
		variable tin : matrix;
		variable tout : matrix;
	begin
		tin := to_matrix(din);

		for col in 0 to 3 loop
			tout(0, col) := mule(tin(0, col)) xor mulb(tin(1, col)) xor muld(tin(2, col)) xor mul9(tin(3, col));
			tout(1, col) := mul9(tin(0, col)) xor mule(tin(1, col)) xor mulb(tin(2, col)) xor muld(tin(3, col));
			tout(2, col) := muld(tin(0, col)) xor mul9(tin(1, col)) xor mule(tin(2, col)) xor mulb(tin(3, col));
			tout(3, col) := mulb(tin(0, col)) xor muld(tin(1, col)) xor mul9(tin(2, col)) xor mule(tin(3, col));
		end loop;

		return to_state(tout);
	end inv_mix_columns;

	function add_round_key (din : state; key : state) return state is
	variable tout : state;
	begin
		tout := din xor key;
		return tout;
	end add_round_key;

end inv_cipher;

architecture behavioral of inv_cipher is
signal reg_D, reg_Q : state;
signal inv_shift_rows_out, inv_sub_bytes_out, add_round_key_in, add_round_key_out, inv_mix_columns_out  : state;
signal data_in_ctrl, leave_mix_columns_ctrl : std_logic;


begin

	inv_shift_rows_out <= inv_shift_rows(reg_Q);
	inv_sub_bytes_out <= inv_sub_bytes(inv_shift_rows_out);
	
	data_in_ctrl <= y(1);
	data_in_mux : process(data_in_ctrl, din, inv_sub_bytes_out)
	begin
		case data_in_ctrl is 
			when '0'    => add_round_key_in <= din;
			when others => add_round_key_in <= inv_sub_bytes_out;
		end case;
	end process data_in_mux;
	
	add_round_key_out <= add_round_key_in xor rkey_in; --add_round_key(add_round_key_in, rkey_in);	
	inv_mix_columns_out <= inv_mix_columns(add_round_key_out);
	
	leave_mix_columns_ctrl <= y(0);
	leave_mix_columns_mux : process(leave_mix_columns_ctrl, add_round_key_out, inv_mix_columns_out)
	begin
		case leave_mix_columns_ctrl is 
			when '0'    => reg_D <= add_round_key_out;
			when others => reg_D <= inv_mix_columns_out;
		end case;
	end process leave_mix_columns_mux;
	
	reg : entity work.state_reg port map(clk => clk, 
													 reset => reset,
												    D => reg_D,
													 Q => reg_Q
													);
	dout <= reg_Q;

end behavioral;

