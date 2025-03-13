library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_board is
    generic (
        CLK_FREQ : integer := 50000000
    );
    port (
        CLOCK_50 : in std_logic;
        SW       : in std_logic_vector(9 downto 0);
        LEDR     : out std_logic_vector(9 downto 0);
        KEY      : in std_logic_vector(3 downto 0);
        HEX0     : out std_logic_vector(6 downto 0)
    );
end entity fsm_board;

architecture Behavioral of fsm_board is
    constant DEBOUNCE_CYCLES : integer := CLK_FREQ / 8;
    
    signal rst, r50, r100, r200, cafe, t50, t100, t200 : std_logic;
    signal state_o : std_logic_vector(1 downto 0);
    
    signal debounce_counter1, debounce_counter2, debounce_counter3, debounce_counter4 : integer := 0;
    signal posedge_btn1, posedge_btn2, posedge_btn3, posedge_btn4 : std_logic;
    signal posedge_reg1, posedge_reg2, posedge_reg3, posedge_reg4 : std_logic_vector(2 downto 0) := "000";
    signal aux1, aux2, aux3, aux4 : std_logic;

begin
    process (CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            aux1 <= '0';
            aux2 <= '0';
            aux3 <= '0';
            aux4 <= '0';

            if debounce_counter1 >= DEBOUNCE_CYCLES then
                aux1 <= '1';
            end if;

            if debounce_counter2 >= DEBOUNCE_CYCLES then
                aux2 <= '1';
            end if;

            if debounce_counter3 >= DEBOUNCE_CYCLES then
                aux3 <= '1';
            end if;

            if debounce_counter4 >= DEBOUNCE_CYCLES then
                aux4 <= '1';
            end if;

            posedge_reg1 <= posedge_reg1(1 downto 0) & aux1;
            posedge_reg2 <= posedge_reg2(1 downto 0) & aux2;
            posedge_reg3 <= posedge_reg3(1 downto 0) & aux3;
            posedge_reg4 <= posedge_reg4(1 downto 0) & aux4;
        end if;
    end process;
    
    process (CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            if KEY(0) = '0' then
                debounce_counter1 <= debounce_counter1 + 1;
            else
                debounce_counter1 <= 0;
            end if;

            if KEY(1) = '0' then
                debounce_counter2 <= debounce_counter2 + 1;
            else
                debounce_counter2 <= 0;
            end if;

            if KEY(2) = '0' then
                debounce_counter3 <= debounce_counter3 + 1;
            else
                debounce_counter3 <= 0;
            end if;

            if KEY(3) = '0' then
                debounce_counter4 <= debounce_counter4 + 1;
            else
                debounce_counter4 <= 0;
            end if;
        end if;
    end process;

    FSM_inst : entity work.fsm
        generic map (CLK_FREQ => CLK_FREQ)
        port map (
            clk     => CLOCK_50,
            rst     => rst,
            r50     => r50,
            r100    => r100,
            r200    => r200,
            cafe    => cafe,
            t50     => t50,
            t100    => t100,
            t200    => t200,
            state_o => state_o
        );
    
    LEDR <= t200 & t100 & t50 & cafe & "0000" & state_o;
    posedge_btn1 <= '1' when posedge_reg1(2 downto 1) = "01" else '0';
    posedge_btn2 <= '1' when posedge_reg2(2 downto 1) = "01" else '0';
    posedge_btn3 <= '1' when posedge_reg3(2 downto 1) = "01" else '0';
    posedge_btn4 <= '1' when posedge_reg4(2 downto 1) = "01" else '0';
    
    r50  <= posedge_btn1;
    r100 <= posedge_btn2;
    r200 <= posedge_btn3;
    rst  <= posedge_btn4;

end architecture Behavioral;

