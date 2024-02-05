# Resultados possiveis para os testes
def fail():
    import subprocess
    import tkinter as tk
    from tkinter import messagebox
    root = tk.Tk()
    root.withdraw()
    messagebox.showinfo("Alerta","Ocorreu um erro na compilacao do arquivo jogo.img")
    root.destroy()
def sucess():
    import subprocess
    import tkinter as tk
    from tkinter import messagebox
    root = tk.Tk()
    root.withdraw()
    messagebox.showinfo("Alerta","O arquivo jogo.img foi compilado com sucesso")
    root.destroy()

# Verificar se o arquivo jogo.img foi compilado com as partes corretas do arquivo jogo.bin
def teste_0():
    tamanhoEsperado = 5
    tamanhoAtual = 0
    import os
    compilationFiles = os.listdir('compilationFiles')
    for nomeArquivo in compilationFiles:
        if 'jogo_part_' in nomeArquivo:
            tamanhoAtual += 1
    return ( tamanhoAtual == tamanhoEsperado )

# rodar os teste
if __name__ == '__main__':

    testes_to_run = [
        teste_0
    ]
    ok = True
    for i in testes_to_run:
        teste = i()
        if not teste:
            ok = False
            break
    if ok:
        pass
        #sucess()
    else:
        fail()
        

