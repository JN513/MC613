-- 1) Por ser um testbench ela e responsavel por gerar os sinais de entrada e analisar a saida do circuito, assim não e necessario entradas e saidas
-- 2) A instanciação e feita dentro da arquitetura, e os sinais de entrada e saida são mapeados/conectados para sinais da entidade, e utilizado uut para dizer que e a unidade sob teste.
-- Não e utilizada um pacote vhdl porque a entidade e estanciada diretamente como um componente do projeto
-- 3) A palavra work refere-se  à biblioteca de trabalho, que contém todas as entidades compiladas do projeto.
-- 4) Os pacotes std_logic_unsigned e numeric_std são utilizados para as operações aritimeticas e conversão de dados.
-- 5) range retorna o intervalo de indices do vetor, nesse caso ele e utilizado para verificar se todos os bits de sw sào iguais a 1, 
-- length retorna o tamanho do vetor ( numero total de bits), ele está sendo utilizado para garantir que a conversão em to_unsigned mantenha a quantidade de bits do vetor, 
-- event retorna true quando acontece uma transição no sinal, como uma borda de subida ou decida, no codigo ele e utilizado para monitorar as subidas do clock, essa implementação podia ser substituida por if rising_edge(clock) then que e mais clean e elegante
-- 6) sw começa em 0000000000 e incrementa até 1111111111. keys começa em 0000 e incrementa até 1111.
-- 7) Os valores de ledr e hex5 irão mudar de acordo com o valor de sw e keys, respectivamente.
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity hexcode_tb is
end entity hexcode_tb;

architecture tb of hexcode_tb is
	signal leds: std_logic_vector(9 downto 0);
	signal sw: std_logic_vector(9 downto 0) := (others => '0');
	signal hex: std_logic_vector(0 to 6);
	signal keys: std_logic_vector(3 downto 0) := (others => '0');
	
	signal clock: std_logic := '0';
	signal stop: std_logic;
begin

	uut: entity work.hexcode port map(LEDR => leds, SW => sw, HEX5 => hex, KEY => keys);
	
	clock <= not clock after 5 ns when stop = '0' else '0';
	stop <= '1' when sw = (sw'range => '1') and keys = (keys'range => '1') else '0';
	
	process(clock)
	begin
		if clock'event and clock = '1' and stop = '0' then
			sw <= std_logic_vector(to_unsigned(to_integer(unsigned(sw)) + 1, sw'length));
			keys <= std_logic_vector(to_unsigned(to_integer(unsigned(keys)) + 1, keys'length));
		end if;
	end process;
end architecture tb;
