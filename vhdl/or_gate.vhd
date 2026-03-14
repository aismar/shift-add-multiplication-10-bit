library ieee;
use ieee.std_logic_1164.all;

entity or_gate is
  generic (n : integer := 2); -- number of inputs
  port (x : std_logic_vector(n-1 downto 0); y : out std_logic);
end or_gate;

architecture rtl of or_gate is
  signal temp : std_logic_vector(n-1 downto 0);
begin
  temp(0) <= x(0);
  gen_and:
  for i in 1 to n-1 generate
    temp(i) <= x(i) or temp(i-1);
  end generate;
  y <= temp(n-1);
end architecture;