library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Alu is
    port (
        A       : in  STD_LOGIC_VECTOR(31 downto 0);
        B       : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUCtl  : in  STD_LOGIC_VECTOR(1 downto 0);
        R       : out STD_LOGIC_VECTOR(31 downto 0);
        Zero    : out STD_LOGIC;
        Overflow: out STD_LOGIC;
        Cout    : out STD_LOGIC
    );
end Alu;

architecture Behavioral of Alu is
    constant AND_OP : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant OR_OP  : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant ADD_OP : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant SUB_OP : STD_LOGIC_VECTOR(1 downto 0) := "11";
    
    signal R_internal : STD_LOGIC_VECTOR(31 downto 0);

begin
    process(A, B, ALUCtl)
    begin
        case ALUCtl is
            when AND_OP => R_internal <= A and B;
            when OR_OP  => R_internal <= A or B;
            when ADD_OP => R_internal <= A + B;
            when SUB_OP => R_internal <= A - B;
            when others => R_internal <= A + B;
        end case;
    end process;
    
    R <= R_internal;
    Zero <= '1' when R_internal = x"00000000" else '0';
    Overflow <= (A(31) and B(31) and not R_internal(31)) or (not A(31) and not B(31) and R_internal(31));
    Cout <= '1' when (ALUCtl = ADD_OP and R_internal(31) and B(31)) else '0';
    
end Behavioral;

