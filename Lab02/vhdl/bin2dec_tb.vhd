LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY bin2dec_tb IS
END bin2dec_tb;

ARCHITECTURE testbench OF bin2dec_tb IS
    SIGNAL KEY : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL HEX0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL key_not : STD_LOGIC_VECTOR(3 DOWNTO 0);

    COMPONENT bin2dec
        PORT (
            bin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            dec : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
BEGIN
    U1: bin2dec PORT MAP (bin => KEY, dec => HEX0);
    
    key_not <= NOT KEY;
    
    PROCESS
    BEGIN
        FOR i IN 0 TO 15 LOOP
            KEY <= CONV_STD_LOGIC_VECTOR(i, 4);
            WAIT FOR 10 ns;
            
            REPORT "KEY = " & INTEGER'IMAGE(i) & ", HEX0 = " & INTEGER'IMAGE(CONV_INTEGER(HEX0));
            
            IF i > 9 THEN
                IF HEX0 /= "0110000" THEN
                    REPORT "Error: HEX0 = " & INTEGER'IMAGE(CONV_INTEGER(HEX0)) SEVERITY FAILURE;
                END IF;
            END IF;
        END LOOP;
        
        REPORT "Test completed successfully.";
        WAIT;
    END PROCESS;
END testbench;

