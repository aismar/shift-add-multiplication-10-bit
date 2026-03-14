library ieee;
use ieee.std_logic_1164.all;

-- Binary counter based on Fig. 11.49 b) from Weste-Harris (p. 465)

entity counter_nbit is
  generic (n : integer := 4);
  port (clk, rst, en : in std_logic; num : out std_logic_vector(n-1 downto 0)) ;
end counter_nbit;

architecture struct of counter_nbit is
  component dff
    port (clk, rst, en, d : std_logic; q : out std_logic);
  end component;

  signal d_wire, q_wire : std_logic_vector(n-1 downto 0);
  signal c_wire : std_logic_vector(n downto 0);

begin
  c_wire(0) <= '1';
  gen_ffs:
  for i in 0 to n-1 generate
    add_i : entity work.full_adder(rtl) port map(a => c_wire(i), b => q_wire(i), cin => '0', sum => d_wire(i), cout => c_wire(i+1));
    dff_i : entity work.dff(rtl) port map(clk => clk, rst => rst, en => en, d => d_wire(i), q => q_wire(i));
  end generate;
  num <= q_wire;
  
end architecture;