library ieee;
USE ieee.std_logic_1164.all ;

ENTITY fullAdder IS
PORT(
  a, b, ci : in std_logic;
  c, co    : out std_logic
);
END fullAdder;

ARCHITECTURE main of fullAdder is
BEGIN
  c <= a xor b xor ci;
  co <= (b and ci) or (a and (b or ci));
END main;