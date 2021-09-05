library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;
entity g06_MS is
port(
  Wt_i  : out std_logic_vector(31 downto 0);
  M_i   : in std_logic_vector(31 downto 0);
  ld_i  : in std_logic;
  CLK   : in std_logic
);
end g06_MS;

architecture logic of g06_MS is
signal d0, d1, d3: std_logic_vector(31 downto 0);
signal r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 : std_logic_vector(31 downto 0);
signal sum, next_r0 : std_logic_vector(31 downto 0);
begin

shifter : process(CLK)
begin
  if(CLK'event and rising_edge(CLK)) then
    -- add
    --sum <= std_logic_vector(unsigned(d0) + unsigned(r6) + unsigned(d0) + unsigned(r15));  -- might be able to move
    -- register shifter
    r15 <= r14;
    r14 <= r13;
    r13 <= r12;
    r12 <= r11;
    r11 <= r10;
    r10 <= r9;
    r9 <= r8;
    r8 <= r7;
    r7 <= r6;
    r6 <= r5;
    r5 <= r4;
    r4 <= r3;
    r3 <= r2;
    r2 <= r1;
    r1 <= r0;
    r0 <= next_r0;
  end if;
end process;

-- multiplex
next_r0 <= sum when ld_i = '0' else M_i;
Wt_i <= next_r0;
-- shifter blocks
d1 <= ((r1(16 downto 0)&r1(31 downto 17)) xor (r1(18 downto 0)&r1(31 downto 19))) xor ("0000000000"&r1(31 downto 10));
d0 <= ((r14(6 downto 0)&r14(31 downto 7)) xor (r14(17 downto 0)&r14(31 downto 18))) xor ("000"&r14(31 downto 3));
sum <= std_logic_vector(unsigned(d0) + unsigned(r6) + unsigned(d0) + unsigned(r15));
end logic;
