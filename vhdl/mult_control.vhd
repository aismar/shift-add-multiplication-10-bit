library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

-- Control circuit for the shift/add multiplier
-- Takes a clock input that is passed to the internal counter and a signal to start multiplication
-- Generates a signal when counter reaches target <=> multiplication is done

entity mult_control is
  generic (n : integer := 10); -- Width of multiplicands
  port (clk, rst, mult_start : in std_logic; mult_ready, load_shift_bar : out std_logic);
end mult_control ;

architecture struct of mult_control is

  -- Counter is used to keep track of how many shift operations are needed
  component counter_nbit
    generic (n : integer := 4);
    port (clk, rst, en : in std_logic; num : out std_logic_vector(n-1 downto 0)) ;
  end component;

  component and_gate
    generic (n : integer := 2);
    port (x : in std_logic_vector(n-1 downto 0); y : out std_logic) ;
  end component;

  component not_gate
    port (x : in std_logic; y: out std_logic);
  end component;

  component sr_latch
    port (set, rst : in std_logic := '0'; 
          q, q_bar : out std_logic
        );
  end component;

  constant counter_bits : integer:= integer(ceil(log2(real(n) + real(1)))); --https://stackoverflow.com/a/12757674
  constant num_mask : std_logic_vector(counter_bits-1 downto 0) := std_logic_vector(to_unsigned(n, counter_bits)); -- Which bits need to be inverted
  
  signal num_wire, and_wire : std_logic_vector(counter_bits-1 downto 0) := (counter_bits-1 downto 0 => '0');
  signal en_wire, done_wire : std_logic := '0';

begin
  start_latch : entity work.sr_latch(rtl) port map(set => mult_start, rst => rst, q => en_wire, q_bar => open);
  counter : entity work.counter_nbit(struct) generic map (n => counter_bits) port map(clk => clk, rst => rst, en => en_wire, num => num_wire);

  -- On first cycle, perform load operations
  load_shift_gate : entity work.nor_gate(rtl) generic map(counter_bits) port map(x => num_wire, y => load_shift_bar);

  -- Which counter outputs need inverting before AND
  gen_and:
  for i in 0 to counter_bits-1 generate
    gen_inv:
    if num_mask(i)='0' generate
      inv_i : entity work.not_gate(rtl) port map(x => num_wire(i), y => and_wire(i));
    end generate;
    gen_direct:
    if num_mask(i)='1' generate
      and_wire(i) <= num_wire(i);
    end generate;
  end generate;

  -- Generate done signal once target is reached
  done : entity work.and_gate(rtl) generic map(counter_bits) port map(x => and_wire, y => done_wire);
  
  mult_ready <= done_wire;

end architecture;
