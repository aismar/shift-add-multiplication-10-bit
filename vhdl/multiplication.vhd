library ieee;
use ieee.std_logic_1164.all;

entity multiplication is
  generic (n : integer := 10);
  port (clk, rst, mult_start : in std_logic;
        a, b: in std_logic_vector(n-1 downto 0);
       mult_ready : out std_logic;
       y : out std_logic_vector(2*n-1 downto 0) 
      ) ;
end multiplication;

architecture struct of multiplication is

  component mult_control
    generic (n : integer := 10); -- Width of multiplicands
    port (clk, mult_start : in std_logic; mult_ready, load_shift_bar : out std_logic);
  end component;

  component cpa
    generic (n : integer := 10);
    port (cin : in std_logic; a, b : in std_logic_vector(n-1 downto 0); cout : out std_logic; sum : out std_logic_vector(n-1 downto 0));
  end component;

  component dff
    port (clk, rst, en, d : std_logic; q : out std_logic);
  end component;

  component reg
    generic (n : integer := 10);
    port (clk, rst, en : in std_logic; d : in std_logic_vector(n-1 downto 0); q : out std_logic_vector(n-1 downto 0)) ;
  end component;

  component mux2to1
    port (in0, in1, sel : in std_logic; y : out std_logic);
  end component;

  signal load_shift_wire, cout_wire, done_wire, rst_wire, shift_en_wire : std_logic;
  signal b_wire, sum_wire, mux_wire: std_logic_vector(n-1 downto 0);
  signal partial_p_wire, load_wire, shift_wire, reg_wire : std_logic_vector(2*n-1 downto 0);

begin
  -- Conditions for reseting
  rst_gate : entity work.or_gate(rtl) port map(x(0) => rst, x(1) => done_wire, y => rst_wire);

  -- Controller unit
  control : entity work.mult_control(struct) generic map(n) port map(clk => clk, rst => rst_wire, mult_start => mult_start, mult_ready => done_wire, load_shift_bar => load_shift_wire);

  -- Hold a and partial product in the same 2n shift reg to conserve space
  -- As in Parhami p. 184 Fig. 9.5
  load_wire <= (2*n-1 downto n => '0') & a;
  shift_wire <= cout_wire & sum_wire & partial_p_wire(n-1 downto 1);
  select_a_shift:
  for i in 0 to 2*n-1 generate
    mux_i : entity work.mux2to1(rtl) port map(in0 => shift_wire(i), in1 => load_wire(i), sel => load_shift_wire, y => reg_wire(i));
  end generate;
  shift_en_gate : entity work.not_gate(rtl) port map(x => rst_wire, y => shift_en_wire);
  partial_product_reg : entity work.reg(struct) generic map(2*n) 
                        port map(clk => clk, rst => rst_wire, en => shift_en_wire, d => reg_wire, q => partial_p_wire);

  b_reg : entity work.reg(struct) generic map(n) port map(d => b, clk => clk, rst => rst_wire, en => load_shift_wire, q => b_wire);

  select_summand:
  for i in 0 to n-1 generate
    mux_sum_i : entity work.mux2to1(rtl) port map(in0 => '0', in1 => b_wire(i), sel => partial_p_wire(0), y => mux_wire(i));
  end generate;

  adder: entity work.cpa(struct) generic map(n) port map(cin => '0', a => partial_p_wire(2*n-1 downto n), b => mux_wire, cout => cout_wire, sum => sum_wire);

  y <= shift_wire;
  mult_ready <= done_wire;

end architecture;