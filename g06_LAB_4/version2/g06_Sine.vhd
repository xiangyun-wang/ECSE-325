library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g06_Sine is
port(
  clock   : in std_logic;
  i       : in std_logic_vector (15 downto 0);
  result  : out std_logic_vector (15 downto 0)
  --ecursion: out std_logic_vector(31 downto 0)
);
end g06_Sine;

architecture no_pipeline of g06_Sine is

signal reg_out,reg_in  : std_logic_vector(15 downto 0);
signal z_reg_1,z_reg_2,z_reg_3,z_reg_4,z_reg_5,z_reg_6,z_reg_7   : std_logic_vector(31 downto 0);
signal next_1, next_2, next_3, next_4, next_5, next_6, next_7 : std_logic_vector(31 downto 0);
signal i_reg_1, i_reg_2, i_reg_3, i_reg_4, i_reg_5  : std_logic_vector(31 downto 0);
signal i_change : std_logic_vector(31 downto 0);
signal A1, B1, C1 : std_logic_vector(31 downto 0);
signal tmp1_1, tmp1_2, tmp1_3, tmp1_4,tmp1_6     : std_logic_vector(63 downto 0);
signal tmp2_1, tmp2_2                            : std_logic_vector(31 downto 0);

begin

update : process(clock)
begin
  if (clock'event and rising_edge(clock)) then
    z_reg_1 <= next_1;
    z_reg_2 <= next_2;
    z_reg_3 <= next_3;
    z_reg_4 <= next_4;
    z_reg_5 <= next_5;
    z_reg_6 <= next_6;
    z_reg_7 <= next_7;
    i_reg_5 <= i_reg_4;
    i_reg_4 <= i_reg_3;
    i_reg_3 <= i_reg_2;
    i_reg_2 <= i_reg_1;
    i_reg_1 <= i_change;
    --i_change <= "0000000000000000"&i;
  end if;
end process;

--tmp1 <= to_unsigned(0,32);
A1 <= "11001000111011001000101001001011";
B1 <= "10100011101100100010100100101100";
C1 <= "00000000000001000111011001000101";
--i_change <= std_logic_vector(to_unsigned(0,32));
i_change <= "0000000000000000"&i;
tmp1_1 <= std_logic_vector(unsigned(C1)*unsigned(i_change));
next_1 <= "0000000000000"&tmp1_1(31 downto 13);

--i_reg_1 <= i_change;
tmp1_2 <= std_logic_vector(unsigned(z_reg_1)*unsigned(i_reg_1));
--tmp2 <= "000"&tmp1(31 downto 3);
next_2 <= std_logic_vector(unsigned(B1)-unsigned("000"&tmp1_2(31 downto 3)));

--i_reg_2 <= i_reg_1;
tmp1_3 <= std_logic_vector(unsigned(i_reg_2)*(unsigned("0000000000000"&z_reg_2(31 downto 13))));
next_3 <= tmp1_3(31 downto 0);

--i_reg_3 <= i_reg_2;
tmp1_4 <= std_logic_vector(unsigned(i_reg_3)*(unsigned("0000000000000"&z_reg_3(31 downto 13))));
next_4 <= tmp1_4(31 downto 0);

next_5 <= std_logic_vector(unsigned(A1)-unsigned("0"&z_reg_4(31 downto 1)));

tmp1_6 <= std_logic_vector(unsigned(i_reg_5)*unsigned("0000000000000"&z_reg_5(31 downto 13)));
next_6 <= tmp1_6(31 downto 0);

tmp2_1 <= std_logic_vector(to_unsigned(1,32));
tmp2_2 <= std_logic_vector(unsigned(z_reg_6)+unsigned(tmp2_1(13 downto 0)&"000000000000000000"));
next_7 <= "0000000000000000000"&tmp2_2(31 downto 19);

result <= z_reg_7(15 downto 0);
--reg_out <= recursion(15 downto 0);
end no_pipeline;
