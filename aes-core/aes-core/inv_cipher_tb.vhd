library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity inv_cipher_tb is
end inv_cipher_tb;

architecture behavior of inv_cipher_tb is

	component inv_cipher
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

	uut: inv_cipher port map (
		din => din,
		dout => dout
	);

stim_proc: process
begin

	--din <= x"d4bf5d30e0b452aeb84111f11e2798e5";
	din <= x"fa636a2825b339c940668a3157244d17";
	wait for 10 ns;
	--assert dout = x"d42711aee0bf98f1b8b45de51e415230" report "inv_cipher: lookup failure" severity failure;
	assert dout = x"fc1fc1f91934c98210fbfb8da340eb21" report "inv_cipher: mix failure" severity failure;

	wait;

end process;

end;
