library ieee;
USE ieee.std_logic_1164.all ;

ENTITY comp1bit IS
PORT(
  a, b, in_lt, in_eq, in_gt : in std_logic;
  s_lt, s_eq, s_gt    : out std_logic
);
END comp1bit;

ARCHITECTURE main of comp1bit is
BEGIN
	s_lt <= in_lt OR ((NOT a) AND b AND in_eq);
	s_eq <= in_eq AND (a XNOR b);
	s_gt <= in_gt OR ((NOT b) AND a AND in_eq);
END main;