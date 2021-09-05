library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;

entity g06_SHA256 is
port (
		clock, resetn 					: in std_logic;
		read, write, chipselect : in std_logic;
		address 			: in std_logic_vector(7 downto 0);
		in_data 			: in std_logic_vector(31 downto 0);
		out_data			: out std_logic_vector(31 downto 0);
		reg						: out std_logic_vector(31 downto 0);
		debug					: out std_logic_vector(31 downto 0);
		debug_i				: out integer;
		debug_l				: out std_logic
		-- hash_out 	: out std_logic_vector(255 downto 0);
		-- RESET, CLK 	: in std_logic
);
end g06_SHA256;

architecture lab3 of g06_SHA256 is
signal Kt_i : std_logic_vector (31 downto 0); --:= X"428a2f98";
signal Wt : std_logic_vector (31 downto 0); --:= x"00000000";
signal h0 : std_logic_vector (31 downto 0) := x"6a09e667"; --initial hash values
signal h1 : std_logic_vector (31 downto 0) := x"bb67ae85";
signal h2 : std_logic_vector (31 downto 0) := x"3c6ef372";
signal h3 : std_logic_vector (31 downto 0) := x"a54ff53a";
signal h4 : std_logic_vector (31 downto 0) := x"510e527f";
signal h5 : std_logic_vector (31 downto 0) := x"9b05688c";
signal h6 : std_logic_vector (31 downto 0) := x"1f83d9ab";
signal h7 : std_logic_vector (31 downto 0) := x"5be0cd19";
type SHA_256_STATE is ( INIT, LOAD, RUN,UPDATE, PUSHOUT, IDLE);
signal state : SHA_256_STATE := IDLE;
signal A_o , B_o , C_o , D_o , E_o , F_o , G_o , H_o : std_logic_vector (31 downto 0);
signal LD, ld_i : std_logic;
signal round_count : integer range 0 to 64;
signal m_count : unsigned (4 downto 0);
-- signal r_count : unsigned 6 downto 0;
signal r_count : integer range 0 to 8;
signal M_i : std_logic_vector(31 downto 0);
signal load_to_mem : std_logic := '0';
signal write_to_out: std_logic := '0';
signal RUN_flag				: std_logic := '0';
signal core_debug : std_logic_vector(31 downto 0);

type message_array is array(0 to 15) of std_logic_vector(31 downto 0);
signal M : message_array;

type constant_array is array(0 to 63) of std_logic_vector(31 downto 0);

constant Kt : constant_array := ( x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5",
x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5", x"d807aa98", x"12835b01",
x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa",
x"5cb0a9dc", x"76f988da", x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7",
x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967", x"27b70a85", x"2e1b2138",
x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624",
x"f40e3585", x"106aa070", x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5",
x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3", x"748f82ee", x"78a5636f",
x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2"
);

COMPONENT g06_Hash_Core
PORT (
	A_o, B_o , C_o , D_o , E_o , F_o , G_o , H_o 		: inout std_logic_vector (31 downto 0);
	A_i , B_i , C_i , D_i , E_i , F_i , G_i , H_i 	: in std_logic_vector (31 downto 0);
	Kt_i , Wt_i 								: in std_logic_vector (31 downto 0);
	LD, CLK 										: in std_logic;
	core_debug		: out std_logic_vector(31 downto 0)
);
END COMPONENT;

COMPONENT g06_MS
PORT(
	Wt_i  : out std_logic_vector(31 downto 0);
	M_i   : in std_logic_vector(31 downto 0);
	ld_i  : in std_logic;
	CLK   : in std_logic
);
END COMPONENT;

begin

Core_port_map : g06_Hash_Core
	PORT MAP (A_o => A_o,B_o => B_o,C_o => C_o,D_o => D_o,E_o => E_o,
	F_o => F_o,G_o => G_o,H_o => H_o, A_i => h0,B_i => h1,C_i => h2,D_i => h3,
	E_i => h4,F_i => h5,G_i => h6,H_i => h7,Kt_i => Kt_i,Wt_i => Wt,
	LD => LD, CLK => clock, core_debug =>  core_debug);

MS_port_map	: g06_MS
	PORT MAP (
	Wt_i => Wt,
	M_i=>	M_i,-- missing
	ld_i => ld_i,
	CLK=>clock
	);
-- need to add ................................
	--out_data <= A_o & B_o & C_o & D_o & E_o & F_o & G_o & H_o;
