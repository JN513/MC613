library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity key2dec is
    port (
        KEY  : in  std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(6 downto 0)
    );
end entity key2dec;

architecture behavioral of key2dec is
begin
    process(KEY)
    begin
        case KEY is
            when "0000" => HEX0 <= "0000001"; -- 0
            when "0001" => HEX0 <= "1001111"; -- 1
            when "0010" => HEX0 <= "0010010"; -- 2
            when "0011" => HEX0 <= "0000110"; -- 3
            when "0100" => HEX0 <= "1001100"; -- 4
            when "0101" => HEX0 <= "0100100"; -- 5
            when "0110" => HEX0 <= "0100000"; -- 6
            when "0111" => HEX0 <= "0001111"; -- 7
            when "1000" => HEX0 <= "0000000"; -- 8
            when "1001" => HEX0 <= "0000100"; -- 9
            when others => HEX0 <= "1111111"; -- default
        end case;
    end process;
end architecture behavioral;
