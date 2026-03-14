library ieee;
use ieee.std_logic_1164.all;

entity cpa is
  generic (n : integer := 10);
  port (cin : in std_logic; a, b : in std_logic_vector(n-1 downto 0); cout : out std_logic; sum : out std_logic_vector(n-1 downto 0));
end cpa;

architecture struct of cpa is
  component full_adder
    port(a, b, cin : in std_logic; sum, cout : out std_logic );
  end component;

  signal c_wire : std_logic_vector(n downto 0);
begin
  c_wire(0) <= cin;
  gen_add:
  for i in 0 to n-1 generate
    fa_i : entity work.full_adder(rtl) port map(a => a(i), b => b(i), cin => c_wire(i), cout => c_wire(i+1), sum => sum(i));
  end generate;
  cout <= c_wire(n);
end architecture;