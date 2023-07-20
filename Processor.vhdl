library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;
--altProcessor's been giving me (Marcos) less headaches
entity Processor is
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
	I_data : out std_logic_vector(IR_WIDTH-1 downto 0);
	ALU_Sel : out std_logic_vector(2 DOWNTO 0);
	RF_Waddr, RF_RPaddr : out std_logic_vector(3 DOWNTO 0);
	RF_gt, I_rd : out std_logic
);
end entity Processor;

architecture main of Processor is

COMPONENT ControlUnit is
generic (
	IR_WIDTH : integer := ICSIZE;
	PC_WIDTH : integer := PCSIZE
);
port (
	clk, reset : in std_logic;
	RF_Rp_zero, cmp_gt : in std_logic;
	I_data : in std_logic_vector(IR_WIDTH-1 downto 0);
	PC_set : in std_logic_vector(PC_WIDTH-1 downto 0);
	I_rd, D_rd, D_wr, RF_W_Wen, RF_Rp_Ren, RF_Rq_Ren : out std_logic;
	RF_W_addr, RF_Rp_addr, RF_Rq_addr : out std_logic_vector(3 DOWNTO 0);
	RF_Sel, ALU_Sel : out std_logic_vector(1 DOWNTO 0);
	D_addr, RF_W_Data : out std_logic_vector(7 DOWNTO 0);
	I_addr : out std_logic_vector(PC_WIDTH-1 downto 0)
);
END COMPONENT;

COMPONENT DataPath IS
GENERIC(
	M_addrSIZE : INTEGER := SSIZE;
	regSIZE : INTEGER := BSIZE;
	UNSIGNopt : BOOLEAN := false
);
PORT(
	RF_Wdata, Rd_data : IN STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);
	RF_Sel, ALU_Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	RF_Waddr, RF_RPaddr, RF_RQaddr : IN STD_LOGIC_VECTOR (M_addrSIZE-1 DOWNTO 0);
	RF_Wen, RF_RenP, RF_RenQ, clk : IN STD_LOGIC;
	
	W_data : OUT STD_LOGIC_VECTOR (regSIZE-1 DOWNTO 0);
	RF_RP_zero, RF_gt : OUT STD_LOGIC
	);
END COMPONENT;

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


SIGNAL RF_RP_zero_o, cmp_gt_o, I_rd_o, D_rd_o, D_wr_o, RF_W_Wen_o, RF_Rp_Ren_o,
	RF_Rq_Ren_o : std_logic;
SIGNAL RF_Sel_o, ALU_Sel_o : std_logic_vector(1 DOWNTO 0);
SIGNAL D_addr_o, RF_W_Data_o : std_logic_vector(7 DOWNTO 0);
SIGNAL I_addr_o, W_data_o : std_logic_vector(PC_WIDTH-1 downto 0);
SIGNAL RF_W_addr_o, RF_Rp_addr_o, RF_Rq_addr_o : std_logic_vector(3 DOWNTO 0);
SIGNAL I_data_o : std_logic_vector(IR_WIDTH-1 downto 0);
SIGNAL D_data_o : std_logic_vector(regSIZE-1 downto 0);
begin
	
	exampleOut <= W_data_o;
	I_data <= I_data_o;
	ALU_Sel <= ALU_Sel_o;
	RF_Waddr <= RF_W_addr_o;
	RF_RPaddr <= RF_Rp_addr_o;
	RF_gt <= cmp_gt_o;
	I_rd <= I_rd_o;
	
	ControlU : ControlUnit port map (clk => clk, reset => reset, RF_RP_zero => RF_RP_zero_o, cmp_gt => cmp_gt_o,
	I_data => I_data_o, PC_set => W_data_o, I_rd => I_rd_o, D_rd => D_rd_o, D_wr => D_wr_o, RF_W_Wen => RF_W_Wen_o,
	RF_Rp_Ren => RF_Rp_Ren_o, RF_Rq_Ren => RF_Rq_Ren_o, RF_W_addr => RF_W_addr_o, RF_Rp_addr => RF_Rp_addr_o, 
	RF_Rq_addr => RF_Rq_addr_o, RF_Sel => RF_Sel_o, ALU_Sel => ALU_Sel_o, D_addr => D_addr_o, RF_W_Data => RF_W_Data_o,
	I_addr => I_addr_o);
	
	DP : DataPath port map (RF_Wdata => "00000000" & RF_W_Data_o, Rd_data => D_data_o, RF_Sel => RF_Sel_o, 
	ALU_Sel => ALU_Sel_o, RF_Waddr => RF_W_addr_o, RF_RPaddr => RF_Rp_addr_o, RF_RQaddr => RF_Rq_addr_o, RF_Wen => RF_W_Wen_o,
	RF_RenP => RF_RP_Ren_o, RF_RenQ => RF_RQ_Ren_o, clk => clk, W_data => W_data_o, RF_Rp_zero => RF_RP_zero_o, RF_gt => cmp_gt_o);

	--faking a (2^4)x16 as a (2^16)x16 'cause tis too heavy for my pc to compile/simulate
	IMEM : InstructionMemory GENERIC MAP (N => 4) port map (CLK => NOT clk, RD => I_rd_o, ADDR => I_addr_o(3 DOWNTO 0),
	DATA => I_data_o);
	DMEM : RAM port map (CLK => clk, ADDR => D_addr_o, RD => D_rd_o, WR => D_wr_o, W_DATA => W_data_o, R_DATA => D_data_o);
	
end architecture main;