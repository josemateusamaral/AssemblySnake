refresh_rate_delay: # LOCAL
    # OBS: Esta funcao so eh retornada quando se passa um segundo apos ela ser chamada
    pusha
    movw $5, %cx      # Coloque 1000 no registrador CX (equivalente a 1 segundo)
    movw $0, %dx         # Coloque 0 no registrador DX (parte alta do intervalo)
    movw $0x8600, %ax    # Configurar AH=0x86 (esperar por um intervalo) e AL=0x00 (modo padrão)
    int $0x15  
    popa
    ret

getPixelPointer: # GLOBAL

    pushw %ax
    pushw %cx
    pushw %dx

    # mudar o mapeamento de memoria para o modo de video
    movw $0xa000,%ax
    movw %ax,%ds

    # localizar a posicao do pixel (x,y) na memoria de video e armazenar no %bx
    movw $0x140,%ax
    movw $0x000,%bx
    mulw %dx
    addw %cx,%ax
    movw %ax,%bx

    popw %dx
    popw %cx
    popw %ax

    # colocar a cor desejada no pixel na memoria de video
    ret

clearScreen: # LOCAL
    pusha
    movb $0x13,%al
    movb $0x00,%ah
    int $0x10
    popa
    ret

imprimir: # LOCAL
    # ARGS = ( DH = linha , DL = coluna )
    pusha
    # movb $0,%bh
    movb $2,%ah
    int $0x10

    # add $0x30,%al
    movb $0x0e, %ah
    int $0x10
    popa
    ret



configDB: # GLOBAL

    pushw %ax
    movw $0x1000,%ax
    movw %ax,%ds
    movw $0x00,%bx
    popw %ax
    ret

imprimirNumero: # LOCAL
    # ARGS = AX:Numero
    pusha
    
    # zerar todos os registradores
    xor %ebx,%ebx
    xor %ecx,%ecx
    xor %edx,%edx

    # configurar o cx pois ele eh usado na decomposicao do numero
    movw $1,%cx
    movw $10,%dx
    movw $1,%bx
    fillStack:
        pushw %cx
        imul %dx,%cx
        inc %bx
        cmp $5,%bx
        jne fillStack
    configCX:
        popw %cx
        cmpw %cx,%ax
        jg q0
        jmp configCX

    q0:

        movw $10,%bx
        imul %bx,%cx

        # zerar dx devido a dx fazer parte da conta
        mov $0, %dx
        # Dividir o numero/resto
        div %cx
        # empilhar o resto
        pushw %dx

        add $0x30, %al
        movb $0xe, %ah

        # zerar dx devido a dx fazer parte da conta
        mov $0, %dx

        # mover potencia para ax
        movw %cx, %ax
        # Calcular nova potencia
        div %bx
        # armazenar nova potencia em cx
        movw %ax, %cx

        # restaurar resto para ax
        popw %ax
        # comparar se o numero e zero
        cmp $0, %ax
        je fimloop
        
        cmp $'0',%al
        je q0

    q1:

        # zerar dx devido a dx fazer parte da conta
        mov $0, %dx
        # Dividir o numero/resto
        div %cx
        # empilhar o resto
        pushw %dx

        # Converter para ascii
        add $0x30, %al

        # imprimir
        movb $0xe, %ah
        int $0x10

        # zerar dx devido a dx fazer parte da conta
        mov $0, %dx

        # mover potencia para ax
        movw %cx, %ax
        # Calcular nova potencia
        div %bx
        # armazenar nova potencia em cx
        
        movw %ax, %cx

        # restaurar resto para ax
        popw %ax
        # comparar se o numero e zero
        cmp $0, %ax
        
        jmp q1

    fimloop:
        popa
        ret

lerTeclado: # LOCAL
    # 2 = direcao ?> d:direita,a:esquerda,w:cima,s:baixo
    
    movb %al,%cl
    movb $0,%dl

    # chamar interrupcao para armazenar tecla pressionada no registrador %al
    movb $0x01, %ah  # Subfunção 0x01 para verificar se uma tecla está disponível
    int $0x16

    jz end_lerTeclado  

    movb $0x00, %ah
    int $0x16

    jmp checarTecla

    armazenarTeclaPressionada:
        # salvar tecla pressionada na posicao 2 do RAM
        call configDB
        add $4,%bx
        movb %al,(%bx)
        jmp end_lerTeclado

    reiniciarJogo:
        movb $1,%dl
        # int $0x19
        jmp end_lerTeclado

    checarTecla:
        cmp $'w',%al
        je armazenarTeclaPressionada   
        cmp $'s',%al
        je armazenarTeclaPressionada
        cmp $'a',%al
        je armazenarTeclaPressionada
        cmp $'d',%al
        je armazenarTeclaPressionada
        cmp $'r',%al
        je reiniciarJogo

    end_lerTeclado:
        call cleanKeyboarBuffer
        ret

jogarPosicaoDaRamParaOsRegistradores: # GLOBAL
    pushw %ax
    pushw %bx

    call configDB
    xor %cx,%cx
    xor %dx,%dx
    movw (%bx),%cx # posicaoX
    add $2, %bx
    movw (%bx),%dx # posicaoY
    
    popw %bx
    popw %ax
    
    ret

cleanKeyboarBuffer:
    pusha

    clean_loop: 
    
        # chamar interrupcao para armazenar tecla pressionada no registrador %al
        movb $0x01, %ah  # Subfunção 0x01 para verificar se uma tecla está disponível
        int $0x16

        jz end_cleanKeyboardBuffer  

        movb $0x00, %ah
        int $0x16

        jmp clean_loop

    end_cleanKeyboardBuffer:
        popa
        ret

genRandInt: # GLOBAL

    pushw %bx
    pushw %cx
    pushw %dx

    # pegar a posicao do numero aleatorio atual
    call configDB
    add $7,%bx
    movb (%bx),%al

    # colocar o numero aleatorio no ax
    call configDB_randInt
    xor %ah,%ah
    add %ax,%bx
    movb (%bx),%ah

    # zero randIntCounter
    cmp $200,%al
    jne end_getRandInt

    call configDB
    add $7,%bx
    movb $0,%al
    movb %al,(%bx)

    end_getRandInt:

        # mudar a posicao do numero aleatorio
        call configDB
        add $7,%bx
        inc (%bx)

        popw %dx
        popw %cx
        popw %bx
        ret

configDB_randInt:
    pushw %ax
    movw $0,%ax
    movw %ax,%ds
    movw $0x8800,%bx
    popw %ax
    ret
    
configImagem:
    pushw %ax
    movw $0,%ax
    movw %ax,%ds
    movw $0x8a00,%bx
    popw %ax
    ret