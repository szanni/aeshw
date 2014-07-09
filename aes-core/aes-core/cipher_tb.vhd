library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity cipher_tb is
end cipher_tb;

architecture behavior of cipher_tb is

	component cipher
	port (
		d_in : in state;
		d_out : out state
	);
	end component;

	--Inputs
	signal d_in : state;

	--Outputs
	signal d_out : state;

begin

	uut: cipher port map (
		d_in => d_in,
		d_out => d_out
	);

stim_proc: process
begin

	--d_in <= to_state(x"d42711aee0bf98f1b8b45de51e415230");
	d_in <= to_state(x"d4bf5d30e0b452aeb84111f11e2798e5");
	wait for 10 ns;
	--assert d_out = to_state(x"d4bf5d30e0b452aeb84111f11e2798e5") report "cipher: lookup failure" severity failure;
	assert d_out = to_state(x"046681e5e0cb199a48f8d37a2806264c") report "cipher: mix failure" severity failure;

	wait;

end process;

end;
