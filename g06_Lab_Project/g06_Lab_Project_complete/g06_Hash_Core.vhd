library ieee ; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ; --needed if you are using unsigned rotate operations
entity g06_Hash_Core is
port (	A_o , B_o , C_o , D_o , E_o , F_o , G_o , H_o 	: 	inout std_logic_vector (31 downto 0);
				A_i, B_i , C_i , D_i , E_i , F_i , G_i , H_i 		: 	in std_logic_vector (31 downto 0);
				Kt_i, Wt_i 																			: 	in std_logic_vector (31 downto 0);
				LD, CLK																					:		in std_logic;
				core_debug																			: out std_logic_vector(31 downto 0)
);
end g06_Hash_Core;

architecture core of g06_Hash_Core is
-- use of the previous code describing the four blocks at right
component g06_SIG_CH_MAJ
	port(	A_o , B_o , C_o , E_o , F_o , G_o 		: in std_logic_vector (31 downto 0);
				SIG0, SIG1, CH, MAJ										: out std_logic_vector (31 downto 0)
	);
end component;

signal SIG0, SIG1, CH, MAJ 	: std_logic_vector (31 downto 0);
signal a_0, e_0, tmp1, tmp2, tmp3	: unsigned (31 downto 0);
signal reg_A, reg_B, reg_C, reg_D, reg_E, reg_F, reg_G, reg_H : unsigned (31 downto 0);
signal next_A, next_B, next_C, next_D, next_E, next_F, next_G, next_H: unsigned (31 downto 0);

begin
-- mapping the component inported to the cicuit to be implemented here
L2: g06_SIG_CH_MAJ port map
	(A_o => A_o, B_o => B_o, C_o => C_o, E_o => E_o, F_o => F_o, G_o => G_o,
	SIG0 => SIG0, SIG1 => SIG1, CH => CH, MAJ => MAJ);

registers_update: process(CLK)
begin
	if (CLK'event and rising_edge(CLK)) then
		reg_A <= next_A;
		reg_B <= next_B;
		reg_C <= next_C;
		reg_D <= next_D;
		reg_E <= next_E;
		reg_F <= next_F;
		reg_G <= next_G;
		reg_H <= next_H;
	end if;
end process;

tmp1 <= unsigned(Kt_i) + unsigned(Wt_i);
tmp2 <= unsigned(CH) + unsigned(reg_H);
tmp3 <= tmp1+tmp2;
a_0 <= (unsigned(MAJ) + unsigned(SIG0) + tmp3 + unsigned(SIG1));
e_0 <= (tmp3 + unsigned(SIG1) + unsigned(reg_D));

-- update the next register state according to LD
next_A <= unsigned(A_i) when LD = '1' else  a_0;
next_B <= unsigned(B_i) when LD = '1' else reg_A;
next_C <= unsigned(C_i) when LD = '1' else reg_B;
next_D <= unsigned(D_i) when LD = '1' else reg_C;
next_E <= unsigned(E_i) when LD = '1' else e_0;
next_F <= unsigned(F_i) when LD = '1' else reg_E;
next_G <= unsigned(G_i) when LD = '1' else reg_F;
next_H <= unsigned(H_i) when LD = '1' else reg_G;

-- update output
A_o <= std_logic_vector(reg_A);
B_o <= std_logic_vector(reg_B);
C_o <= std_logic_vector(reg_C);
D_o <= std_logic_vector(reg_D);
E_o <= std_logic_vector(reg_E);
F_o <= std_logic_vector(reg_F);
G_o <= std_logic_vector(reg_G);
H_o <= std_logic_vector(reg_H);

core_debug <= std_logic_vector(H_o);

-- example <= std_logic_vector(to_unsigned(this_integer, example'length))
--mid_sum <= unsigned(CH) + reg_H + unsigned(Kt_i) + unsigned(Wt_i) + unsigned(SIG1);
--mid_sum <= reg_H + CH + unsigned(Kt_i) + unsigned(Wt_i) + SIG1;
--e_0 <= mid_sum + reg_D;
--e_0 <= mid_sum + reg_D;
--a_0 <= unsigned(MAJ) + unsigned(SIG0) + mid_sum;
--a_0 <= mid_sum + SIG0 + MAJ;

end core;
