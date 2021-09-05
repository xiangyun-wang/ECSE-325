-- entity name: g06_SIG_CH_MAJ
-- version 1.0
-- Authors: (Adrian Wang, Xiangyun Wang, Irene Ma)
-- Date : March 13th, 2021

library ieee ; -- allows use of the std_logic_vector type use
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ; --needed if you are using unsigned rotate operations

entity g06_SIG_CH_MAJ is
	port (	A_o , B_o , C_o , E_o , F_o , G_o 	: in std_logic_vector (31 downto 0);
			SIG0, SIG1, CH, MAJ					: out std_logic_vector (31 downto 0)
);
end g06_SIG_CH_MAJ;

architecture circuit of g06_SIG_CH_MAJ is 
begin
	MAJ <= ((A_o and B_o) xor (B_o and C_o)) xor (A_o and C_o);
	CH <= (E_o and F_o) xor ((not E_o) and G_o);
	SIG0 <= ((A_o(1 downto 0) & A_o(31 downto 2)) xor (A_o(12 downto 0) & A_o(31 downto 13))) xor (A_o(21 downto 0) & A_o(31 downto 22));
	SIG1 <= ((E_o(5 downto 0) & E_o(31 downto 6)) xor (E_o(10 downto 0) & E_o(31 downto 11))) xor (E_o(24 downto 0) & E_o(31 downto 25));

end circuit;




