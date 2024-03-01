.code16 			   
.text 				   
.globl _start

# MEMORY_MAP
# 0 = posicaoX cabeca
# 1 = ..
# 2 = posicaoY cabeca
# 3 = ..
# 4 = direcao ?> d:direita,a:esquerda,w:cima,s:baixo
# 5 = posicaoX comida
# 6 = posicaoY comida
# 7 = posicaoAleatoriaAtual
# 8 = FLAG vivo
# 9 = tamanho da cobra ?> n
# 10 = corTile
# 11 = FLAG comComida
# ...| (( ( n - 1 ) * 2 )) + 12 = posicaoX corpoParte[n]
#    | (( ( n - 1 ) * 2 )) + 13 = posicaoY corpoParte[n]
# numerosAleatorios = 100 : 150

# .data
# mensagem:
#     .asciz "Hello, World!\n"

_start:
    jmp _begin
    .include "Engine/os.s"
    .include "Engine/render.s"
    .include "Engine/imagens.s"
    

_begin:
    call InicializeGame
    call MainMenu

_end:
    hlt
    jmp _end





InicializeGame: # GLOBAL

    # configurar a posicao aleatoria atual
    call configDB
    add $9,%bx
    movb $0,(%bx)

    # adicionar comida inicial
    call AdicionarComida

    # iniciar o personagem na posicao (50,50)
    call configDB
    movw $100,(%bx) # 0 = posicaoX cabeca
    add $2, %bx
    movw $100,(%bx) # 1 = posicaoY cabeca

    # configurar o tamanho da cobra
    call configDB
    add $9,%bx
    movb $0,(%bx)

    # colocar a cobra vida
    call configDB
    add $8,%bx
    movb $1,(%bx)

    # ativar o modo de video
    call clearScreen
    call renderBordaMapa
    call atualizarDisplayPontuacao

    # configurar display score
    movw $0x0401,%dx
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

    ret


renderBordaMapa:
    pusha

    # pintar o fundo de branco
    movw $0,%cx
    movw $0,%dx

    loop_aqui:

        pularLinha:        
            cmp $320,%cx
            jne pintarBorda
            movw $0,%cx
            inc %dx    
        
        pintarBorda:
            cmp $50,%cx
            jl after_loop

            cmp $270,%cx
            jg after_loop


            cmp $20,%dx
            jl after_loop

            cmp $180,%dx
            jg after_loop

            call getPixelPointer
            movb $0x6,(%bx)
            
        after_loop:
            inc %cx
            cmp $200,%dx
            jne loop_aqui

    popa
    ret

MainMenu:
    call renderMainMenu
    MainMenuLoop:
        # verificar se a teclas no buffer para realizar a leitura
        movb $0x01, %ah 
        int $0x16
        jz end_MainMenuLoop  

        # ler a tecla e verificar se a tecla.
        # No caso de ser 'r', entao o jogo eh reiniciado
        movb $0x00,%ah
        int $0x16
        cmp $0x0d,%al
        jne end_MainMenuLoop
        
        # interrupcao para reiniciar a maquina
        # irestart Game
        call clearScreen
        call InicializeGame
        jmp Game

        end_MainMenuLoop:
            jmp MainMenuLoop

Game:
    
    # atualizar posicao
    call lerTeclado
    cmp $1,%dl
    jne naoReiniciar
    call clearScreen
    call InicializeGame
    naoReiniciar:

    call checarColisaoComComida
    call atualizarPosicao

    # checar colisoes mortais
    call checarColisoesMortais
    cmp $0,%al
    je Death
    
    # render
    call render
    call refresh_rate_delay
    jmp Game

Death:
    call renderTelaDeMorte
    # call clearScreen
    DeathLoop:

        # verificar se a teclas no buffer para realizar a leitura
        movb $0x01, %ah 
        int $0x16
        jz end_DeathLoop  

        # ler a tecla e verificar se a tecla.
        # No caso de ser 'r', entao o jogo eh reiniciado
        movb $0x00,%ah
        int $0x16
        cmp $'r',%al
        jne end_DeathLoop
        
        # interrupcao para reiniciar a maquina
        call clearScreen
        call InicializeGame
        jmp Game

        end_DeathLoop:
            jmp DeathLoop

checarColisoesMortais:

    call jogarPosicaoDaRamParaOsRegistradores
    jmp checarBordaEsquerda

    matar:
        call configDB
        add $8,%bx
        movb $0,(%bx)
        movb $0,%al

        jmp end_checarColisoesMortais

    # checar eixo X
    checarBordaEsquerda:
        cmp $50,%cx
        jl matar
    
    checarBordaDireita:
        cmp $270,%cx
        jg matar  

    checarBordaSuperior:
        cmp $20,%dx
        jl matar
    
    checarBordaInferior:
        cmp $180,%dx
        jg matar    

    jmp end_checarColisoesMortais

    checarColisaoComOCorpo:
        call configDB
        add $9,%bx
        movb (%bx),%al
        cmp $3,%al
        jl fimChecagemCorpo

        call configDB
        add $12,%bx
        add $6,%bx

        loop_checagem:
            checarCXdoCorpo:
                call jogarPosicaoDaRamParaOsRegistradores
                cmp (%bx),%cx
                jne loop_next

                add $2,%bx
                cmp (%bx),%dx
                sub $2,%bx
                jne loop_next
                jmp matar

            loop_next:
                add $4,%bx
                cmp $0,%al
                je fimChecagemCorpo
                dec %al
                jne loop_checagem
        
        fimChecagemCorpo:

    movb $1,%al

    end_checarColisoesMortais:
        ret

