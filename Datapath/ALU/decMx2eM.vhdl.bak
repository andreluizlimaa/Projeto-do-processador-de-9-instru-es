library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY decMx2eM IS
GENERIC(
	SIZE : INTEGER := 3
);
PORT(
  sel : in std_logic_vector(SIZE-1 DOWNTO 0);
  e : in std_logic;
  S : out std_logic_vector((2**SIZE)-1 DOWNTO 0)
);
END decMx2eM;

ARCHITECTURE main of decMx2eM is
BEGIN
	PROCESS(sel,e)
	BEGIN
		dec: for i in 0 to (2**SIZE)-1 loop
			if ((i = to_integer(unsigned(sel))) AND e = '1') then
				S(i) <= '1';
			else
				S(i) <= '0';
			end if;
		end loop dec;
	END PROCESS;
END main;