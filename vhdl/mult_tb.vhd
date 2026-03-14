library ieee;
use ieee.std_logic_1164.all;

entity mult_tb is
end mult_tb;

architecture test of mult_tb is
  component mult_regs
    generic (n : integer := 10); -- Length of multiplicands
    port (clk, rst, mult_start : in std_logic; a, b : in std_logic_vector(n-1 downto 0);
	  mult_ready : out std_logic; y : out std_logic_vector(2*n-1 downto 0));
  end component;

  constant n : integer := 10;
  constant period : TIME := 200 ps;
  signal clk, mult_start, mult_ready : std_logic := '0';
  signal rst : std_logic := '1';
  signal a, b : std_logic_vector(n-1 downto 0);
  signal y : std_logic_vector(2*n-1 downto 0);

begin
  UUT : entity work.mult_regs(struct) generic map(n) port map(clk => clk, rst => rst,
	mult_start => mult_start, a => a, b => b, mult_ready => mult_ready, y => y);

  clock : process begin
    clk <= '0';
    wait for (period/2);
    clk <= '1';
    wait for (period/2);
  end process;
  
  stimulus : process begin
    rst <= '1';
    wait for (period/2);
    rst <= '0';
    a <= "0010000101";
    b <= "0000100100";
    mult_start <= '1';
    wait for ((n+2)*period);
  end process;


end architecture ; -- test