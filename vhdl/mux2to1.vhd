library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
  port (in0, in1, sel : in std_logic; y : out std_logic);
end mux2to1;

architecture rtl of mux2to1 is
begin
  with sel select
  y <= in0 when '0',
       in1 when others;
end rtl;
