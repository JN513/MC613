library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity key2dec_tb is
end entity;

architecture testbench of key2dec_tb is

    signal KEY    : std_logic_vector(3 downto 0) := "0000";
    signal HEX0   : std_logic_vector(6 downto 0);
    signal key_not: std_logic_vector(3 downto 0);

    component key2dec
        port (
            KEY  : in  std_logic_vector(3 downto 0);
            HEX0 : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    U1: key2dec
        port map (
            KEY  => key_not,
            HEX0 => HEX0
        );

    key_not <= not KEY;

    process
    begin
        for i in 0 to 15 loop
            KEY <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
            report "KEY = " & integer'image(i) & ", HEX0 = " & integer'image(to_integer(unsigned(HEX0)));
            
            if i > 9 then
                if HEX0 /= "1111111" then
                    report "Error: HEX0 = " & integer'image(to_integer(unsigned(HEX0))) severity failure;
                end if;
            end if;
        end loop;
        
        report "Testbench finished" severity note;
        wait;
    end process;

end architecture;
