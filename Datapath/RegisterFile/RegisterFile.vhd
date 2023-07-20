LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.utils.all;

ENTITY RegisterFile IS
GENERIC(
	M_addrSIZE : INTEGER := (SSIZE);
	regSIZE : INTEGER := BSIZE
);
PORT(
	Wdata : IN STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);
	Waddr, RPaddr, RQaddr : IN STD_LOGIC_VECTOR (M_addrSIZE-1 DOWNTO 0);
	Wen, RenP, RenQ, clk : IN STD_LOGIC;
	RPdata, RQdata : OUT STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0)
	);
END;

ARCHITECTURE main OF RegisterFile IS
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
SIGNAL regP, regQ : STD_LOGIC_VECTOR(regSIZE-1 DOWNTO 0);

BEGIN

	rfLoop : for i in 0 to M_addrSIZE-1 generate
		regf : regNbit GENERIC MAP(SIZE => regSIZE) PORT MAP (I => Wdata, clk => clk, clear => '0', ld => regLoad(i), S => RF(i));
	end generate rfLoop;
	
	--read (it is possible to loop it for N heads with a vecArray signal to represent all 'out' registers)
	--this won't behave as the 3 state driver one, but it stills counts as a 
	muxp: muxKx1comp1bit GENERIC MAP(SSIZE => SSIZE) PORT MAP (I => RF, sel => RPaddr, S => regP);
	rp : regNbit GENERIC MAP (SIZE => regSIZE) PORT MAP (I => regP, clk => clk, clear => '0', ld => RenP, S => RPdata);
	muxq: muxKx1comp1bit GENERIC MAP(SSIZE => SSIZE) PORT MAP (I => RF, sel => RQaddr, S => regQ);
	rq : regNbit GENERIC MAP (SIZE => regSIZE) PORT MAP (I => regQ, clk => clk, clear => '0', ld => RenQ, S => RQdata);
	
	--write
	decLoad : decMx2eM GENERIC MAP(SIZE => M_addrSIZE) PORT MAP(sel => Waddr, e => Wen, S => regLoad);

END;