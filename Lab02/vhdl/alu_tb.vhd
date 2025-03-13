library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.TEXTIO.ALL;

entity Alu_tb is
end Alu_tb;

architecture Behavioral of Alu_tb is
    signal Alu_op : STD_LOGIC_VECTOR(1 downto 0);
    signal Alu_A, Alu_B, Alu_R : STD_LOGIC_VECTOR(31 downto 0);
    signal Alu_Zero, Alu_Overflow, Alu_Cout : STD_LOGIC;

    constant AND_OP : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant OR_OP  : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant ADD_OP : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant SUB_OP : STD_LOGIC_VECTOR(1 downto 0) := "11";

    component Alu
        port (
            A       : in  STD_LOGIC_VECTOR(31 downto 0);
            B       : in  STD_LOGIC_VECTOR(31 downto 0);
            ALUCtl  : in  STD_LOGIC_VECTOR(1 downto 0);
            R       : out STD_LOGIC_VECTOR(31 downto 0);
            Zero    : out STD_LOGIC;
            Overflow: out STD_LOGIC;
            Cout    : out STD_LOGIC
        );
    end component;

begin
    U1: Alu port map (
        A        => Alu_A,
        B        => Alu_B,
        ALUCtl   => Alu_op,
        R        => Alu_R,
        Zero     => Alu_Zero,
        Overflow => Alu_Overflow,
        Cout     => Alu_Cout
    );

    process
    begin
        report "Inicio dos testes da ALU";

        -- Teste AND
        Alu_op <= AND_OP; Alu_A <= X"FFFFFFFF"; Alu_B <= X"0F0F0F0F";
        wait for 10 ns;
        report "AND Test" severity note;

        -- Teste OR
        Alu_op <= OR_OP; Alu_A <= X"00000000"; Alu_B <= X"F0F0F0F0";
        wait for 10 ns;
        report "OR Test" severity note;
        
        -- Teste ADD sem overflow
        Alu_op <= ADD_OP; Alu_A <= X"00000001"; Alu_B <= X"00000001";
        wait for 10 ns;
        report "ADD Test" severity note;
        
        -- Teste ADD com overflow
        Alu_op <= ADD_OP; Alu_A <= X"7FFFFFFF"; Alu_B <= X"00000001";
        wait for 10 ns;
        report "ADD Overflow Test" severity note;
        
        -- Teste SUB sem overflow
        Alu_op <= SUB_OP; Alu_A <= X"00000002"; Alu_B <= X"00000001";
        wait for 10 ns;
        report "SUB Test" severity note;
        
        -- Teste SUB com overflow
        Alu_op <= SUB_OP; Alu_A <= X"80000000"; Alu_B <= X"00000001";
        wait for 10 ns;
        report "SUB Overflow Test" severity note;
        
        -- Teste Zero flag
        Alu_op <= SUB_OP; Alu_A <= X"12345678"; Alu_B <= X"12345678";
        wait for 10 ns;
        report "Zero Flag Test" severity note;
        
        report "Fim dos testes";
        wait;
    end process;
end Behavioral;

