library ieee;
USE ieee.std_logic_1164.all ;

ENTITY compNbit IS
GENERIC(
	SIZE : INTEGER := 4;
	UNSIGNopt : BOOLEAN := false
);
PORT(
  A, B : in std_logic_vector(SIZE-1 DOWNTO 0);
  --in_lt, in_eq, in_gt : in std_logic; in case you ever want to use it for some reason
  s_lt, s_eq, s_gt    : out std_logic
);
END compNbit;

ARCHITECTURE main of compNbit is
COMPONENT comp1bit
PORT(
  a, b, in_lt, in_eq, in_gt : in std_logic;
  s_lt, s_eq, s_gt    : out std_logic
);
END COMPONENT;
SIGNAL ltAux, eqAux, gtAux : std_logic_vector(SIZE-1 DOWNTO 0);
BEGIN
	portSignT : if UNSIGNopt = true generate
		start : comp1bit PORT MAP (a => A(SIZE-1), b => B(SIZE-1), in_lt => '0', in_eq => '1', in_gt => '0',
			s_lt => ltAux(SIZE-1), s_eq => eqAux(SIZE-1), s_gt => gtAux(SIZE-1));
	end generate portSignT;
	portSignF : if UNSIGNopt = false generate
		start : comp1bit PORT MAP (a => A(SIZE-1), b => B(SIZE-1), in_lt => '0', in_eq => '1', in_gt => '0',
			s_lt => gtAux(SIZE-1), s_eq => eqAux(SIZE-1), s_gt => ltAux(SIZE-1));
	end generate portSignF;
			
	portLoop : for i in 0 TO SIZE-2 generate
		comp : comp1bit PORT MAP (a => A(i), b => B(i), in_lt => ltAux(i+1), in_eq => eqAux(i+1), in_gt => gtAux(i+1),
			s_lt => ltAux(i), s_eq => eqAux(i), s_gt => gtAux(i));
	end generate portLoop;
	s_lt <= ltAux(0);
	s_eq <= eqAux(0);
	s_gt <= gtAux(0);
END main;