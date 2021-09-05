library ieee;
use ieee.std_logic_1164.all;
entity g06_SHA256_custom_component is
port(
  clock, resetn : in std_logic;
  read, write, chipselect : in std_logic;
  address : in std_logic_vector(7 downto 0);
  writedata : in std_logic_vector (31 downto 0);
  readdata : out std_logic_vector(31 downto 0)
);
end g06_SHA256_custom_component;

architecture Structure of g06_SHA256_custom_component is

signal to_component, from_component : std_logic_vector(31 downto 0);

component g06_SHA256
port(
  clock, resetn : in std_logic;
  read, write, chipselect : in std_logic;
  address : in STD_LOGIC_VECTOR(7 downto 0);
  in_data : in std_logic_vector(31 downto 0);
  out_data : out std_logic_vector(31 downto 0)
);
end component;

begin

to_component <= writedata;

component_inst: g06_SHA256 port map (clock, resetn, read, write,
chipselect, address, to_component, from_component);

readdata <= from_component;

end Structure;