atualizarDisplayPontuacao: # LOCAL
    pusha
    
    # call imprimirNumero
    call configDB
    add $9,%bx

    # verificar se o numero possui apenas um digito
    movb (%bx),%al
    cmp $10,%al
    jge maisDigitos
    
    umDigito:
        add $0x30,%al
        xor %ah,%ah
        movw $0x0603,%dx
        call imprimir
        jmp end_atualizarDisplayPontuacao

    maisDigitos:
        movb $0,%cl
        loop_maisDigitos:
            inc %cl
            sub $10,%al
            cmp $10,%al
            jge maisDigitos
        
        movb %al,%ah
        movb %cl,%al
        movw $0x0603,%dx
        add $0x30,%al
        call imprimir

        movb %ah,%al
        movw $0x0604,%dx
        add $0x30,%al
        call imprimir

        jmp end_atualizarDisplayPontuacao
    
    end_atualizarDisplayPontuacao:
        popa
        ret

AdicionarComida: # LOCAL
    pusha
    
    
    call configDB
    add $5,%bx
    call genRandInt
    movb %ah,(%bx)
    inc %bx
    movb %ah,(%bx)
    
    # call configDB
    # add $6,%bx
    # call genRandInt
    # movb %ah,(%bx)
    
    popa
    ret

adicionarParteDoCorpo: # LOCAL
    pusha

    call configDB
    add $9,%bx
    inc (%bx)

    popa
    ret

atualizarPosicao: # GLOBAL
    pusha

    # verificar se precisa atualizar a tela
    call configDB
    add $8,%bx
    movb (%bx),%al
    cmp $0,%al
    je end_atualizarPosicao

    call ApagarRastro
    # 2 = direcao ?> d:direita,a:esquerda,w:cima,s:baixo0

    # colocar a direcao da cobra no registrados %al
    call jogarPosicaoDaRamParaOsRegistradores
    call configDB
    add $4,%bx
    movb (%bx),%al

    mover_direita:
        cmp $'d',%al
        jne mover_esquerda
        call AtualizarAsPartesDoCorpo
        add $5,%cx
        jmp end_atualizarPosicao

    mover_esquerda:
        cmp $'a',%al
        jne mover_baixo
        call AtualizarAsPartesDoCorpo
        sub $5,%cx
        jmp end_atualizarPosicao

    mover_baixo:
        cmp $'s',%al
        jne mover_cima
        call AtualizarAsPartesDoCorpo
        add $5,%dx
        jmp end_atualizarPosicao

    mover_cima:
        cmp $'w',%al
        jne end_atualizarPosicao
        call AtualizarAsPartesDoCorpo
        sub $5,%dx

    end_atualizarPosicao:
        call configDB
        movw %cx,(%bx)
        add $2,%bx
        movw %dx,(%bx)

    popa
    ret

AtualizarAsPartesDoCorpo: # LOCAL


    pusha

    # jmp end_AtualizarAsPartesDoCorpo

    # verificar se a partes do corpo para atualizar
    call configDB
    add $9,%bx
    movb (%bx),%al
    cmp $0,%al

    # ? O numero de partes do corpo eh igual a zero, entao 
    # nao ah a necessidade de atualizar nenhuma parte
    je end_AtualizarAsPartesDoCorpo

    # Existem partes do corpo para atualizar
    add $3,%bx
    
    loop_AtualizarAsPartesDoCorpo:

        # salvar a posicao da parte atual do corpo
        pushw (%bx) 
        add $2,%bx
        pushw (%bx)

        # substituir a posicao da parte atual pela parte anterior
        sub $2,%bx
        movw %cx,(%bx)
        add $2,%bx
        movw %dx,(%bx)

        # diminuir o contador de partes que precisam ser atualizadas.
        # obs: quando o contador chegar a zero o loop acabara
        dec %al
        add $2, %bx
        popw %dx
        popw %cx
        cmp $0,%al
        jne loop_AtualizarAsPartesDoCorpo

    movw %cx,(%bx)
    add $2,%bx
    movw %dx,(%bx)

    end_AtualizarAsPartesDoCorpo:
        popa
        ret

checarColisaoComComida: # LOCAL
    pusha

    call jogarPosicaoDaRamParaOsRegistradores
    call configDB
    
    # verificar o eixo X
    xor %ax,%ax
    add $5,%bx
    movb (%bx),%al
    cmp %ax,%cx
    jne fimChecarColisaoComAcomida

    # verificar o eixo Y
    xor %ax,%ax
    inc %bx
    movb (%bx),%al
    cmp %ax,%dx
    jne fimChecarColisaoComAcomida

    # > comer a comida
    call AdicionarComida
    call adicionarParteDoCorpo
    call atualizarDisplayPontuacao

    fimChecarColisaoComAcomida:
        popa
        ret

ApagarRastro: # LOCAL
    pusha
    # jmp end_apagarRastro

    # verificar se o rastro esta no rabo ou na cabeca
    call configDB
    add $9,%bx
    movb (%bx),%al
    cmp $0,%al
    jne init_com_pedacoes

    # restro na cabeca
    sem_pedacos:
        call jogarPosicaoDaRamParaOsRegistradores
        call renderEmptyPixel
        jmp end_apagarRastro

    # rastro no rabo
    init_com_pedacoes:
        pushw %ax
        call configDB
        popw %ax
        add $12,%bx
        com_pedacos:
            dec %al
            movw (%bx),%cx
            add $2,%bx
            movw (%bx),%dx
            add $2, %bx
            cmp $0,%al
            jg com_pedacos
    
        call renderEmptyPixel

    end_apagarRastro:
        popa
        ret