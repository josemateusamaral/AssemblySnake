import random

def quebrarBinarioEmPartes():
    with open('compilationFiles/jogo.bin','rb') as fileBin:
        read = fileBin.read(512)
        counter = 0
        while read:
            with open('compilationFiles/jogo_part_' + str(counter) + '.bin','wb') as newFile:
                newFile.write(read)
                if len(read) < 512:
                    remaining_bytes = 512 - len(read)
                    newFile.write(b'\x00' * remaining_bytes)
                read = fileBin.read(512)
                counter += 1


def gerarNumerosAleatorios():
    numerosPossiveis = range(50,175)
    numerosAleatorios = []
    tamanho = 256
    for i in range(tamanho):
        while True:
            numerosAleatorio = random.choice(numerosPossiveis)
            if numerosAleatorio % 5 == 0:
                numerosAleatorios.append(numerosAleatorio)
                break

    with open('compilationFiles/numerosAleatorios.bin','wb') as file:
        #print('\n\nNumeros aleatorios:')
        for numero in numerosAleatorios:
            #print(numero)
            code_byte = numero.to_bytes(1, byteorder='big')
            file.write(code_byte)
        for i in range(512 - tamanho):
            numero = 0
            code_byte = numero.to_bytes(1, byteorder='big')
            file.write(code_byte)

def rgb_to_bios_color(rgb):
    r, g, b = rgb  # Ignoramos o canal Alpha
    # Mapeie as intensidades de R, G e B para a lista de cores da BIOS
    color_map = [
        (0, 0, 0),        # Black
        (0, 0, 170),      # Blue
        (0, 170, 0),      # Green
        (0, 170, 170),    # Cyan
        (170, 0, 0),      # Red
        (170, 0, 170),    # Magenta
        (170, 85, 0),     # Brown
        (170, 170, 170),  # Light Gray
        (85, 85, 85),     # Dark Gray
        (85, 85, 255),    # Light Blue
        (85, 255, 85),    # Light Green
        (85, 255, 255),   # Light Cyan
        (255, 85, 85),    # Light Red
        (255, 85, 255),   # Light Magenta
        (255, 255, 85),   # Yellow
        (255, 255, 255),  # White
    ]

    # Encontre a cor mais próxima nos valores mapeados
    min_distance = float('inf')
    closest_color = 0  # Por padrão, a cor mais próxima é preta
    for i, color in enumerate(color_map):
        distance = sum((a - b) ** 2 for a, b in zip((r, g, b), color))
        if distance < min_distance:
            min_distance = distance
            closest_color = i

    return closest_color

def converterImagemDeFundo():
    from PIL import Image
    imagem = Image.open("assets/fundo.png")
    dados_pixel = list(imagem.getdata())

    cores = []
    print(f'tamanho imagem: {len(dados_pixel)}')
    with open('compilationFiles/fundo.bin','wb') as file:
        for i in dados_pixel:
            code = rgb_to_bios_color(i)
            code_byte = code.to_bytes(1, byteorder='little')
            file.write(code_byte)
        if len(dados_pixel) < 512:
            remaining_bytes = 512 - len(dados_pixel)
            file.write(b'\x00' * remaining_bytes)
    with open('compilationFiles/fundo.bin','rb') as file:
        print(len(file.read()))

if __name__ == '__main__':
    quebrarBinarioEmPartes()
    converterImagemDeFundo()
    gerarNumerosAleatorios()