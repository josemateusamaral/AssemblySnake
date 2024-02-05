renderFundo:
    pusha

    # colocar pixel da imagem na stack
    call configImagem
    add $400,%bx
    movw $0,%ax
    loop_stackImage:
        movb (%bx),%cl
        pushw %cx
        dec %bx
        inc %ax
        cmp $400,%ax
        jne loop_stackImage

    # render imagem from stack
    movw $0,%cx
    movw $420,%dx
    
    loop_renderFundo:

        call getPixelPointer
        popw %ax
        call render_ImagePixel

        add $5,%cx
        cmp $100,%cx
        jl fim_loop_renderFundo

        proximaLinha:
            add $5,%dx
            xor %cx,%cx

        fim_loop_renderFundo:
            cmp $520,%dx
            jl loop_renderFundo
      
    fim_renderFundo:
        popa
        ret


render_ImagePixel:
    pusha 
    # movb %al,(%bx)
    xor %dx,%dx
    movb %ah,%dl
    movb $5,%cl
    loop_main_renderImagePixel:
        movb $5,%ah
        loop_renderImagePixel:
            movb %al,(%bx)
            inc %bx
            dec %ah
            cmp $0,%ah
            jg loop_renderImagePixel
        
        add $0x140,%bx
        sub $5,%bx
        dec %cl
        cmp $0,%cl
        jne loop_main_renderImagePixel

    fim_render_ImagePixel:
        popa
        ret