library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity altProcessor is --made for debugging the processor, actually easier output one
GENERIC(
	--almost every size variable happened to be the same size lol
	M_addrSIZE : INTEGER := SSIZE;
	regSIZE : INTEGER := BSIZE;
	UNSIGNopt : BOOLEAN := false;
	IR_WIDTH : integer := ICSIZE;
	PC_WIDTH : integer := PCSIZE
);
port (
	clk, reset : in std_logic;
	exampleOut : OUT STD_LOGIC_VECTOR (regSIZE-1 DOWNTO 0);
	ex_RF_W_addr : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
	ex_RF_Rp_addr : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

	--in case the sole existence of the IM keeps making the ControlUnit delay it's output for the datapath in 3 clk cycles
	--I_data : in std_logic_vector(IR_WIDTH-1 downto 0);
	I_data : out std_logic_vector(IR_WIDTH-1 downto 0);
	I_addr : out std_logic_vector(PC_WIDTH-1 downto 0);
	I_rd : out std_logic
);
end entity altProcessor;

architecture main of altProcessor is

COMPONENT DPCU is
GENERIC(
	--almost every size variable happened to be the same size lol
	M_addrSIZE : INTEGER := SSIZE;
	regSIZE : INTEGER := BSIZE;
	UNSIGNopt : BOOLEAN := false;
	IR_WIDTH : integer := ICSIZE;
	PC_WIDTH : integer := PCSIZE
);
port (
	clk, reset : in std_logic;
	exampleOut : OUT STD_LOGIC_VECTOR (regSIZE-1 DOWNTO 0);
	ex_RF_W_addr : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
	ex_RF_Rp_addr : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

	--things for datapath-controlUnit analysis
	I_data : in std_logic_vector(IR_WIDTH-1 downto 0);
	I_rd, D_rd, D_wr : out std_logic;
	D_addr : out std_logic_vector(7 DOWNTO 0);
	I_addr : out std_logic_vector(PC_WIDTH-1 downto 0);
	ALU_Sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	Rd_data : IN STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0)
);
end COMPONENT;

COMPONENT RAM IS
    generic (
        N : natural := 8; -- Número de bits para endereçamento
        M : natural := 16 -- Número de bits para dados
    );
    port (
        CLK     : in  std_logic;
        ADDR    : in  std_logic_vector(N-1 downto 0);
        RD      : in  std_logic;
        WR      : in  std_logic;
        W_DATA  : in  std_logic_vector(M-1 downto 0);
        R_DATA  : out std_logic_vector(M-1 downto 0)
    );
END COMPONENT RAM;

COMPONENT InstructionMemory IS
    generic (
        N : natural := 16; -- Número de bits para endereçamento
        M : natural := 16 -- Número de bits para dados
    );
    port (
        CLK  : in  std_logic;
        RD   : in  std_logic;
        ADDR : in  std_logic_vector(N-1 downto 0);
        DATA : out std_logic_vector(M-1 downto 0)
    );
END COMPONENT InstructionMemory;


SIGNAL I_rd_o, D_rd_o, D_wr_o : std_logic;
SIGNAL ALU_Sel_o : std_logic_vector(2 DOWNTO 0);
SIGNAL D_addr_o : std_logic_vector(7 DOWNTO 0);
SIGNAL I_addr_o, W_data_o : std_logic_vector(PC_WIDTH-1 downto 0);
SIGNAL I_data_o : std_logic_vector(IR_WIDTH-1 downto 0);
SIGNAL D_data_o : std_logic_vector(regSIZE-1 downto 0);
begin
	DatapathnControlUnit : DPCU port map (clk => clk, reset =>  reset, I_data => I_data_o, I_rd => I_rd_o, D_rd => D_rd_o, 
	D_wr => D_wr_o, D_addr => D_addr_o, I_addr => I_addr_o, Rd_data => D_data_o, exampleOut => W_data_o, ex_RF_W_addr => ex_RF_W_addr, ex_RF_Rp_addr => ex_RF_Rp_addr, ALU_Sel => ALU_Sel_o);
	
	exampleOut <= W_data_o;
	ALU_Sel <= ALU_Sel_o;
	I_rd <= I_rd_o;
	I_addr <= I_addr_o;
	--changes wheter I_data is an input or output
	I_data <= I_data_o;
	--I_data_o <= I_data;

	--faking a (2^4)x16 as a (2^16)x16 'cause tis too heavy for my pc to compile/simulate
	IMEM : InstructionMemory GENERIC MAP (N => 4) port map (CLK => NOT clk, RD => I_rd_o, ADDR => I_addr_o(3 DOWNTO 0),
	--IMEM : altInstructionMemory GENERIC MAP (M_addrSIZE => 4) port map (CLK => CLK, RD => I_rd_o, ADDR => I_addr_o(3 DOWNTO 0),
	DATA => I_data_o);
	
	DMEM : RAM port map (CLK => clk, ADDR => D_addr_o, RD => D_rd_o, WR => D_wr_o, W_DATA => W_data_o, R_DATA => D_data_o);
	
end architecture main;