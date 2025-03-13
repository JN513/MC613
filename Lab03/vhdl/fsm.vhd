library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm is
    generic (
        CLK_FREQ : integer := 50000000
    );
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
end entity fsm;

architecture Behavioral of fsm is
    constant FOUR_SECONDS : integer := CLK_FREQ * 4;

    type state_type is (IDLE, RECEIVE, TROCO, DELAY);
    signal state : state_type := IDLE;
    signal time_count : integer := 0;
    signal cafe_count : integer := 0;

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state      <= IDLE;
                cafe_count <= 0;
                time_count <= 0;
                cafe       <= '0';
                t50        <= '0';
                t100       <= '0';
                t200       <= '0';
            else
                case state is
                    when IDLE =>
                        cafe       <= '0';
                        t50        <= '0';
                        t100       <= '0';
                        t200       <= '0';
                        time_count <= 0;
                        
                        if r50 = '1' then
                            state      <= RECEIVE;
                            cafe_count <= cafe_count + 50;
                        elsif r100 = '1' then
                            state      <= RECEIVE;
                            cafe_count <= cafe_count + 100;
                        elsif r200 = '1' then
                            state      <= RECEIVE;
                            cafe_count <= cafe_count + 200;
                        end if;
                    
                    when RECEIVE =>
                        if cafe_count >= 250 then
                            state <= TROCO;
                        elsif r50 = '1' then
                            cafe_count <= cafe_count + 50;
                        elsif r100 = '1' then
                            cafe_count <= cafe_count + 100;
                        elsif r200 = '1' then
                            cafe_count <= cafe_count + 200;
                        end if;
                    
                    when TROCO =>
                        if cafe_count = 300 then
                            cafe <= '1';
                            t50  <= '1';
                        elsif cafe_count = 350 then
                            cafe <= '1';
                            t100 <= '1';
                        elsif cafe_count = 400 then
                            cafe <= '1';
                            t50  <= '1';
                            t100 <= '1';
                        end if;
                        
                        cafe       <= '1';
                        state      <= DELAY;
                        cafe_count <= 0;
                    
                    when DELAY =>
                        if time_count >= FOUR_SECONDS then
                            state <= IDLE;
                        else
                            time_count <= time_count + 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    state_o <= "00" when state = IDLE else
               "01" when state = RECEIVE else
               "10" when state = TROCO else
               "11";

end architecture Behavioral;

