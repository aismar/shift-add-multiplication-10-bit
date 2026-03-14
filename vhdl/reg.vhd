library ieee;
use ieee.std_logic_1164.all;

entity reg is
  generic (n : integer := 10);
  port (clk, rst, en : in std_logic; d : in std_logic_vector(n-1 downto 0); q : out std_logic_vector(n-1 downto 0)) ;
end reg;

architecture struct of reg is
  component dff
    port (clk, rst, en, d : std_logic; q : out std_logic);
  end component; 
begin
  gen_reg:
  for i in 0 to n-1 generate
    dff_i : entity work.dff(rtl) port map(clk => clk, rst => rst, en => en, d => d(i), q => q(i));
  end generate;
end architecture;