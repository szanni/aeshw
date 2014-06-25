library ieee;
use ieee.std_logic_1164.all;

entity sbox_tb is
end sbox_tb;

architecture behavior of sbox_tb is

	component sbox
	port (
		d_in : in std_logic_vector(7 downto 0);
		d_out : out std_logic_vector(7 downto 0)
	);
	end component;

	--Inputs
	signal d_in : std_logic_vector(7 downto 0) := (others => '0');

	--Outputs
	signal d_out : std_logic_vector(7 downto 0);

begin

	uut: sbox port map (
		d_in => d_in,
		d_out => d_out
	);

stim_proc: process
begin

	d_in <= x"9a";
	wait for 10 ns;
	assert d_out = x"b8" report "sbox: lookup failure" severity failure;

	d_in <= x"9a";
	wait for 10 ns;
	assert d_out = x"b8" report "sbox: lookup failure" severity failure;

	wait;

end process;

end;
