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
signal y,recursion1,recursion2,recursion3,recursion4,recursion5,recursion6,recursion7   : std_logic_vector(31 downto 0);
signal i_change : std_logic_vector(31 downto 0);
signal A1, B1, C1 : std_logic_vector(31 downto 0);
signal tmp1_1, tmp1_2, tmp1_3, tmp1_4,tmp1_6     : std_logic_vector(63 downto 0);
signal tmp2_1, tmp2_2     : std_logic_vector(31 downto 0);

begin

update : process(clock)
begin
  if (clock'event and rising_edge(clock)) then
    reg_in <= i;
    result <= recursion7(15 downto 0);
  end if;
end process;

--tmp1 <= to_unsigned(0,32);
A1 <= "11001000111011001000101001001011";
B1 <= "10100011101100100010100100101100";
C1 <= "00000000000001000111011001000101";
--i_change <= std_logic_vector(to_unsigned(0,32));
i_change <= "0000000000000000"&reg_in;
tmp1_1 <= std_logic_vector(unsigned(C1)*unsigned(i_change));
--recursion1 <= "0000000000000"&tmp1(31 downto 13);

tmp1_2 <= std_logic_vector(unsigned("0000000000000"&tmp1_1(31 downto 13))*unsigned(i_change));
--tmp2 <= "000"&tmp1(31 downto 3);
recursion2 <= std_logic_vector(unsigned(B1)-unsigned("000"&tmp1_2(31 downto 3)));

tmp1_3 <= std_logic_vector(unsigned(i_change)*(unsigned("0000000000000"&recursion2(31 downto 13))));
recursion3 <= tmp1_3(31 downto 0);

tmp1_4 <= std_logic_vector(unsigned(i_change)*(unsigned("0000000000000"&recursion3(31 downto 13))));
recursion4 <= tmp1_4(31 downto 0);

recursion5 <= std_logic_vector(unsigned(A1)-unsigned("0"&recursion4(31 downto 1)));

tmp1_6 <= std_logic_vector(unsigned(i_change)*unsigned("0000000000000"&recursion5(31 downto 13)));
recursion6 <= tmp1_6(31 downto 0);

tmp2_1 <= std_logic_vector(to_unsigned(1,32));
tmp2_2 <= std_logic_vector(unsigned(recursion6)+unsigned(tmp2_1(13 downto 0)&"000000000000000000"));
recursion7 <= "0000000000000000000"&tmp2_2(31 downto 19);

--reg_out <= recursion(15 downto 0);
end no_pipeline;
