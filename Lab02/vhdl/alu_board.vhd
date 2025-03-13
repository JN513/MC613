library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_board is
    port (
        CLOCK_50 : in  STD_LOGIC;
        SW       : in  STD_LOGIC_VECTOR(9 downto 0);
        LEDR     : out STD_LOGIC_VECTOR(9 downto 0);
        KEY      : in  STD_LOGIC_VECTOR(3 downto 0);
        HEX0     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX1     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX2     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX3     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX4     : out STD_LOGIC_VECTOR(6 downto 0);
        HEX5     : out STD_LOGIC_VECTOR(6 downto 0)
    );
end alu_board;

architecture Behavioral of alu_board is
    signal Number_A, Number_B, Result : STD_LOGIC_VECTOR(31 downto 0);
    signal Alu_op : STD_LOGIC_VECTOR(1 downto 0);
    signal Alu_Zero, Alu_Overflow, Alu_Cout : STD_LOGIC;

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

    component two_comp_to_7seg
        port (
            Number : in  STD_LOGIC_VECTOR(31 downto 0);
            BCD    : out STD_LOGIC_VECTOR(6 downto 0);
            Signal : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

begin
    Alu_op   <= SW(9 downto 8);
    Number_A <= (others => SW(7)) & SW(7 downto 4);
    Number_B <= (others => SW(3)) & SW(3 downto 0);

    A1: two_comp_to_7seg port map (
        Number => Number_A,
        BCD    => HEX4,
        Signal => HEX5
    );

    B1: two_comp_to_7seg port map (
        Number => Number_B,
        BCD    => HEX2,
        Signal => HEX3
    );

    R1: two_comp_to_7seg port map (
        Number => Result,
        BCD    => HEX0,
        Signal => HEX1
    );

    ALU_inst: Alu port map (
        A        => Number_A,
        B        => Number_B,
        ALUCtl   => Alu_op,
        R        => Result,
        Zero     => Alu_Zero,
        Overflow => Alu_Overflow,
        Cout     => Alu_Cout
    );

    LEDR(0) <= Alu_Zero;
    LEDR(1) <= Alu_Overflow;
    LEDR(2) <= Alu_Cout;
    LEDR(9 downto 3) <= "0000000";

end Behavioral;
