library ieee;
use ieee.std_logic_1164.all;

-- D Flip-Flop with synchronous reset and enable
-- Addapted from https://maia-eda.net/hdl-coding/flops/fdre

entity dff is
  port (clk, rst, en, d : std_logic := '0'; q : out std_logic :='0');
end dff;

architecture rtl of dff is

begin
process (clk, rst) begin
  if clk'event and clk = '1' then
    if rst='1' then
      q <= '0';
    elsif en='1' then
      q <= d;
    end if;
  end if;
end process;
end architecture;