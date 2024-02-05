renderMainMenu: # LOCAL
    pusha

    call clearScreen

    call renderFundo

    movb $11,%dl  # posicaoX
    movb $12,%dh  # posicaoY
    
    # Escrever Game Over 
    movb $'J',%al
    call imprimir
    inc %dl
    movb $'o',%al
    call imprimir
    inc %dl
    movb $'g',%al
    call imprimir
    inc %dl
    movb $'o',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'d',%al
    call imprimir
    inc %dl
    movb $'a',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'C',%al
    call imprimir
    inc %dl
    movb $'o',%al
    call imprimir
    inc %dl
    movb $'b',%al
    call imprimir
    inc %dl
    movb $'r',%al
    call imprimir
    inc %dl
    movb $'i',%al
    call imprimir
    inc %dl
    movb $'n',%al
    call imprimir
    inc %dl
    movb $'h',%al
    call imprimir
    inc %dl
    movb $'a',%al
    call imprimir

    # press start
    mov $13,%dl
    add $4,%dh
    movb $'a',%al
    call imprimir
    inc %dl
    movb $'p',%al
    call imprimir
    inc %dl
    movb $'e',%al
    call imprimir
    inc %dl
    movb $'r',%al
    call imprimir
    inc %dl
    movb $'t',%al
    call imprimir
    inc %dl
    movb $'e',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'e',%al
    call imprimir
    inc %dl
    movb $'n',%al
    call imprimir
    inc %dl
    movb $'t',%al
    call imprimir
    inc %dl
    movb $'e',%al
    call imprimir
    inc %dl
    movb $'r',%al
    call imprimir
    inc %dl


    # Escrever Score N
    mov $15,%dl
    add $5,%dh
    movb $'F',%al
    call imprimir
    inc %dl
    movb $'e',%al
    call imprimir
    inc %dl
    movb $'i',%al
    call imprimir
    inc %dl
    movb $'t',%al
    call imprimir
    inc %dl
    movb $'o',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'p',%al
    call imprimir
    inc %dl
    movb $'o',%al
    call imprimir
    inc %dl
    movb $'r',%al
    call imprimir
    inc %dl

    mov $10,%dl
    add $2,%dh
    movb $'J',%al
    call imprimir
    inc %dl
    movb $'o',%al
    call imprimir
    inc %dl
    movb $'s',%al
    call imprimir
    inc %dl
    movb $'e',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'M',%al
    call imprimir
    inc %dl
    movb $'a',%al
    call imprimir
    inc %dl
    movb $'t',%al
    call imprimir
    inc %dl
    movb $'e',%al
    call imprimir
    inc %dl
    movb $'u',%al
    call imprimir
    inc %dl
    movb $'s',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'A',%al
    call imprimir
    inc %dl
    movb $'m',%al
    call imprimir
    inc %dl
    movb $'a',%al
    call imprimir
    inc %dl
    movb $'r',%al
    call imprimir
    inc %dl
    movb $'a',%al
    call imprimir
    inc %dl
    movb $'l',%al
    call imprimir
    inc %dl

    end_renderMainMenu:
        popa
        ret

