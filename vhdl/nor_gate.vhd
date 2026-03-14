library ieee;
use ieee.std_logic_1164.all;

entity nor_gate is
  generic (n : integer := 2); -- number of inputs
  port (x : std_logic_vector(n-1 downto 0); y : out std_logic);
end nor_gate;

architecture rtl of nor_gate is
  signal temp : std_logic_vector(n-1 downto 0);
begin
  temp(0) <= x(0);
  gen_and:
  for i in 1 to n-1 generate
    temp(i) <= x(i) or temp(i-1);
  end generate;
  y <= not temp(n-1);
end architecture;