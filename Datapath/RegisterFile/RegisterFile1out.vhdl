LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.utils.all;

ENTITY RegisterFile1out IS
GENERIC(
	M_addrSIZE : INTEGER := SSIZE;
	regSIZE : INTEGER := BSIZE
);
PORT(
	Wdata : IN STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);
	Waddr, Raddr : IN STD_LOGIC_VECTOR (M_addrSIZE-1 DOWNTO 0);
	Wen, Ren, clk : IN STD_LOGIC;
	Rdata : OUT STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0)
	);
END;

ARCHITECTURE main OF RegisterFile1out IS
COMPONENT regNbit IS
	GENERIC(
		SIZE : INTEGER := 4
	);
	PORT(I : IN STD_LOGIC_VECTOR(SIZE-1 DOWNTO 0);
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

COMPONENT decMx2eM IS
GENERIC(
	SIZE : INTEGER := 3
);
PORT(
  sel : in std_logic_vector(SIZE-1 DOWNTO 0);
  e : in std_logic;
  S : out std_logic_vector((2**SIZE)-1 DOWNTO 0)
);
END COMPONENT;

SIGNAL RF : vecArray((2**SSIZE)-1 DOWNTO 0);
SIGNAL regLoad : STD_LOGIC_VECTOR((2**M_addrSIZE)-1 DOWNTO 0);
SIGNAL regOut : STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);
BEGIN
	rfLoop : for i in 0 to (2**M_addrSIZE)-1 generate
		regf : regNbit GENERIC MAP(SIZE => regSIZE) PORT MAP (I => Wdata, clk => clk, clear => '0', ld => regLoad(i), S => RF(i));
	end generate rfLoop;

	mux: muxKx1comp1bit GENERIC MAP(SSIZE => M_addrSIZE) PORT MAP (I => RF, sel => Raddr, S => regOut);
	rout : regNbit GENERIC MAP (SIZE => regSIZE) PORT MAP (I => regOut, clk => clk, clear => '0', ld => Ren, S => Rdata);
	
	decLoad : decMx2eM GENERIC MAP(SIZE => M_addrSIZE) PORT MAP(sel => Waddr, e => Wen, S => regLoad);

END;