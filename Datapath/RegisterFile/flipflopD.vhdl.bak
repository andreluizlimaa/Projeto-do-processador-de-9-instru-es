LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY flipflopD IS
PORT(D, clk, load  : in STD_LOGIC;
     Q, nQ : out STD_LOGIC);
END;

ARCHITECTURE main OF flipflopD IS
BEGIN
PROCESS(clk)
BEGIN
  IF(clk ' EVENT AND clk = '1' AND load = '1') THEN
    Q <= D;
    nQ <= NOT D;
  END IF;
END PROCESS;
END;