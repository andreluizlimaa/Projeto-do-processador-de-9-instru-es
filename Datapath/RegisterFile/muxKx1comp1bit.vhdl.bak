LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.utils.all;

ENTITY muxKx1comp1bit IS
GENERIC(
	SSIZE : INTEGER := 2
);
PORT(
	I : IN vecArray((2**SSIZE)-1 DOWNTO 0);
	sel : IN STD_LOGIC_VECTOR(SSIZE-1 DOWNTO 0);
	S : OUT STD_LOGIC_VECTOR(BSIZE-1 DOWNTO 0)
	);
END;
ARCHITECTURE main OF muxKx1comp1bit IS
BEGIN
PROCESS(sel)
BEGIN
	S <= I(to_integer(unsigned(sel)));
END PROCESS;
END ARCHITECTURE main;