renderTelaDeMorte: # LOCAL
    pusha

    call clearScreen

    call renderFundo

    movb $15,%dl  # posicaoX
    movb $11,%dh  # posicaoY
    
    # Escrever Game Over 
    movb $'G',%al
    call imprimir
    inc %dl
    movb $'A',%al
    call imprimir
    inc %dl
    movb $'M',%al
    call imprimir
    inc %dl
    movb $'E',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'O',%al
    call imprimir
    inc %dl
    movb $'V',%al
    call imprimir
    inc %dl
    movb $'E',%al
    call imprimir
    inc %dl
    movb $'R',%al
    call imprimir
    inc %dl

    # Escrever [R] Restart
    mov $14,%dl
    add $3,%dh
    movb $'[',%al
    call imprimir
    inc %dl
    movb $'R',%al
    call imprimir
    inc %dl
    movb $']',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl
    movb $'R',%al
    call imprimir
    inc %dl
    movb $'E',%al
    call imprimir
    inc %dl
    movb $'S',%al
    call imprimir
    inc %dl
    movb $'T',%al
    call imprimir
    inc %dl
    movb $'A',%al
    call imprimir
    inc %dl
    movb $'R',%al
    call imprimir
    inc %dl
    movb $'T',%al
    call imprimir
    inc %dl

    # Escrever Score N
    mov $16,%dl
    add $3,%dh
    movb $'S',%al
    call imprimir
    inc %dl
    movb $'C',%al
    call imprimir
    inc %dl
    movb $'O',%al
    call imprimir
    inc %dl
    movb $'R',%al
    call imprimir
    inc %dl
    movb $'E',%al
    call imprimir
    inc %dl
    movb $' ',%al
    call imprimir
    inc %dl

    pushw %dx

    # call imprimirNumero
    call configDB
    add $9,%bx

    # verificar se o numero possui apenas um digito
    movb (%bx),%al
    cmp $10,%al
    jge maisDigitos_001
    
    umDigito_001:
        add $0x30,%al
        xor %ah,%ah
        popw %dx
        # movw $0x3410,%dx
        call imprimir
        jmp end_renderTelaMorte

    maisDigitos_001:
        movb $0,%cl
        loop_maisDigitos_001:
            inc %cl
            sub $10,%al
            cmp $10,%al
            jge maisDigitos_001
        
        popw %dx

        movb %al,%ah
        movb %cl,%al
        # movw $0x0603,%dx
        add $0x30,%al
        call imprimir

        movb %ah,%al
        inc %dl
        # movw $0x0604,%dx
        add $0x30,%al
        call imprimir

    end_renderTelaMorte:
        popa
        ret

render: # LOCAL
    pusha

    # verificar se a cobra esta viva
    call configDB
    add $8,%bx
    cmp $0,(%bx)
    je fimRenders

    # renderizar cabeca
    call renderHead

    # renderizar comida
    call renderFood

    # renderizar corpo
    call renderPartesDoCorpo

    fimRenders:
        popa
        ret

renderPartesDoCorpo: # LOCAL
    pusha
    # jmp fimRenders

    # verificar se ha partes para renderizar
    call configDB
    add $9,%bx
    movb (%bx),%al
    cmp $0,%al
    je fim_renderPartesDoCorpo

    # renderizer partes
    add $3,%bx
    sub $1,%al
    loop_renderPartesCorpo:

        movw (%bx),%cx
        add $2,%bx
        movw (%bx),%dx
        call renderParteCorpo

        # until
        add $2,%bx
        dec %al
        cmp $0,%al
        jg loop_renderPartesCorpo

    fim_renderPartesDoCorpo:
        popa
        ret

renderHead: # LOCAL
    pusha
    call jogarPosicaoDaRamParaOsRegistradores
    movb $0,%al
    movb $0,%ah
    movw %cx,%bx
    # Este loop serve para pintar os pixel da tela
    loop_desenho__03:
        call colorPixelHead
        inc %al
        inc %cx
        cmp $5,%al
        jne nao_ir_proximo_seguimento__03
        ir_proximo_seguimento__03:
            movb $0,%al
            inc %ah
            inc %dx
            movw %bx,%cx
        nao_ir_proximo_seguimento__03:
            cmp $5,%ah
            jne loop_desenho__03
    popa
    ret

renderFood: # LOCAL
    pusha
    
    call configDB
    xor %cx,%cx
    xor %dx,%dx

    add $5,%bx
    movb (%bx),%cl
    inc %bx
    movb (%bx),%dl

    xor %ax,%ax
    movw %cx,%bx
    # Este loop serve para pintar os pixel da tela
    loop_desenho__02:
        call colorPixelFood
        inc %al
        inc %cx
        cmp $5,%al
        jne nao_ir_proximo_seguimento__02
        ir_proximo_seguimento__02:
            movb $0,%al
            inc %ah
            inc %dx
            movw %bx,%cx
        nao_ir_proximo_seguimento__02:
            cmp $5,%ah
            jne loop_desenho__02
    popa
    ret

colorImagePixel:
    # pusha 

    call getPixelPointer
    popw %ax
    movb %al,(%bx)

    # popa
    ret

