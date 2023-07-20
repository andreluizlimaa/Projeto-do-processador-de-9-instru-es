library ieee;
USE ieee.std_logic_1164.all ;

ENTITY somador IS
GENERIC(
	SIZE : INTEGER := 6
);
PORT(
  A, B : in std_logic_vector(SIZE-1 DOWNTO 0);
  C	   : out std_logic_vector(SIZE-1 DOWNTO 0);
  ci  : in std_logic
);
END somador;

ARCHITECTURE main of somador is
COMPONENT fullAdder IS
PORT(
  a, b, ci : in std_logic;
  c, co    : out std_logic
);
END COMPONENT;

SIGNAL CO : std_logic_vector(SIZE-1 DOWNTO 0);

BEGIN
	fAdder : fullAdder PORT MAP (a => A(0), b => B(0), ci => ci, c => C(0), co => CO(0));
	portLoop : for i in 1 to SIZE-1 generate
		fAdder : fullAdder PORT MAP (a => A(i), b => B(i), ci => CO(i-1), c => C(i), co => CO(i));
	end generate portLoop;
END main;

