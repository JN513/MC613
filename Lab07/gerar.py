import random
import sys

def gerar_mem_hex(n_linhas, nome_arquivo="mem.hex"):
    with open(nome_arquivo, "w") as f:
        for _ in range(n_linhas):
            valor = random.getrandbits(32)
            f.write(f"{valor:08X}\n")  # 8 dígitos em maiúsculo
    print(f"Gerado '{nome_arquivo}' com {n_linhas} linhas.")

if __name__ == "__main__":
    if len(sys.argv) != 2 or not sys.argv[1].isdigit():
        print("Uso: python gerar_mem_hex.py <numero_de_linhas>")
        sys.exit(1)

    num_linhas = int(sys.argv[1])
    gerar_mem_hex(num_linhas)
