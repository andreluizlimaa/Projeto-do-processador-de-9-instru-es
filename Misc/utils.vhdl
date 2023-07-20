LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

package utils is
	constant BSIZE : INTEGER := 16;
	constant SSIZE : INTEGER := 4;
	constant PCSIZE : INTEGER := 16;
	constant ICSIZE: INTEGER := 16; --should be IRSIZE but i've misstyped it??
	
	type vecArray is array (natural range <>) of STD_LOGIC_VECTOR(BSIZE-1 DOWNTO 0);
end package utils;