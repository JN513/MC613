library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity two_comp_to_7seg is
    port (
        Number  : in  STD_LOGIC_VECTOR(31 downto 0);
        BCD     : out STD_LOGIC_VECTOR(6 downto 0);
        Signal  : out STD_LOGIC_VECTOR(6 downto 0)
    );
end two_comp_to_7seg;

architecture Behavioral of two_comp_to_7seg is
    signal is_neg   : STD_LOGIC;
    signal absolute : STD_LOGIC_VECTOR(31 downto 0);
    signal digit_0  : STD_LOGIC_VECTOR(3 downto 0);

    component bin2hex
        port (
            bin : in  STD_LOGIC_VECTOR(3 downto 0);
            hex : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

begin
    is_neg   <= Number(31);
    absolute <= (not Number + "00000000000000000000000000000001") when is_neg = '1' else Number;
    digit_0  <= absolute(3 downto 0);

    Signal <= "1001111" when is_neg = '1' else "0000001";

    U1: bin2hex port map (
        bin => digit_0,
        hex => BCD
    );

end Behavioral;

