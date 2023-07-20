LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.utils.all;
--needed the proprietary quartus ii emulation software for emulation
ENTITY DataPath IS
GENERIC(
	M_addrSIZE : INTEGER := SSIZE;
	regSIZE : INTEGER := BSIZE;
	UNSIGNopt : BOOLEAN := false
);
PORT(
	--Rd_data is the read data from the D memory;
	--'Wen' stands for write enable, 'Ren' for Read enable;
	--W_data is the write output to the D memory;
	--keep in mind that RF_gt only makes sense for JGT
	RF_Wdata, Rd_data : IN STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);
	RF_Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	ALU_Sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	RF_Waddr, RF_RPaddr, RF_RQaddr : IN STD_LOGIC_VECTOR (M_addrSIZE-1 DOWNTO 0);
	RF_Wen, RF_RenP, RF_RenQ, clk : IN STD_LOGIC;
	
	W_data : OUT STD_LOGIC_VECTOR (regSIZE-1 DOWNTO 0);
	RF_RP_zero: OUT STD_LOGIC
	);
END;

ARCHITECTURE main OF DataPath IS
COMPONENT regNbit IS
	GENERIC(
		SIZE : INTEGER := 4
	);
	PORT(
		I : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
		clk, ld, clear : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT muxKx1comp1bit IS
	GENERIC(
		SSIZE : INTEGER := 2
	);
	PORT(
		I : vecArray((2**SSIZE)-1 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(SSIZE-1 DOWNTO 0);
		S : OUT STD_LOGIC_VECTOR(BSIZE-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT RegisterFile IS
GENERIC(
	M_addrSIZE : INTEGER := SSIZE;
	regSIZE : INTEGER := BSIZE
);
PORT(
	Wdata : IN STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);
	Waddr, RPaddr, RQaddr : IN STD_LOGIC_VECTOR (M_addrSIZE-1 DOWNTO 0);
	Wen, RenP, RenQ, clk : IN STD_LOGIC;
	RPdata, RQdata : OUT STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT compNbit IS
GENERIC(
	SIZE : INTEGER := 4;
	UNSIGNopt : BOOLEAN := false
);
PORT(
  A, B : in std_logic_vector(SIZE-1 DOWNTO 0);
  --in_lt, in_eq, in_gt : in std_logic; in case you ever want to use it for some reason
  s_lt, s_eq, s_gt    : out std_logic
);
END COMPONENT;

COMPONENT ALU IS
GENERIC(
	SIZE : INTEGER := 8;
	UNSIGNopt : BOOLEAN := false
);
PORT(
	A, B : in std_logic_vector(SIZE-1 DOWNTO 0);
	x, y, z : in std_logic;
   S : out std_logic_vector(SIZE-1 DOWNTO 0);
	eq : out std_logic
);
END COMPONENT;


SIGNAL RF_inputs : vecArray(3 DOWNTO 0);
SIGNAL regLoad : STD_LOGIC_VECTOR((2**M_addrSIZE)-1 DOWNTO 0);
SIGNAL muxOut, ALU_out, RF_Pout, RF_Qout : STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);
BEGIN
	RF_inputs(0) <= ALU_out;
	RF_inputs(1) <= Rd_data;
	RF_inputs(2) <= RF_Wdata;
	RF_inputs(3) <= (others => '0');
	rf_mux : muxKx1comp1bit PORT MAP (I => RF_inputs, sel => RF_Sel, S => muxOut);
	RF : RegisterFile PORT MAP (Wdata => muxOut, Waddr => RF_Waddr, RPaddr => RF_RPaddr, RQaddr => RF_RQaddr, Wen => RF_Wen,
		RenP => RF_RenP, RenQ => RF_RenQ, clk => clk, RPdata => RF_Pout, RQdata => RF_Qout);
	ALUport : ALU GENERIC MAP (SIZE => regSIZE) PORT MAP (A => RF_Pout, B => RF_Qout, x => ALU_Sel(2), y => ALU_Sel(1), z => ALU_Sel(0),
		S => ALU_out);
	W_data <= RF_Pout;
	--overkill but there's a comparator already anyway
	compz : compNbit GENERIC MAP (SIZE => regSIZE) PORT MAP (A => RF_Pout, B => (others => '0'), s_eq => RF_RP_zero);
		
END;