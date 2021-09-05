LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Decode_tb IS
END Decode_tb;

ARCHITECTURE behaviour OF Decode_tb IS

--Declare the component that you are testing:
    COMPONENT g06_SHA256 IS

    port(
    clock, resetn 					: in std_logic;
    read, write, chipselect : in std_logic;
    address 			: in std_logic_vector(7 downto 0);
    in_data 			: in std_logic_vector(31 downto 0);
    out_data			: out std_logic_vector(31 downto 0);
    reg						: out std_logic_vector(31 downto 0);
    debug         : out std_logic_vector(31 downto 0);
    debug_i       : out integer;
    debug_l				: out std_logic
    );

  end component;

  signal clock, resetn : std_logic;
  signal read, write, chipselect : std_logic;
  signal address : std_logic_vector(7 downto 0);
  signal writedata : std_logic_vector (31 downto 0);
  signal readdata : std_logic_vector(31 downto 0);
  signal reg      : std_logic_vector(31 downto 0);
  signal debug    : std_logic_vector(31 downto 0);
  signal debug_i  : integer;
  signal debug_l	: std_logic;
  constant clk_period : time := 20 ns;

begin
    --dut => Device Under Test
    dut: g06_SHA256 port MAP(
    clock => clock,
    resetn => resetn,
    read => read,
    write=>write,
    chipselect=>chipselect,
    address => address,
    in_data => writedata,
    out_data=>readdata,
    reg => reg,
    debug => debug,
    debug_i => debug_i,
    debug_l => debug_l
    );

    clk_process : process
    BEGIN
        clock <= '1';
        wait for clk_period/2;
        clock <= '0';
        wait for clk_period/2;
    end process;

    test_process : process
    BEGIN
        wait for clk_period*3;
        -- case 1 : add
        --add rs =1, rt=2, rd=3
        write <= '1';
        writedata <="01101000011001010110110001101100";
        wait for clk_period*1;
        writedata <="01101111001000000111011101101111";
        wait for clk_period*1;
        writedata <="01110010011011000110010010000000";
        wait for clk_period*1;
        -- testing
        writedata <="00000000000000000000000000000011";
        wait for clk_period*1;
        writedata <="00000000000000000000000000000111";
        wait for clk_period*1;
        writedata <="00000000000000000000000000001111";
        wait for clk_period*1;
        writedata <="00000000000000000000000100000000";
        wait for clk_period*1;
        writedata <="00000000000000000000000000010000";
        wait for clk_period*1;
        writedata <="00000000000000000100000000000000";
        wait for clk_period*1;
        writedata <="00000000000000000001000000000000";
        wait for clk_period*1;
        writedata <="00000000000000000000000100000000";
        wait for clk_period*1;
        writedata <="00000000000000000000000001000000";
        wait for clk_period*1;
        writedata <="00000000000000000000000000001000";
        wait for clk_period*1;
        writedata <="00000000000000000000001000000000";
        wait for clk_period*1;
        writedata <="00000000000000000000000000010000";
        wait for clk_period*1;
        writedata <="00000000000000000000000000000001";
        wait for clk_period*1;
        write <= '0';

        wait for clk_period*128;
        read <= '1';

        -- case 2 : substract
        --add rs =4, rt=5, rd=6
        --wait for clk_period*10;


        wait;

    END PROCESS;


END;
