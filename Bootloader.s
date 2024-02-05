.code16 	
.text 				   
.globl _start

# CH	Cylinder
# CL	Sector
# DH	Head
# DL	Drive
# ES:BX	Buffer Address Pointer

_start:
    movw $0x00,%ax
    mov %ax,%es
    movw $0x0209,%ax   # Função de leitura do disco
    movw $0x7e00,%bx   # Endereço de destino na memória
    movw $0x0002,%cx   # Tamanho do segundo estágio em setores (512 bytes)
    movw $0x0000,%dx   # Número do setor onde o segundo estágio está no disco
    movb $0x02,%ah     
    int $0x13          # Chamada BIOS para leitura de disco
    jmp 0x7e00

final:
    hlt
    jmp final

# Move to the 510th byte from 0 pos
. = _start + 510
# MBR boot signature
.byte 0x55
# MBR boot signature
.byte 0xaa	  


