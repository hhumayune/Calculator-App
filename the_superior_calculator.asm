;CO&AL project by 200901018 and 200901085

;==============================
;symbol     operation           syntax

;+          addition            + [operand]   (a+b)
;-          subtraction         - [operand]   (a-b)
;*          multiplication      * [operand]   (a*b)
;/          division            / [operand]   (a/b)
;^          exponent            ^ [operand]   (a^b)
;%          percent             % [operand]   (b% of a)
;!          factorial           !             (a!)
;#          square root         #             (sqrt(a))

;N/n        new numeral         N or n
;E/e        exit program        E or e
;==============================


org 100h
include emu8086.inc

.data
ans dw ?
per dw 100d

.code    

main proc
    initial:
    ;initial number
    call scan_num
    mov ans, cx
    jmp syminp
    
    input:
    call clear_screen
    mov ax, ans
    call print_num
    
    syminp:
    ;symbol input
    mov ax, 0h
    mov ah, 1
    int 21h
    
    ;symbol comparison
    cmp al, 2Bh    ;+
    je addition 
    cmp al, 2Dh    ;-
    je subtraction 
    cmp al, 2Ah    ;x
    je multiplication 
    cmp al, 2Fh    ;/
    je division
    cmp al, 5Eh    ;^
    je exponent
    cmp al, 25h    ;%
    je percent 
    cmp al, 21h    ;!
    je factorial 
    cmp al, 23h    ;#
    je squareroot
    
    cmp al, 4Eh    ;new
    je initial
    cmp al, 6Eh
    je initial 
     
    cmp al, 45h    ;end
    je end
    cmp al, 65h
    je end
    
    loop input

    ;add segment
    addition:
        call scan_num
        mov ax, ans
        add ax, cx
        mov ans, ax 
        jmp input
    
    ;sub segment
    subtraction:
        call scan_num
        mov ax, ans
        sub ax, cx
        mov ans, ax 
        jmp input
    
    ;mul segment
    multiplication:
        call scan_num
        mov ax, ans
        mul cx
        mov ans, ax 
        jmp input
    
    ;div segment
    division:
        call scan_num
        mov ax, ans
        div cx
        mov ans, ax 
        jmp input
    
    ;exponent segment
    exponent:
        call scan_num
        dec cx
        mov bx, ans
        l1:
        mov ax, ans
        mul bx
        mov ans, ax
        loop l1
        jmp input
    
    ;percentage segment
    percent:
        call scan_num
        mov ax, ans
        mul cx
        div per
        mov ans, ax
        jmp input
    
    ;factorial segment
    ;signed int limit breaks this
    factorial:
        mov cx, ans
        dec cx
        mov ax, ans
        l2:
        mul cx
        loop l2
        mov ans, ax
        jmp input
    
    ;square root
    squareroot:
        mov ax, ans
        mov cx, 0h
        mov bx, 0h
        dec bx
        sqrt:
        add bx, 02
        inc cx
        sub ax, bx
        jnz sqrt
        mov ans, cx
        jmp input
     
    end:
    main endp
        
ret

define_scan_num
define_clear_screen
define_print_num
define_print_num_uns