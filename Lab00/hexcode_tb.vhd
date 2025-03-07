library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity hexcode_tb is
end entity hexcode_tb;

architecture tb of hexcode_tb is
  signal leds: std_logic_vector(9 downto 0);
  signal sw: std_logic_vector(9 downto 0) := (others => '0');
  signal hex: std_logic_vector(0 to 6);
  signal keys: std_logic_vector(3 downto 0) := (others => '0');
  
  signal clock: std_logic := '0';
  signal stop: std_logic;
begin

  uut: entity work.hexcode port map(LEDR => leds, SW => sw, HEX5 => hex, KEY => keys);
  
  clock <= not clock after 5 ns when stop = '0' else '0';
  stop <= '1' when sw = (sw'range => '1') and keys = (keys'range => '1') else '0';
  
  process(clock)
  begin
    if clock'event and clock = '1' and stop = '0' then
      sw <= std_logic_vector(to_unsigned(to_integer(unsigned(sw)) + 1, sw'length));
      keys <= std_logic_vector(to_unsigned(to_integer(unsigned(keys)) + 1, keys'length));
    end if;
  end process;
end architecture tb;
