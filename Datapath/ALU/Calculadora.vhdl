library ieee;
USE ieee.std_logic_1164.all ;

ENTITY Calculadora IS
GENERIC(
	SIZE : INTEGER := 6
);
PORT(
  A, B : in std_logic_vector(SIZE-1 DOWNTO 0);
  x,y,z, e, clk  : in std_logic;
  S	   : out std_logic_vector(SIZE-1 DOWNTO 0)
);
END Calculadora;

ARCHITECTURE main of Calculadora is
COMPONENT ALU IS
GENERIC(
	SIZE : INTEGER := 6
);
PORT(
	A, B : in std_logic_vector(SIZE-1 DOWNTO 0);
	x, y, z : in std_logic;
   S : out std_logic_vector(SIZE-1 DOWNTO 0)
);
END COMPONENT;

SIGNAL Sreg : std_logic_vector(SIZE-1 DOWNTO 0);

BEGIN
	ula : ALU GENERIC MAP (SIZE => SIZE) PORT MAP (A => A, B => B, x => x, y => y, z => z, S => Sreg);
	PROCESS(clk)
	BEGIN
		IF (clk ' EVENT AND clk = '1' AND e = '1') THEN
			S <= Sreg;
		END IF;
	END PROCESS;
END main;

