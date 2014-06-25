library ieee;
use ieee.std_logic_1164.all;

entity sbox_inv_tb is
end sbox_inv_tb;

architecture behavior of sbox_inv_tb is

	component sbox_inv
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

	uut: sbox_inv port map (
		d_in => d_in,
		d_out => d_out
	);

stim_proc: process
begin

	d_in <= x"b8";
	wait for 10 ns;
	assert d_out = x"9a" report "sbox_inv: lookup failure" severity failure;

	wait;

end process;

end;
