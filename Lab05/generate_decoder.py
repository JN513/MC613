def bcd_to_seven_segment(bcd):
    # Mapeamento dos dígitos hexadecimais (0-F) para os segmentos de um display de 7 segmentos
    mapping = {
        0x0: 0b1000000,  # 0
        0x1: 0b1111001,  # 1
        0x2: 0b0100100,  # 2
        0x3: 0b0110000,  # 3
        0x4: 0b0011001,  # 4
        0x5: 0b0010010,  # 5
        0x6: 0b0000010,  # 6
        0x7: 0b1111000,  # 7
        0x8: 0b0000000,  # 8
        0x9: 0b0010000,  # 9
    }
    
    if bcd in mapping:
        # Inverta os bits do número binário
        inverted_bits = mapping[bcd]
        return f"{bin(inverted_bits)[2:].zfill(7)}"
    else:
        return "Valor inválido!"

# Gera os casos de 0 a 99
for number in range(100):
    bcd_tens, bcd_units = divmod(number, 10)
    print(f"7'd{number}: begin bcd_tens =  7'b{bcd_to_seven_segment(bcd_tens)}; bcd_units =  7'b{bcd_to_seven_segment(bcd_units)}; end")