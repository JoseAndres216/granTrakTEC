[bits 16]

main:
    push cs
    pop ds 

    ; Cambiar a modo gráfico
    mov ax, 0x0013
    int 0x10

    ; Configurar segmento de video (ES = 0xA000)
    mov ax, 0xA000
    mov es, ax

    ; Posiciones iniciales
    mov word [bot1_x], 20
    mov word [bot1_y], 100
    mov word [bot2_x], 38
    mov word [bot2_y], 100
    mov word [bot3_x], 56
    mov word [bot3_y], 100
    
    ; Índices iniciales
    mov word [bot1_index], 0
    mov word [bot2_index], 0
    mov word [bot3_index], 0

    call game_loop

game_loop:

    call refresh

    ; Pixeles para control visual de los puntos de control en pantalla
    mov di, 100      ; Y
    imul di, 320     ; Y * 320
    add di, 38       ; + X
    mov byte [es:di], 4

    mov di, 100      ; Y
    imul di, 320     ; Y * 320
    add di, 300       ; + X
    mov byte [es:di], 4

    mov di, 175      ; Y
    imul di, 320     ; Y * 320
    add di, 300       ; + X
    mov byte [es:di], 4

    mov di, 175      ; Y
    imul di, 320     ; Y * 320
    add di, 38       ; + X
    mov byte [es:di], 4

    call draw_Map

    ; Mover Bot 1
    mov si, bot1_waypoints_x
    mov di, bot1_waypoints_y
    mov bx, bot1_index
    mov cx, [bot1_x]
    mov dx, [bot1_y]
    mov ax, 3
    call mover_bot
    mov [bot1_x], cx
    mov [bot1_y], dx
    
    ; Mover Bot 2
    mov si, bot2_waypoints_x
    mov di, bot2_waypoints_y
    mov bx, bot2_index
    mov cx, [bot2_x]
    mov dx, [bot2_y]
    mov ax, 2
    call mover_bot
    mov [bot2_x], cx
    mov [bot2_y], dx
    
    ; Mover Bot 3
    mov si, bot3_waypoints_x
    mov di, bot3_waypoints_y
    mov bx, bot3_index
    mov cx, [bot3_x]
    mov dx, [bot3_y]
    mov ax, 1
    call mover_bot
    mov [bot3_x], cx
    mov [bot3_y], dx

    ; Dibujar bots
    mov cx, [bot1_x]
    mov dx, [bot1_y]
    call dibujar_bot
    
    mov cx, [bot2_x]
    mov dx, [bot2_y]
    call dibujar_bot
    
    mov cx, [bot3_x]
    mov dx, [bot3_y]
    call dibujar_bot

    call delay

    jz game_loop

refresh:
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov cx, 320*200
    xor al, al
    rep stosb
    ret   

draw_Map:
; PLANTILLA PARA DIBUJAR PIXEL ROJO EN 0,0
    mov di, 0      ; Y
    imul di, 320     ; Y * 320
    add di, 0       ; + X
    mov byte [es:di], 4

    ret

; --- Funciones de Dibujo ---
dibujar_bot:
    pusha
    mov ax, 0xA000
    mov es, ax
    
    mov [temp_x], cx
    mov [temp_y], dx
    
    mov cx, 6
.fila:
    push cx
    mov cx, 6
    mov bx, [temp_x]
    
.col:
    mov ax, [temp_y]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 15
    
    inc bx
    loop .col
    
    inc word [temp_y]
    pop cx
    loop .fila
    
    popa
    ret

mover_bot:
    push bp
    mov bp, [bx]        ; Cargar índice actual
    
    ; Obtener target_x (CORRECCIÓN 1)
    shl bp, 1           ; Índice * 2 (words)
    mov si, [si + bp]   ; Cargar waypoint_x
    mov [temp_target_x], si
    
    ; Obtener target_y (CORRECCIÓN 2)
    mov di, [di + bp]
    mov [temp_target_y], di
    
    ; Restaurar SI/DI originales (no necesario ahora)
    
    ; Mover en X
    mov si, cx          ; X actual
    cmp si, [temp_target_x]
    je .check_y
    jl .move_right_x
    
    ; Mover izquierda
    sub si, ax
    cmp si, [temp_target_x]
    jge .update_x
    mov si, [temp_target_x]
    jmp .update_x
    
.move_right_x:
    add si, ax
    cmp si, [temp_target_x]
    jle .update_x
    mov si, [temp_target_x]
    
.update_x:
    mov cx, si          ; Actualizar X
    
.check_y:
    ; Mover en Y
    mov di, dx          ; Y actual
    cmp di, [temp_target_y]
    je .check_target_reached
    jl .move_down_y
    
    ; Mover arriba
    sub di, ax
    cmp di, [temp_target_y]
    jge .update_y
    mov di, [temp_target_y]
    jmp .update_y
    
.move_down_y:
    add di, ax
    cmp di, [temp_target_y]
    jle .update_y
    mov di, [temp_target_y]
    
.update_y:
    mov dx, di          ; Actualizar Y
    
.check_target_reached:
    ; Verificar si llegamos al waypoint
    mov si, cx
    sub si, [temp_target_x]
    jnz .done
    mov di, dx
    sub di, [temp_target_y]
    jnz .done
    
    ; Avanzar al siguiente waypoint
    inc word [bx]
    
    ; Verificar reinicio (CORRECCIÓN 3)
    mov bp, [bx]
    shl bp, 1
    mov si, bot1_waypoints_x  ; Asumimos bot1 (ajustar según bot)
    cmp word [si + bp], -1
    jne .done
    mov word [bx], 0    ; Reiniciar índice
    
.done:
    pop bp
    ret

delay:
    mov ah, 0x86
    mov cx, 0x0001
    xor dx, dx
    int 0x15
    ret

; Vars

bot1_x dw 0
bot1_y dw 0
bot2_x dw 0
bot2_y dw 0
bot3_x dw 0
bot3_y dw 0

; Índices
bot1_index dw 0
bot2_index dw 0
bot3_index dw 0

; Temporales
temp_target_x dw 0
temp_target_y dw 0

temp_x dw 0
temp_y dw 0

; Waypoints
; Waypoints mejorados para movimiento rectangular
bot1_waypoints_x: dw 20, 300, 300, 20, 20, -1
bot1_waypoints_y: dw 100, 100, 180, 180, 100, -1

bot2_waypoints_x: dw 38, 300, 300, 38, 38, -1
bot2_waypoints_y: dw 100, 100, 175, 175, 100, -1

bot3_waypoints_x: dw 56, 300, 300, 56, 56, -1
bot3_waypoints_y: dw 100, 100, 170, 170, 100, -1