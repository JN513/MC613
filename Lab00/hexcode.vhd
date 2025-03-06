-- Aos Switchs, leds, display de 7 segmentos e os botoes
-- 
-- O codigo em 7 segmentos de um digito em hexadecimal
-- LEDR tera os mesmo valor de SW , ja HEX5 tera um valor com base na saida do decodificador implementado
-- ao ligar um switch o led de mesmo numero devera ser acesso, e ao apertar os botoes o valor em hex sera mostrado em um display de 7 segmentos
library ieee;
use ieee.std_logic_1164.all;

entity hexcode is
port (
  LEDR: out std_logic_vector(9 downto 0);
  SW: in std_logic_vector(9 downto 0);
  HEX5: out std_logic_vector(0 to 6);
  KEY: in std_logic_vector(3 downto 0)
  );
end entity hexcode;

architecture bhv of hexcode is
begin

  LEDR <= SW;
  
  with KEY select
  HEX5 <= "0000001" when "0000",
      "1001111" when "0001",
      "0010010" when "0010",
      "0000110" when "0011",
      "1001100" when "0100",
      "0100100" when "0101",
      "0100000" when "0110",
      "0001111" when "0111",
      "0000000" when "1000",
      "0000100" when "1001",
      "0001000" when "1010",
      "1100000" when "1011",
      "0110001" when "1100",
      "1000010" when "1101",
      "0110000" when "1110",
      "0111000" when "1111",
      "1111111" when others;

end architecture bhv;
Copy