renderImagePixel: # LOCAL
    pusha

    movb $0,%al
    movb $0,%ah
    movw %cx,%bx
    # Este loop serve para pintar os pixel da tela

    renderThisImagePixel:
        loop_desenho__00321:
            call colorImagePixel
            inc %al
            inc %cx
            cmp $5,%al
            jne nao_ir_proximo_seguimento__00321
            ir_proximo_seguimento__00321:
                movb $0,%al
                inc %ah
                inc %dx
                movw %bx,%cx
            nao_ir_proximo_seguimento__00321:
                cmp $5,%ah
                jne loop_desenho__00321
    end_renderEmptyPixel_00321:
        popa
        ret

renderEmptyPixel: # LOCAL
    pusha

    # cmp $0,%cx
    # jne renderEsteEmptyPixel
    # 
    # cmp $0,%dx
    # je end_renderEmptyPixel


    movb $0,%al
    movb $0,%ah
    movw %cx,%bx
    # Este loop serve para pintar os pixel da tela

    renderEsteEmptyPixel:
        loop_desenho__007:
            call colorEmptyPixel
            inc %al
            inc %cx
            cmp $5,%al
            jne nao_ir_proximo_seguimento__007
            ir_proximo_seguimento__007:
                movb $0,%al
                inc %ah
                inc %dx
                movw %bx,%cx
            nao_ir_proximo_seguimento__007:
                cmp $5,%ah
                jne loop_desenho__007
    end_renderEmptyPixel:
        popa
        ret


renderParteCorpo: # LOCAL
    pusha

    # verificar se a posicao esta correta
    cmp $0,%cx
    jne desenharParteCorpo

    cmp $0,%dx
    je end_desenharParteCorpo


    desenharParteCorpo:
        movb $0,%al
        movb $0,%ah
        movw %cx,%bx
        # Este loop serve para pintar os pixel da tela
        loop_desenho_parteCorpo:
            pushw %ax
            call colorPixelBody
            popw %ax
            inc %al
            inc %cx
            cmp $5,%al
            jne nao_ir_proximo_seguimento__009
            ir_proximo_seguimento__009:
                movb $0,%al
                inc %ah
                inc %dx
                movw %bx,%cx
            nao_ir_proximo_seguimento__009:
                cmp $5,%ah
                jne loop_desenho_parteCorpo

    end_desenharParteCorpo:
        popa
        ret

getFlagComComida:
    # RET = ( AL = flagBool )
    call configDB
    add $11,%bx
    movb (%bx),%al
    ret


colorPixelBody: # LOCAL
    pusha
    # ARGS: CX = x , DX = y
    call getPixelPointer
    movb $0x9,(%bx)
    popa
    ret

colorPixelHead: # LOCAL
    pusha
    jmp naoMorrer
    # ARGS: CX = x , DX = y
    call configDB
    add $9,%bx
    movb (%bx),%al
    cmp $5,%al
    jl naoMorrer

    call getPixelPointer
    cmp $0x06,(%bx)
    je naoMorrer

    int $0x19

    naoMorrer:
    call getPixelPointer
    movb $0x2,(%bx)
    popa
    ret
    
colorPixelFood: # LOCAL
    pusha
    # ARGS: CX = x , DX = y
    call getPixelPointer
    movb $0x4,(%bx)
    popa
    ret

colorEmptyPixel:
    pusha
    # ARGS: CX = x , DX = y
    call getPixelPointer
    movb $0x6,(%bx)
    popa
    ret

printString:
    movb %dl,%ch
    printString_loop:
        # ARGS = ( cl = size )
        # movb $15,%dl  # posicaoX
        # movb $11,%dh  # posicaoY
        # movb $21,%cl
        popw %ax
        
        checarCaractereDePularLinha:
            cmp $0x0a,%al
            jne naoPrecisaPularLinha
            add $3,%dh
            movb %ch,%dl
            sub $2, %dl
        naoPrecisaPularLinha:

        call imprimir

        inc %dl
        dec %cl
        cmp $0,%cl
        jne printString_loop
    ret
