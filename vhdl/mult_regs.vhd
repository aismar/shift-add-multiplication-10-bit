library ieee;
use ieee.std_logic_1164.all;

entity mult_regs is
  generic (n : integer := 10); -- Length of multiplicands
  port (clk, rst, mult_start : in std_logic; a, b : in std_logic_vector(n-1 downto 0); mult_ready : out std_logic; y : out std_logic_vector(2*n-1 downto 0));
end mult_regs;

architecture struct of mult_regs is
  
  component QD
    generic (n:integer:=4);
    port (q:in std_logic_vector(n-1 downto 0);
          clk,rst:in std_logic;
          d:out std_logic_vector(n-1 downto 0)
        );
  end component;

  component multiplication
    generic (n : integer := 10);
    port (clk, rst, mult_start : in std_logic;
          a, b: in std_logic_vector(n-1 downto 0);
        mult_ready : out std_logic;
        y : out std_logic_vector(2*n-1 downto 0) 
        ) ;
  end component; 

  signal start_wire, ready_wire : std_logic;
  signal a_wire, b_wire : std_logic_vector(n-1 downto 0);
  signal y_wire : std_logic_vector(2*n-1 downto 0);

begin

  a_reg : entity work.QD(rtl) generic map(n) port map(clk => clk, rst => rst, q => a, d => a_wire);
  b_reg : entity work.QD(rtl) generic map(n) port map(clk => clk, rst => rst, q => b, d => b_wire);
  start_reg : entity work.QD(rtl) generic map(1) port map(clk => clk, rst => rst, q(0) => mult_start, d(0) => start_wire);
  mult : entity work.multiplication(struct) generic map(n) port map(clk => clk, rst => rst, mult_start => start_wire, a => a_wire, b => b_wire, mult_ready => ready_wire, y => y_wire);
  y_reg : entity work.QD(rtl) generic map(2*n) port map(clk => clk, rst => rst, q => y_wire, d => y);
  done_reg : entity work.QD(rtl) generic map(1) port map(clk => clk, rst => rst, q(0) => ready_wire, d(0) => mult_ready);

end architecture;