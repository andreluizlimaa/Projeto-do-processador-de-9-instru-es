library ieee;
USE ieee.std_logic_1164.all ;

ENTITY cinext IS
PORT(
  x, y, z : in std_logic;
  cin    : out std_logic
);
END cinext;

ARCHITECTURE main of cinext is
BEGIN
cin <= (not(x) and y and not(z));
END main;