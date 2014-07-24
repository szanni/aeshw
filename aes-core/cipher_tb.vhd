library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity cipher_tb is
end cipher_tb;

architecture behavior of cipher_tb is

	component cipher
	port (
		din : in state;
		dout : out state
	);
	end component;

	--Inputs
	signal din : state;

	--Outputs
	signal dout : state;

begin

	uut: cipher port map (
		din => din,
		dout => dout
	);

stim_proc: process
begin

	--din <= x"d42711aee0bf98f1b8b45de51e415230";
	din <= x"d4bf5d30e0b452aeb84111f11e2798e5";
	wait for 10 ns;
	--assert dout = x"d4bf5d30e0b452aeb84111f11e2798e5" report "cipher: lookup failure" severity failure;
	assert dout = x"046681e5e0cb199a48f8d37a2806264c" report "cipher: mix failure" severity failure;

	wait;

end process;

end;
