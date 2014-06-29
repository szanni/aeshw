----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:58:47 06/29/2014 
-- Design Name: 
-- Module Name:    key_expander2 - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_expander is
port (
                clk           : in  std_logic;
                reset         : in  std_logic;
                rcon          : in  std_logic_vector(7 downto 0);
                col_1_in      : in  std_logic_vector(7 downto 0);
                col_2_in      : in  std_logic_vector(7 downto 0);
                col_3_in      : in  std_logic_vector(7 downto 0);
                col_4_in      : in  std_logic_vector(7 downto 0);
                sbox_col_4_in : in  std_logic_vector(7 downto 0);
                row_out       : out std_logic_vector(31 downto 0)
        );
end key_expander;

architecture Behavioral of key_expander is

signal sbox_col_4_out : std_logic_vector(7 downto 0);

begin
--sbox_0 : entity work.sbox port map(d_in => sbox_col4_in, d_out => sbox_col_4_out);

-- reg_1 : entity work.reg_32
-- reg_2 : entity work.reg_32 
-- reg_3 : entity work.reg_32
-- reg_3 : entity work.reg_32





end Behavioral;
