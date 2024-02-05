# Author: Éder Augusto Penharbel
.PHONY: clean image
all: image

# gerar arquivo floppy.img (um arquivo que corresponde ao disquete)
# o arquivo será preenchido com zero e terá o tamanho de um disquete
jogo.img:
	dd if=/dev/zero of=$@ bs=512 count=2880

# "compilar" o arquivo que contém os mnemônicos das instruções
compilationFiles/Bootloader.o: Bootloader.s
	as $< -o $@

# linkeditar para um binário de 16 bits com endereços relativos a 0x7c00
compilationFiles/Bootloader.bin: compilationFiles/Bootloader.o
	ld --Ttext 0x7c00 --oformat=binary compilationFiles/Bootloader.o -o compilationFiles/Bootloader.bin

# "compilar" o jogo
compilationFiles/jogo.o: jogo.s
	as $< -o $@

# linkeditar para um binário de 16 bits com endereços relativos a 0x7c00
compilationFiles/jogo.bin: compilationFiles/jogo.o
	ld --Ttext 0x7e00 --oformat=binary compilationFiles/jogo.o -o compilationFiles/jogo.bin

# copiar o arquivo binário executável para o arquivo floppy.img
# MAP HEX
#	000:200 	bootloader
#	200:400		parte_1
#	400:600		parte_2
#	600:800		parte_3
#	800:1200	numerosAleatorios		
image: compilationFiles/Bootloader.bin jogo.img compilationFiles/jogo.bin
	python3 Engine/compile.py
	dd if=compilationFiles/Bootloader.bin of=jogo.img bs=512 count=1 conv=notrunc
	dd if=compilationFiles/jogo_part_0.bin of=jogo.img bs=512 count=1 seek=1 conv=notrunc
	dd if=compilationFiles/jogo_part_1.bin of=jogo.img bs=512 count=1 seek=2 conv=notrunc
	dd if=compilationFiles/jogo_part_2.bin of=jogo.img bs=512 count=1 seek=3 conv=notrunc
	dd if=compilationFiles/jogo_part_3.bin of=jogo.img bs=512 count=1 seek=4 conv=notrunc
	dd if=compilationFiles/jogo_part_4.bin of=jogo.img bs=512 count=1 seek=5 conv=notrunc
	dd if=compilationFiles/numerosAleatorios.bin of=jogo.img bs=512 count=1 seek=6 conv=notrunc
	dd if=compilationFiles/fundo.bin of=jogo.img bs=512 count=1 seek=7 conv=notrunc
	python3 Engine/testes.py

# deletar arquivos 
clean:
	$(RM) -f jogo.img
	$(RM) -f compilationFiles/jogo.o
	$(RM) -f compilationFiles/jogo_part_0.bin
	$(RM) -f compilationFiles/jogo_part_1.bin
	$(RM) -f compilationFiles/jogo_part_2.bin
	$(RM) -f compilationFiles/jogo_part_3.bin
	$(RM) -f compilationFiles/jogo_part_4.bin
	$(RM) -f compilationFiles/jogo.bin
	$(RM) -f compilationFiles/Bootloader.o
	$(RM) -f compilationFiles/Bootloader.bin
	$(RM) -f compilationFiles/fundo.bin
	$(RM) -f compilationFiles/numerosAleatorios.bin
