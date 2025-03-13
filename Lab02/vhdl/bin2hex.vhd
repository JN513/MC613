library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2hex is
    port (
        bin : in  STD_LOGIC_VECTOR(3 downto 0);
        hex : out STD_LOGIC_VECTOR(6 downto 0)
    );
end bin2hex;

architecture Behavioral of bin2hex is
begin
    hex <= "0000001" when bin = "0000" else
           "1001111" when bin = "0001" else
           "0010010" when bin = "0010" else
           "0000110" when bin = "0011" else
           "1001100" when bin = "0100" else
           "0100100" when bin = "0101" else
           "0100000" when bin = "0110" else
           "0001111" when bin = "0111" else
           "0000000" when bin = "1000" else
           "0001100" when bin = "1001" else
           "0001000" when bin = "1010" else
           "1100000" when bin = "1011" else
           "0110001" when bin = "1100" else
           "1000010" when bin = "1101" else
           "0110000" when bin = "1110" else
           "0111000" when bin = "1111" else
           "1111111";
end Behavioral;

