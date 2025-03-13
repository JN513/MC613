library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2dec is
    port (
        bin : in  STD_LOGIC_VECTOR(3 downto 0);
        dec : out STD_LOGIC_VECTOR(6 downto 0)
    );
end bin2dec;

architecture Behavioral of bin2dec is
begin
    dec <= "0000001" when bin = "0000" else
           "1001111" when bin = "0001" else
           "0010010" when bin = "0010" else
           "0000110" when bin = "0011" else
           "1001100" when bin = "0100" else
           "0100100" when bin = "0101" else
           "0100000" when bin = "0110" else
           "0001111" when bin = "0111" else
           "0000000" when bin = "1000" else
           "0001100" when bin = "1001" else
           "0110000";
end Behavioral;

