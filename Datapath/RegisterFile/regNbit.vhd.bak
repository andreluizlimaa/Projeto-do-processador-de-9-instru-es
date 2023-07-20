library ieee;
USE ieee.std_logic_1164.all ;

ENTITY regNbit IS
GENERIC(
	SIZE : INTEGER := 4
);
PORT(
  I : in std_logic_vector(SIZE-1 DOWNTO 0);
  clk, ld, clear : in std_logic;
  S    : out std_logic_vector(SIZE-1 DOWNTO 0)
);
END regNbit;

ARCHITECTURE main of regNbit is
COMPONENT flipflopD IS
PORT(D, clk, load  : in std_logic;
     Q, nQ : out std_logic);
END COMPONENT;
SIGNAL Stemp : std_logic_vector(SIZE-1 DOWNTO 0);
BEGIN
	portLoop : for k in 0 to SIZE-1 generate
		dffe : flipflopD PORT MAP (D => I(k), clk => clk, load => ld, Q => Stemp(k));
	end generate portLoop;
	clr: for i in 0 to SIZE-1 generate
		S(i) <= Stemp(i) AND (NOT clear);
	end generate clr;
END main;