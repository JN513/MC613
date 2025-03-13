library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bin2hex_tb is
end bin2hex_tb;

architecture behavior of bin2hex_tb is

    signal KEY : std_logic_vector(3 downto 0);
    signal HEX0 : std_logic_vector(6 downto 0);
    signal key_not : std_logic_vector(3 downto 0);

    -- Componente bin2hex
    component bin2hex
        port (
            bin : in std_logic_vector(3 downto 0);
            hex : out std_logic_vector(6 downto 0)
        );
    end component;

begin
    -- Instanciação do bin2hex
    U1: bin2hex
        port map (
            bin => KEY,
            hex => HEX0
        );

    -- Process para simulação
    stim_proc: process
    begin
        -- Inicializando
        KEY <= "0000";

        -- Simulando o valor de KEY e mostrando o HEX0
        for i in 0 to 15 loop
            wait for 10 ns;
            KEY <= std_logic_vector(to_unsigned(i, 4));

            wait for 1 ns;

            -- Exibindo os valores de KEY e HEX0
            report "KEY = " & integer'image(to_integer(unsigned(KEY))) & ", HEX0 = " & std_logic_vector'image(HEX0);
        end loop;

        -- Finalizando a simulação
        wait;
    end process;

    -- Atribuição do sinal key_not
    key_not <= not KEY;

end behavior;

