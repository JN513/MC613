library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_tb is
end entity fsm_tb;

architecture testbench of fsm_tb is
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal r50     : std_logic := '0';
    signal r100    : std_logic := '0';
    signal r200    : std_logic := '0';
    signal cafe    : std_logic;
    signal t50     : std_logic;
    signal t100    : std_logic;
    signal t200    : std_logic;
    signal state_o : std_logic_vector(1 downto 0);
    
    constant CLK_FREQ : integer := 2;
    constant FOUR_SECONDS : integer := CLK_FREQ * 4;
    
    component fsm
        generic (CLK_FREQ : integer);
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            r50     : in  std_logic;
            r100    : in  std_logic;
            r200    : in  std_logic;
            cafe    : out std_logic;
            t50     : out std_logic;
            t100    : out std_logic;
            t200    : out std_logic;
            state_o : out std_logic_vector(1 downto 0)
        );
    end component;
    
begin
    uut: fsm
        generic map (CLK_FREQ => CLK_FREQ)
        port map (
            clk  => clk,
            rst  => rst,
            r50  => r50,
            r100 => r100,
            r200 => r200,
            cafe => cafe,
            t50  => t50,
            t100 => t100,
            t200 => t200,
            state_o => state_o
        );
    
    process
    begin
        rst <= '1';
        wait for 4 ns;
        rst <= '0';
        
        -- Teste: Inserindo 250 sem troco
        wait for 4 ns; r100 <= '1'; wait for 2 ns; r100 <= '0';
        wait for 4 ns; r100 <= '1'; wait for 2 ns; r100 <= '0';
        wait for 4 ns; r50  <= '1'; wait for 2 ns; r50  <= '0';
        wait for 4 ns;
        
        assert cafe = '1' report "Erro: Cafe nao foi servido!" severity failure;
        assert (t50 = '0' and t100 = '0' and t200 = '0') report "Erro: Troco incorreto!" severity failure;
        assert state_o = "11" report "Erro: Estado incorreto, esperado DELAY!" severity failure;
        
        wait for (FOUR_SECONDS * 3 ns);
        assert state_o = "00" report "Erro: Nao retornou ao estado IDLE!" severity failure;
        
        -- Teste: Inserindo 300 (troco de 50)
        wait for 4 ns; r200 <= '1'; wait for 2 ns; r200 <= '0';
        wait for 4 ns; r100 <= '1'; wait for 2 ns; r100 <= '0';
        wait for 4 ns;
        
        assert cafe = '1' report "Erro: Cafe nao foi servido!" severity failure;
        assert t50 = '1' report "Erro: Troco incorreto!" severity failure;
        assert state_o = "11" report "Erro: Estado incorreto, esperado DELAY!" severity failure;
        
        wait for (FOUR_SECONDS * 4 ns);
        assert state_o = "00" report "Erro: Nao retornou ao estado IDLE!" severity failure;
        
        -- Teste: Inserindo 400 (troco de 150)
        wait for 4 ns; r200 <= '1'; wait for 2 ns; r200 <= '0';
        wait for 4 ns; r200 <= '1'; wait for 2 ns; r200 <= '0';
        wait for 4 ns;
        
        assert cafe = '1' report "Erro: Cafe nao foi servido!" severity failure;
        assert (t50 = '1' and t100 = '1') report "Erro: Troco incorreto!" severity failure;
        assert state_o = "11" report "Erro: Estado incorreto, esperado DELAY!" severity failure;
        
        wait for (FOUR_SECONDS * 4 ns);
        assert state_o = "00" report "Erro: Nao retornou ao estado IDLE!" severity failure;
        
        -- Teste: Inserindo valores inválidos e garantindo que não há café antes dos 250
        wait for 4 ns; r50 <= '1'; wait for 2 ns; r50 <= '0';
        wait for 4 ns;
        assert cafe = '0' report "Erro: Cafe servido antes do esperado!" severity failure;
        
        report "Testes finalizados com sucesso!" severity note;
        wait;
    end process;
    
    process
    begin
        wait for 1 ns;
        clk <= not clk;
    end process;

end architecture testbench;