-- concatenate to form the 256 bit hash output
	process(resetn, clock)
	begin
		if resetn = '1'then
			state <= IDLE;
		elsif rising_edge(clock) then
			case state is
			when INIT =>
				LD <= '0';
				state <= LOAD;
				round_count <= 0;
				m_count <= "00000";
			when LOAD =>
				if (write = '1') then
					M(to_integer(m_count)) <= in_data;
					m_count <= m_count + 1;
					if m_count = "01111" then
						LD <= '1';
						m_count <= "00000";
						state <= RUN;
					else
						load_to_mem <= '1';
					end if;
				end if;
			when RUN =>
				if (round_count < 16) then
					M_i <= M(round_count);
					ld_i <= '1';
				end if;
				if round_count < 64 then
					if round_count >= 16 then
						ld_i <= '0';
					end if;
					RUN_flag <= '1';
					load_to_mem <= '0';
					LD <= '0';
					if round_count = 63 then
						h0 <= std_logic_vector(unsigned(h0) + unsigned(A_o));
						h1 <= std_logic_vector(unsigned(h1) + unsigned(B_o));
						h2 <= std_logic_vector(unsigned(h2) + unsigned(C_o));
						h3 <= std_logic_vector(unsigned(h3) + unsigned(D_o));
						h4 <= std_logic_vector(unsigned(h4) + unsigned(E_o));
						h5 <= std_logic_vector(unsigned(h5) + unsigned(F_o));
						h6 <= std_logic_vector(unsigned(h6) + unsigned(G_o));
						h7 <= std_logic_vector(unsigned(h7) + unsigned(H_o));
						state <= PUSHOUT;
					end if;
					round_count <= round_count + 1;
				--else
					--h0 <= std_logic_vector(unsigned(h0) + unsigned(A_o));
					--h1 <= std_logic_vector(unsigned(h1) + unsigned(B_o));
					--h2 <= std_logic_vector(unsigned(h2) + unsigned(C_o));
					--h3 <= std_logic_vector(unsigned(h3) + unsigned(D_o));
					--h4 <= std_logic_vector(unsigned(h4) + unsigned(E_o));
					--h5 <= std_logic_vector(unsigned(h5) + unsigned(F_o));
					--h6 <= std_logic_vector(unsigned(h6) + unsigned(G_o));
					--h7 <= std_logic_vector(unsigned(h7) + unsigned(H_o));
					--state <= PUSHOUT;
				end if;
			when UPDATE =>
				-- h0 <= std_logic_vector(unsigned(h0) + unsigned(A_o));
				-- h1 <= std_logic_vector(unsigned(h1) + unsigned(B_o));
				-- h2 <= std_logic_vector(unsigned(h2) + unsigned(C_o));
				-- h3 <= std_logic_vector(unsigned(h3) + unsigned(D_o));
				-- h4 <= std_logic_vector(unsigned(h4) + unsigned(E_o));
				-- h5 <= std_logic_vector(unsigned(h5) + unsigned(F_o));
				-- h6 <= std_logic_vector(unsigned(h6) + unsigned(G_o));
				-- h7 <= std_logic_vector(unsigned(h7) + unsigned(H_o));
				--debug <= '1';
				state <= PUSHOUT;
			when PUSHOUT =>
				--debug <= '1';
				if (read = '1') then
					if r_count < 8 then
						write_to_out <= '1';
						r_count <= r_count + 1;
					else
						state <= IDLE;
					end if;
				end if;
			when IDLE =>
				write_to_out <= '0';
				r_count <= 0;
				state <= INIT;
				LD <= '1';
			end case;
		end if;
	end process;
	--debug_l <= ld_i;
	debug_l <= LD;
	--ld_i <= '1' when (round_count < 16 and RUN_flag = '1') else '0';
	Kt_i <= Kt(round_count-1) when round_count > 0;
	--M_i <= M(round_count) when (round_count < 16 );
	-- M(m_count-1) <= in_data when load_to_mem = '1';
	reg <= H_o;
	debug <= Wt;
	debug_i <= round_count;
	out_data <= h0 when (write_to_out = '1' and r_count = 1) else
							h1 when (write_to_out = '1' and r_count = 2) else
							h2 when (write_to_out = '1' and r_count = 3) else
							h3 when (write_to_out = '1' and r_count = 4) else
							h4 when (write_to_out = '1' and r_count = 5) else
							h5 when (write_to_out = '1' and r_count = 6) else
							h6 when (write_to_out = '1' and r_count = 7) else
							h7 when (write_to_out = '1' and r_count = 8);
end lab3;
