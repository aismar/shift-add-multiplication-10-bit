library ieee;
use ieee.std_logic_1164.all;

entity sr_latch is
  port (set, rst : in std_logic := '0'; 
        q, q_bar : out std_logic
      );
end sr_latch;

architecture rtl of sr_latch is
begin
process (set, rst) begin
  if set='1' then
    q <= '1';
    q_bar <= '0';
  end if;
  if rst='1' then
    q <= '0';
    q_bar <= '1';
  end if;
end process;
end architecture;