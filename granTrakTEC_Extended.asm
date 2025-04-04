[bits 16]

;   <><><><><><><><><><><><><><><><><><><><>                 MAIN               <><><><><><><><><><><><><><><><><><><><>

main:
    push cs
    pop ds 

;   <><><><><><><><><><>              GRAPHIC MODE             <><><><><><><><><><>

    mov ax, 0x0013
    int 0x10

    mov ax, 0xA000
    mov es, ax

;   <><><><><><><><><><>        VARIABLES INITIALIZATION       <><><><><><><><><><>

    mov word [player1Laps], 0
    mov word [player2Laps], 0

    mov word [bot1PositionX], 16
    mov word [bot1PositionY], 112
    mov word [bot1CurrentCheckpoint], 0
    call getRandomSpeed
    mov [bot1Speed], ax
    mov word [bot1Laps], 0

    call delay

    mov word [bot2PositionX], 32
    mov word [bot2PositionY], 128
    mov word [bot2CurrentCheckpoint], 0
    call getRandomSpeed
    mov [bot2Speed], ax
    mov word [bot2Laps], 0

    call delay

    mov word [bot3PositionX], 48
    mov word [bot3PositionY], 136
    mov word [bot3CurrentCheckpoint], 0
    call getRandomSpeed
    mov ax, 4
    mov [bot3Speed], ax
    mov word [bot3Laps], 0

    call gameLoop

;   <><><><><><><><><><><><><><><><><><><><>              GAME LOOP             <><><><><><><><><><><><><><><><><><><><>

gameLoop:

    call refreshScreen

    call drawGUI

    call draw_Map

    call updateBot1Position
    call updateBot2Position
    call updateBot3Position
    
    call drawBot1
    call drawBot2
    call drawBot3

    call delay

    jz gameLoop

;   <><><><><><><><><><><><><><><><><><><><>             GUI DRAWING            <><><><><><><><><><><><><><><><><><><><>

drawGUI:

    jmp drawSeparationLines

    jmp drawPlayer1Icon
    jmp drawPlayer1Laps

    jmp drawPlayer2Icon
    jmp drawPlayer2Laps

    jmp drawBot1Icon
    jmp drawBot1Laps

    jmp drawBot2Icon
    jmp drawBot2Laps

    jmp drawBot3Icon
    jmp drawBot3Laps

;   <><><><><><><><><><>            SEPARATION LINES           <><><><><><><><><><>

drawSeparationLines:
    jmp drawGUIGameScreenSeparationLine

drawGUIGameScreenSeparationLine:
    pusha
    
    mov cx, 0
    mov dx, 28
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 2

.drawGUIGameScreenSeparationLineRow:
    push cx
    mov cx, 320
    mov bx, [temporalX]

.drawGUIGameScreenSeparationLineColumn:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 8
    
    inc bx
    loop .drawGUIGameScreenSeparationLineColumn
    
    inc word [temporalY]
    pop cx
    loop .drawGUIGameScreenSeparationLineRow
    
    popa

;   <><><><><><><><><><>           PLAYER 1 GUI: ICON          <><><><><><><><><><>

drawPlayer1Icon:
    pusha
    
    mov cx, 10
    mov dx, 10
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 10

.drawPlayer1IconRow:
    push cx
    mov cx, 10
    mov bx, [temporalX]

.drawPlayer1IconColumn:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 2
    
    inc bx
    loop .drawPlayer1IconColumn
    
    inc word [temporalY]
    pop cx
    loop .drawPlayer1IconRow
    
    popa

;   <><><><><><><><><><>           PLAYER 1 GUI: LAPS          <><><><><><><><><><>

drawPlayer1Laps:
    pusha
    
    mov cx, [player1Laps]
    jcxz .finishedPlayer1Laps
    
    mov word [temporalX], 26
    mov word [temporalY], 14
    mov si, cx

.drawPlayer1LapPoint:
    mov ax, [temporalY]
    mov bx, 320
    mul bx
    add ax, [temporalX]
    mov di, ax
    
    mov cx, 2
.player1LapPointRows:
    push cx
    mov cx, 2
    mov bx, di
    
.player1LapPointColumns:
    mov byte [es:bx], 2
    inc bx
    loop .player1LapPointColumns
    
    add di, 320
    pop cx
    loop .player1LapPointRows
    
    add word [temporalX], 6
    dec si
    jnz .drawPlayer1LapPoint

.finishedPlayer1Laps:
    popa

;   <><><><><><><><><><>           PLAYER 2 GUI: ICON          <><><><><><><><><><>

drawPlayer2Icon:
    pusha
    
    mov cx, 60
    mov dx, 10
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 10

.drawPlayer2IconRow:
    push cx
    mov cx, 10
    mov bx, [temporalX]

.drawPlayer2IconColumn:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 4
    
    inc bx
    loop .drawPlayer2IconColumn
    
    inc word [temporalY]
    pop cx
    loop .drawPlayer2IconRow
    
    popa

;   <><><><><><><><><><>           PLAYER 2 GUI: LAPS          <><><><><><><><><><>

drawPlayer2Laps:
    pusha
    
    mov cx, [player2Laps]
    jcxz .finishedPlayer2Laps
    
    mov word [temporalX], 76
    mov word [temporalY], 14
    mov si, cx

.drawPlayer2LapPoint:
    mov ax, [temporalY]
    mov bx, 320
    mul bx
    add ax, [temporalX]
    mov di, ax
    
    mov cx, 2
.player2LapPointRows:
    push cx
    mov cx, 2
    mov bx, di
    
.player2LapPointColumns:
    mov byte [es:bx], 4
    inc bx
    loop .player2LapPointColumns
    
    add di, 320
    pop cx
    loop .player2LapPointRows
    
    add word [temporalX], 6
    dec si
    jnz .drawPlayer2LapPoint

.finishedPlayer2Laps:
    popa

;   <><><><><><><><><><>            BOT 1 GUI: ICON            <><><><><><><><><><>

drawBot1Icon:
    pusha
    
    mov cx, 110
    mov dx, 10
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 10

.drawBot1IconRow:
    push cx
    mov cx, 10
    mov bx, [temporalX]

.drawBot1IconColumn:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 14
    
    inc bx
    loop .drawBot1IconColumn
    
    inc word [temporalY]
    pop cx
    loop .drawBot1IconRow
    
    popa

;   <><><><><><><><><><>            BOT 1 GUI: LAPS            <><><><><><><><><><>

drawBot1Laps:
    pusha
    
    mov cx, [bot1Laps]
    jcxz .finishedBot1Laps
    
    mov word [temporalX], 126
    mov word [temporalY], 14
    mov si, cx

.drawBot1LapPoint:
    mov ax, [temporalY]
    mov bx, 320
    mul bx
    add ax, [temporalX]
    mov di, ax
    
    mov cx, 2
.bot1LapPointRows:
    push cx
    mov cx, 2
    mov bx, di
    
.bot1LapPointColumns:
    mov byte [es:bx], 14
    inc bx
    loop .bot1LapPointColumns
    
    add di, 320
    pop cx
    loop .bot1LapPointRows
    
    add word [temporalX], 6
    dec si
    jnz .drawBot1LapPoint

.finishedBot1Laps:
    popa

;   <><><><><><><><><><>            BOT 2 GUI: ICON            <><><><><><><><><><>

drawBot2Icon:
    pusha
    
    mov cx, 160
    mov dx, 10
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 10

.drawBot2IconRow:
    push cx
    mov cx, 10
    mov bx, [temporalX]

.drawBot2IconColumn:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 5
    
    inc bx
    loop .drawBot2IconColumn
    
    inc word [temporalY]
    pop cx
    loop .drawBot2IconRow
    
    popa

;   <><><><><><><><><><>            BOT 2 GUI: LAPS            <><><><><><><><><><>

drawBot2Laps:
    pusha
    
    mov cx, [bot2Laps]
    jcxz .finishedBot2Laps
    
    mov word [temporalX], 176
    mov word [temporalY], 14
    mov si, cx

.drawBot2LapPoint:
    mov ax, [temporalY]
    mov bx, 320
    mul bx
    add ax, [temporalX]
    mov di, ax
    
    mov cx, 2
.bot2LapPointRows:
    push cx
    mov cx, 2
    mov bx, di
    
.bot2LapPointColumns:
    mov byte [es:bx], 5
    inc bx
    loop .bot2LapPointColumns
    
    add di, 320
    pop cx
    loop .bot2LapPointRows
    
    add word [temporalX], 6
    dec si
    jnz .drawBot2LapPoint

.finishedBot2Laps:
    popa

;   <><><><><><><><><><>            BOT 3 GUI: ICON            <><><><><><><><><><>

drawBot3Icon:
    pusha
    
    mov cx, 210
    mov dx, 10
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 10

.drawBot3IconRow:
    push cx
    mov cx, 10
    mov bx, [temporalX]

.drawBot3IconColumn:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 1
    
    inc bx
    loop .drawBot3IconColumn
    
    inc word [temporalY]
    pop cx
    loop .drawBot3IconRow
    
    popa

;   <><><><><><><><><><>            BOT 3 GUI: LAPS            <><><><><><><><><><>

drawBot3Laps:
    pusha
    
    mov cx, [bot3Laps]
    jcxz .finishedBot3Laps
    
    mov word [temporalX], 226
    mov word [temporalY], 14
    mov si, cx

.drawBot3LapPoint:
    mov ax, [temporalY]
    mov bx, 320
    mul bx
    add ax, [temporalX]
    mov di, ax
    
    mov cx, 2
.bot3LapPointRows:
    push cx
    mov cx, 2
    mov bx, di
    
.bot3LapPointColumns:
    mov byte [es:bx], 1
    inc bx
    loop .bot3LapPointColumns
    
    add di, 320
    pop cx
    loop .bot3LapPointRows
    
    add word [temporalX], 6
    dec si
    jnz .drawBot3LapPoint

.finishedBot3Laps:
    popa

;   <><><><><><><><><><><><><><><><><><><><>            MAP DRAWING             <><><><><><><><><><><><><><><><><><><><>

draw_Map:
; PLANTILLA PARA DIBUJAR PIXEL ROJO EN 0,0
    mov di, 0      ; Y
    imul di, 320     ; Y * 320
    add di, 0       ; + X
    mov byte [es:di], 4

    ret

;   <><><><><><><><><><><><><><><><><><><><>            BOT 1 DRAWING           <><><><><><><><><><><><><><><><><><><><>

drawBot1:
    pusha
    
    mov cx, [bot1PositionX]
    mov dx, [bot1PositionY]
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 6
.drawBot1Row:
    push cx
    mov cx, 6
    mov bx, [temporalX]
    
.drawBot1Column:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 14
    
    inc bx
    loop .drawBot1Column
    
    inc word [temporalY]
    pop cx
    loop .drawBot1Row
    
    popa
    ret

;   <><><><><><><><><><><><><><><><><><><><>            BOT 1 MOVEMENT          <><><><><><><><><><><><><><><><><><><><>

updateBot1Position:
    pusha

    mov ax, [bot1CurrentCheckpoint]
    
    cmp ax, 0
    je moveBot1ToCheckpoint1

    cmp ax, 1
    je moveBot1ToCheckpoint2

    cmp ax, 2
    je moveBot1ToCheckpoint3

    cmp ax, 3
    je moveBot1ToCheckpoint4

    cmp ax, 4
    je moveBot1ToCheckpoint5

    cmp ax, 5
    je moveBot1ToCheckpoint6

    cmp ax, 6
    je moveBot1ToCheckpoint7

    cmp ax, 7
    je moveBot1ToCheckpoint8

    cmp ax, 8
    je moveBot1ToCheckpoint9

    cmp ax, 9
    je moveBot1ToCheckpoint10

    cmp ax, 10
    je moveBot1ToCheckpoint11
    

; BOT 1 - CHECKPOINT 1: (16,48)

moveBot1ToCheckpoint1:
    mov ax, [bot1PositionX]
    cmp ax, 16
    jne moveBot1ToCheckpoint1X
    mov ax, [bot1PositionY]
    cmp ax, 48
    jne moveBot1ToCheckpoint1Y

    mov word [bot1CurrentCheckpoint], 1

    jmp done

moveBot1ToCheckpoint1X:
    mov ax, 16
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint1Y:
    mov ax, 48
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 2: (96,48)

moveBot1ToCheckpoint2:
    mov ax, [bot1PositionX]
    cmp ax, 96
    jne moveBot1ToCheckpoint2X
    mov ax, [bot1PositionY]
    cmp ax, 48
    jne moveBot1ToCheckpoint2Y

    mov word [bot1CurrentCheckpoint], 2

    jmp done

moveBot1ToCheckpoint2X:
    mov ax, 96
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint2Y:
    mov ax, 48
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 3: (96,96)

moveBot1ToCheckpoint3:
    mov ax, [bot1PositionX]
    cmp ax, 96
    jne moveBot1ToCheckpoint3X
    mov ax, [bot1PositionY]
    cmp ax, 96
    jne moveBot1ToCheckpoint3Y

    mov word [bot1CurrentCheckpoint], 3

    jmp done

moveBot1ToCheckpoint3X:
    mov ax, 96
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint3Y:
    mov ax, 96
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 4: (120,96)

moveBot1ToCheckpoint4:
    mov ax, [bot1PositionX]
    cmp ax, 120
    jne moveBot1ToCheckpoint4X
    mov ax, [bot1PositionY]
    cmp ax, 96
    jne moveBot1ToCheckpoint4Y

    mov word [bot1CurrentCheckpoint], 4

    jmp done

moveBot1ToCheckpoint4X:
    mov ax, 120
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint4Y:
    mov ax, 96
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 5: (120,48)

moveBot1ToCheckpoint5:
    mov ax, [bot1PositionX]
    cmp ax, 120
    jne moveBot1ToCheckpoint5X
    mov ax, [bot1PositionY]
    cmp ax, 48
    jne moveBot1ToCheckpoint5Y

    mov word [bot1CurrentCheckpoint], 5

    jmp done

moveBot1ToCheckpoint5X:
    mov ax, 120
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint5Y:
    mov ax, 48
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 6: (200,48)

moveBot1ToCheckpoint6:
    mov ax, [bot1PositionX]
    cmp ax, 200
    jne moveBot1ToCheckpoint6X
    mov ax, [bot1PositionY]
    cmp ax, 48
    jne moveBot1ToCheckpoint6Y

    mov word [bot1CurrentCheckpoint], 6

    jmp done

moveBot1ToCheckpoint6X:
    mov ax, 200
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint6Y:
    mov ax, 48
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 7: (200,96)

moveBot1ToCheckpoint7:
    mov ax, [bot1PositionX]
    cmp ax, 200
    jne moveBot1ToCheckpoint7X
    mov ax, [bot1PositionY]
    cmp ax, 96
    jne moveBot1ToCheckpoint7Y

    mov word [bot1CurrentCheckpoint], 7

    jmp done

moveBot1ToCheckpoint7X:
    mov ax, 200
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint7Y:
    mov ax, 96
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 8: (296,96)

moveBot1ToCheckpoint8:
    mov ax, [bot1PositionX]
    cmp ax, 296
    jne moveBot1ToCheckpoint8X
    mov ax, [bot1PositionY]
    cmp ax, 96
    jne moveBot1ToCheckpoint8Y

    mov word [bot1CurrentCheckpoint], 8

    jmp done

moveBot1ToCheckpoint8X:
    mov ax, 296
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint8Y:
    mov ax, 96
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done


; BOT 1 - CHECKPOINT 9: (296,176)

moveBot1ToCheckpoint9:
    mov ax, [bot1PositionX]
    cmp ax, 296
    jne moveBot1ToCheckpoint9X
    mov ax, [bot1PositionY]
    cmp ax, 176
    jne moveBot1ToCheckpoint9Y

    mov word [bot1CurrentCheckpoint], 9

    jmp done

moveBot1ToCheckpoint9X:
    mov ax, 296
    cmp [bot1PositionX], ax
    jl incrementBot1X
    jg decreaseBot1X
    jmp done

moveBot1ToCheckpoint9Y:
    mov ax, 176
    cmp [bot1PositionY], ax
    jl incrementBot1Y
    jg decreaseBot1Y
    jmp done

; BOT 1 - CHECKPOINT 10: (16,176)

moveBot1ToCheckpoint10:
    mov ax, [bot1PositionX]
    cmp ax, 16
    jne moveBot1ToCheckpoint10X
    mov ax, [bot1PositionY]
    cmp ax, 176
    jne moveBot1ToCheckpoint10Y

    mov word [bot1CurrentCheckpoint], 10

    jmp done

moveBot1ToCheckpoint10X:
    mov ax, 16    
    cmp [bot1PositionX], ax
    jl incrementBot1X       
    jg decreaseBot1X       
    jmp done   

moveBot1ToCheckpoint10Y:
    mov ax, 176      
    cmp [bot1PositionY], ax
    jl incrementBot1Y       
    jg decreaseBot1Y       
    jmp done

; BOT 1 - CHECKPOINT 11: (16,112)

moveBot1ToCheckpoint11:
    mov ax, [bot1PositionX]
    cmp ax, 16
    jne moveBot1ToCheckpoint11X
    mov ax, [bot1PositionY]
    cmp ax, 112
    jne moveBot1ToCheckpoint11Y

    mov word [bot1CurrentCheckpoint], 0
    inc dword [bot1Laps]

    jmp done

moveBot1ToCheckpoint11X:
    mov ax, 16    
    cmp [bot1PositionX], ax
    jl incrementBot1X       
    jg decreaseBot1X       
    jmp done   

moveBot1ToCheckpoint11Y:
    mov ax, 112      
    cmp [bot1PositionY], ax
    jl incrementBot1Y       
    jg decreaseBot1Y       
    jmp done

;   <><><><><><><><><><><><><><><><><><><><>   BOT 1 COMMON MOVEMENT FUNCTIONS  <><><><><><><><><><><><><><><><><><><><>

incrementBot1X:
    mov ax, [bot1Speed]
    add word [bot1PositionX], ax
    jmp done
decreaseBot1X:
    mov ax, [bot1Speed]
    sub word [bot1PositionX], ax
    jmp done

incrementBot1Y:
    mov ax, [bot1Speed]
    add word [bot1PositionY], ax
    jmp done
decreaseBot1Y:
    mov ax, [bot1Speed]
    sub word [bot1PositionY], ax
    jmp done

;   <><><><><><><><><><><><><><><><><><><><>            BOT 2 DRAWING           <><><><><><><><><><><><><><><><><><><><>

drawBot2:
    pusha
    
    mov cx, [bot2PositionX]
    mov dx, [bot2PositionY]
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 6
.drawBot2Row:
    push cx
    mov cx, 6
    mov bx, [temporalX]
    
.drawBot2Column:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 5
    
    inc bx
    loop .drawBot2Column
    
    inc word [temporalY]
    pop cx
    loop .drawBot2Row
    
    popa
    ret

;   <><><><><><><><><><><><><><><><><><><><>            BOT 2 MOVEMENT          <><><><><><><><><><><><><><><><><><><><>

updateBot2Position:
    pusha

    mov ax, [bot2CurrentCheckpoint]
    
    cmp ax, 0
    je moveBot2ToCheckpoint1

    cmp ax, 1
    je moveBot2ToCheckpoint2

    cmp ax, 2
    je moveBot2ToCheckpoint3

    cmp ax, 3
    je moveBot2ToCheckpoint4

    cmp ax, 4
    je moveBot2ToCheckpoint5

    cmp ax, 5
    je moveBot2ToCheckpoint6

    cmp ax, 6
    je moveBot2ToCheckpoint7

    cmp ax, 7
    je moveBot2ToCheckpoint8

    cmp ax, 8
    je moveBot2ToCheckpoint9

    cmp ax, 9
    je moveBot2ToCheckpoint10

    cmp ax, 10
    je moveBot2ToCheckpoint11    

; BOT 2 - CHECKPOINT 1: (32,64)

moveBot2ToCheckpoint1:
    mov ax, [bot2PositionX]
    cmp ax, 32
    jne moveBot2ToCheckpoint1X
    mov ax, [bot2PositionY]
    cmp ax, 64
    jne moveBot2ToCheckpoint1Y

    mov word [bot2CurrentCheckpoint], 1

    jmp done

moveBot2ToCheckpoint1X:
    mov ax, 32
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint1Y:
    mov ax, 64
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 2: (80,64)

moveBot2ToCheckpoint2:
    mov ax, [bot2PositionX]
    cmp ax, 80
    jne moveBot2ToCheckpoint2X
    mov ax, [bot2PositionY]
    cmp ax, 64
    jne moveBot2ToCheckpoint2Y

    mov word [bot2CurrentCheckpoint], 2

    jmp done

moveBot2ToCheckpoint2X:
    mov ax, 80
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint2Y:
    mov ax, 64
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 3: (80,112)

moveBot2ToCheckpoint3:
    mov ax, [bot2PositionX]
    cmp ax, 80
    jne moveBot2ToCheckpoint3X
    mov ax, [bot2PositionY]
    cmp ax, 112
    jne moveBot2ToCheckpoint3Y

    mov word [bot2CurrentCheckpoint], 3

    jmp done

moveBot2ToCheckpoint3X:
    mov ax, 80
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint3Y:
    mov ax, 112
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 4: (136,112)

moveBot2ToCheckpoint4:
    mov ax, [bot2PositionX]
    cmp ax, 136
    jne moveBot2ToCheckpoint4X
    mov ax, [bot2PositionY]
    cmp ax, 112
    jne moveBot2ToCheckpoint4Y

    mov word [bot2CurrentCheckpoint], 4

    jmp done

moveBot2ToCheckpoint4X:
    mov ax, 136
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint4Y:
    mov ax, 112
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 5: (136,64)

moveBot2ToCheckpoint5:
    mov ax, [bot2PositionX]
    cmp ax, 136
    jne moveBot2ToCheckpoint5X
    mov ax, [bot2PositionY]
    cmp ax, 64
    jne moveBot2ToCheckpoint5Y

    mov word [bot2CurrentCheckpoint], 5

    jmp done

moveBot2ToCheckpoint5X:
    mov ax, 136
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint5Y:
    mov ax, 64
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 6: (184,64)

moveBot2ToCheckpoint6:
    mov ax, [bot2PositionX]
    cmp ax, 184
    jne moveBot2ToCheckpoint6X
    mov ax, [bot2PositionY]
    cmp ax, 64
    jne moveBot2ToCheckpoint6Y

    mov word [bot2CurrentCheckpoint], 6

    jmp done

moveBot2ToCheckpoint6X:
    mov ax, 184
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint6Y:
    mov ax, 64
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 7: (184,112)

moveBot2ToCheckpoint7:
    mov ax, [bot2PositionX]
    cmp ax, 184
    jne moveBot2ToCheckpoint7X
    mov ax, [bot2PositionY]
    cmp ax, 112
    jne moveBot2ToCheckpoint7Y

    mov word [bot2CurrentCheckpoint], 7

    jmp done

moveBot2ToCheckpoint7X:
    mov ax, 184
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint7Y:
    mov ax, 112
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 8: (280,112)

moveBot2ToCheckpoint8:
    mov ax, [bot2PositionX]
    cmp ax, 280
    jne moveBot2ToCheckpoint8X
    mov ax, [bot2PositionY]
    cmp ax, 112
    jne moveBot2ToCheckpoint8Y

    mov word [bot2CurrentCheckpoint], 8

    jmp done

moveBot2ToCheckpoint8X:
    mov ax, 280
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint8Y:
    mov ax, 112
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done


; BOT 2 - CHECKPOINT 9: (280,160)

moveBot2ToCheckpoint9:
    mov ax, [bot2PositionX]
    cmp ax, 280
    jne moveBot2ToCheckpoint9X
    mov ax, [bot2PositionY]
    cmp ax, 160
    jne moveBot2ToCheckpoint9Y

    mov word [bot2CurrentCheckpoint], 9

    jmp done

moveBot2ToCheckpoint9X:
    mov ax, 280
    cmp [bot2PositionX], ax
    jl incrementBot2X
    jg decreaseBot2X
    jmp done

moveBot2ToCheckpoint9Y:
    mov ax, 160
    cmp [bot2PositionY], ax
    jl incrementBot2Y
    jg decreaseBot2Y
    jmp done

; BOT 2 - CHECKPOINT 10: (32,160)

moveBot2ToCheckpoint10:
    mov ax, [bot2PositionX]
    cmp ax, 32
    jne moveBot2ToCheckpoint10X
    mov ax, [bot2PositionY]
    cmp ax, 160
    jne moveBot2ToCheckpoint10Y

    mov word [bot2CurrentCheckpoint], 10

    jmp done

moveBot2ToCheckpoint10X:
    mov ax, 32   
    cmp [bot2PositionX], ax
    jl incrementBot2X       
    jg decreaseBot2X       
    jmp done   

moveBot2ToCheckpoint10Y:
    mov ax, 160
    cmp [bot2PositionY], ax
    jl incrementBot2Y       
    jg decreaseBot2Y       
    jmp done

; BOT 2 - CHECKPOINT 11: (32,112)

moveBot2ToCheckpoint11:
    mov ax, [bot2PositionX]
    cmp ax, 32
    jne moveBot2ToCheckpoint11X
    mov ax, [bot2PositionY]
    cmp ax, 112
    jne moveBot2ToCheckpoint11Y

    inc dword [bot2Laps]
    mov word [bot2CurrentCheckpoint], 0

    jmp done

moveBot2ToCheckpoint11X:
    mov ax, 32   
    cmp [bot2PositionX], ax
    jl incrementBot2X       
    jg decreaseBot2X       
    jmp done   

moveBot2ToCheckpoint11Y:
    mov ax, 112
    cmp [bot2PositionY], ax
    jl incrementBot2Y       
    jg decreaseBot2Y       
    jmp done

;   <><><><><><><><><><><><><><><><><><><><>   BOT 2 COMMON MOVEMENT FUNCTIONS  <><><><><><><><><><><><><><><><><><><><><>

incrementBot2X:
    mov ax, [bot2Speed]
    add word [bot2PositionX], ax
    jmp done
decreaseBot2X:
    mov ax, [bot2Speed]
    sub word [bot2PositionX], ax
    jmp done

incrementBot2Y:
    mov ax, [bot2Speed]
    add word [bot2PositionY], ax
    jmp done
decreaseBot2Y:
    mov ax, [bot2Speed]
    sub word [bot2PositionY], ax
    jmp done
    jmp done

;   <><><><><><><><><><><><><><><><><><><><>            BOT 3 DRAWING           <><><><><><><><><><><><><><><><><><><><>

drawBot3:
    pusha
    
    mov cx, [bot3PositionX]
    mov dx, [bot3PositionY]
    mov [temporalX], cx
    mov [temporalY], dx
    
    mov cx, 6
.drawBot3Row:
    push cx
    mov cx, 6
    mov bx, [temporalX]
    
.drawBot3Column:
    mov ax, [temporalY]
    mov di, 320
    imul di
    add ax, bx
    mov di, ax
    mov byte [es:di], 1
    
    inc bx
    loop .drawBot3Column
    
    inc word [temporalY]
    pop cx
    loop .drawBot3Row
    
    popa
    ret

;   <><><><><><><><><><><><><><><><><><><><>            BOT 3 MOVEMENT          <><><><><><><><><><><><><><><><><><><><>

updateBot3Position:
    pusha

    mov ax, [bot3CurrentCheckpoint]
    
    cmp ax, 0
    je moveBot3ToCheckpoint1

    cmp ax, 1
    je moveBot3ToCheckpoint2

    cmp ax, 2
    je moveBot3ToCheckpoint3

    cmp ax, 3
    je moveBot3ToCheckpoint4

    cmp ax, 4
    je moveBot3ToCheckpoint5

    cmp ax, 5
    je moveBot3ToCheckpoint6

    cmp ax, 6
    je moveBot3ToCheckpoint7

    cmp ax, 7
    je moveBot3ToCheckpoint8

    cmp ax, 8
    je moveBot3ToCheckpoint9

    cmp ax, 9
    je moveBot3ToCheckpoint10

    cmp ax, 10
    je moveBot3ToCheckpoint11
    

; BOT 3 - CHECKPOINT 1: (48,72)

moveBot3ToCheckpoint1:
    mov ax, [bot3PositionX]
    cmp ax, 48
    jne moveBot3ToCheckpoint1X
    mov ax, [bot3PositionY]
    cmp ax, 72
    jne moveBot3ToCheckpoint1Y

    mov word [bot3CurrentCheckpoint], 1

    jmp done

moveBot3ToCheckpoint1X:
    mov ax, 48
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint1Y:
    mov ax, 72
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 2: (72,72)

moveBot3ToCheckpoint2:
    mov ax, [bot3PositionX]
    cmp ax, 72
    jne moveBot3ToCheckpoint2X
    mov ax, [bot3PositionY]
    cmp ax, 72
    jne moveBot3ToCheckpoint2Y

    mov word [bot3CurrentCheckpoint], 2

    jmp done

moveBot3ToCheckpoint2X:
    mov ax, 72
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint2Y:
    mov ax, 72
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 3: (72,128)

moveBot3ToCheckpoint3:
    mov ax, [bot3PositionX]
    cmp ax, 72
    jne moveBot3ToCheckpoint3X
    mov ax, [bot3PositionY]
    cmp ax, 128
    jne moveBot3ToCheckpoint3Y

    mov word [bot3CurrentCheckpoint], 3

    jmp done

moveBot3ToCheckpoint3X:
    mov ax, 72
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint3Y:
    mov ax, 128
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 4: (144,128)

moveBot3ToCheckpoint4:
    mov ax, [bot3PositionX]
    cmp ax, 144
    jne moveBot3ToCheckpoint4X
    mov ax, [bot3PositionY]
    cmp ax, 128
    jne moveBot3ToCheckpoint4Y

    mov word [bot3CurrentCheckpoint], 4

    jmp done

moveBot3ToCheckpoint4X:
    mov ax, 144
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint4Y:
    mov ax, 128
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 5: (144,72)

moveBot3ToCheckpoint5:
    mov ax, [bot3PositionX]
    cmp ax, 144
    jne moveBot3ToCheckpoint5X
    mov ax, [bot3PositionY]
    cmp ax, 72
    jne moveBot3ToCheckpoint5Y

    mov word [bot3CurrentCheckpoint], 5

    jmp done

moveBot3ToCheckpoint5X:
    mov ax, 144
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint5Y:
    mov ax, 72
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 6: (168,72)

moveBot3ToCheckpoint6:
    mov ax, [bot3PositionX]
    cmp ax, 168
    jne moveBot3ToCheckpoint6X
    mov ax, [bot3PositionY]
    cmp ax, 72
    jne moveBot3ToCheckpoint6Y

    mov word [bot3CurrentCheckpoint], 6

    jmp done

moveBot3ToCheckpoint6X:
    mov ax, 168
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint6Y:
    mov ax, 72
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 7: (168,128)

moveBot3ToCheckpoint7:
    mov ax, [bot3PositionX]
    cmp ax, 168
    jne moveBot3ToCheckpoint7X
    mov ax, [bot3PositionY]
    cmp ax, 128
    jne moveBot3ToCheckpoint7Y

    mov word [bot3CurrentCheckpoint], 7

    jmp done

moveBot3ToCheckpoint7X:
    mov ax, 168
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint7Y:
    mov ax, 128
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 8: (216,128)

moveBot3ToCheckpoint8:
    mov ax, [bot3PositionX]
    cmp ax, 216
    jne moveBot3ToCheckpoint8X
    mov ax, [bot3PositionY]
    cmp ax, 128
    jne moveBot3ToCheckpoint8Y

    mov word [bot3CurrentCheckpoint], 8

    jmp done

moveBot3ToCheckpoint8X:
    mov ax, 216
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint8Y:
    mov ax, 128
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done


; BOT 3 - CHECKPOINT 9: (216,152)

moveBot3ToCheckpoint9:
    mov ax, [bot3PositionX]
    cmp ax, 216
    jne moveBot3ToCheckpoint9X
    mov ax, [bot3PositionY]
    cmp ax, 152
    jne moveBot3ToCheckpoint9Y

    mov word [bot3CurrentCheckpoint], 9

    jmp done

moveBot3ToCheckpoint9X:
    mov ax, 216
    cmp [bot3PositionX], ax
    jl incrementBot3X
    jg decreaseBot3X
    jmp done

moveBot3ToCheckpoint9Y:
    mov ax, 152
    cmp [bot3PositionY], ax
    jl incrementBot3Y
    jg decreaseBot3Y
    jmp done

; BOT 3 - CHECKPOINT 10: (48,152)

moveBot3ToCheckpoint10:
    mov ax, [bot3PositionX]
    cmp ax, 48
    jne moveBot3ToCheckpoint10X
    mov ax, [bot3PositionY]
    cmp ax, 152
    jne moveBot3ToCheckpoint10Y

    mov word [bot3CurrentCheckpoint], 10

    jmp done

moveBot3ToCheckpoint10X:
    mov ax, 48   
    cmp [bot3PositionX], ax
    jl incrementBot3X       
    jg decreaseBot3X       
    jmp done   

moveBot3ToCheckpoint10Y:
    mov ax, 152      
    cmp [bot3PositionY], ax
    jl incrementBot3Y       
    jg decreaseBot3Y       
    jmp done

; BOT 3 - CHECKPOINT 11: (48,112)

moveBot3ToCheckpoint11:
    mov ax, [bot3PositionX]
    cmp ax, 48
    jne moveBot3ToCheckpoint11X
    mov ax, [bot3PositionY]
    cmp ax, 112
    jne moveBot3ToCheckpoint11Y

    inc dword [bot3Laps]
    mov word [bot3CurrentCheckpoint], 0

    jmp done

moveBot3ToCheckpoint11X:
    mov ax, 48   
    cmp [bot3PositionX], ax
    jl incrementBot3X       
    jg decreaseBot3X       
    jmp done   

moveBot3ToCheckpoint11Y:
    mov ax, 112      
    cmp [bot3PositionY], ax
    jl incrementBot3Y       
    jg decreaseBot3Y       
    jmp done

;   <><><><><><><><><><><><><><><><><><><><>   BOT 3 COMMON MOVEMENT FUNCTIONS  <><><><><><><><><><><><><><><><><><><><><>

incrementBot3X:
    mov ax, [bot3Speed]
    add word [bot3PositionX], ax
    jmp done
decreaseBot3X:
    mov ax, [bot3Speed]
    sub word [bot3PositionX], ax
    jmp done

incrementBot3Y:
    mov ax, [bot3Speed]
    add word [bot3PositionY], ax
    jmp done
decreaseBot3Y:
    mov ax, [bot3Speed]
    sub word [bot3PositionY], ax
    jmp done


;   <><><><><><><><><><><><><><><><><><><><>          FUNCTIONALITIES           <><><><><><><><><><><><><><><><><><><><>

;   <><><><><><><><><><>          REFREASH GAME SCREEN         <><><><><><><><><><>
refreshScreen:
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov cx, 320*200
    xor al, al
    rep stosb
    ret

;   <><><><><><><><><><>      CALCULATES BOTS RANDOM SPEED     <><><><><><><><><><>

getRandomSpeed:
    rdtsc
    xor eax, edx
    and eax, 0x07
    inc eax

    ; FILTERS EAX TO BE 1, 2, 4 OR 8
    ; SPEED POSIBILITIES: P(1)=1/8, P(2)=2/8, P(4)=4/8 AND P(8)=1/8

    cmp eax, 3
    mov ebx, 2
    cmove eax, ebx

    cmp eax, 5
    mov ebx, 4
    cmove eax, ebx

    cmp eax, 6
    mov ebx, 4
    cmove eax, ebx

    cmp eax, 7
    mov ebx, 4
    cmove eax, ebx

    ret

;   <><><><><><><><><><>             GRAPHIC DELAY             <><><><><><><><><><>

delay:
    mov ah, 0x86
    mov cx, 0x0001
    xor dx, dx
    int 0x15
    ret

done:
    popa
    ret

;   <><><><><><><><><><><><><><><><><><><><>              VARIABLES             <><><><><><><><><><><><><><><><><><><><>

;   <><><><><><><><><><>           PLAYERS VARIABLES           <><><><><><><><><><>
player1PositionX dw 0
player1PositionY dw 0
player2PositionX dw 0
player2PositionY dw 0
bot1PositionX dw 0
bot1PositionY dw 0
bot2PositionX dw 0
bot2PositionY dw 0
bot3PositionX dw 0
bot3PositionY dw 0

player1Laps dw 0
player2Laps dw 0

;   <><><><><><><><><><>            BOTS VARIABLES             <><><><><><><><><><>

bot1CurrentCheckpoint dw 0
bot2CurrentCheckpoint dw 0
bot3CurrentCheckpoint dw 0

bot1Speed dw 0
bot2Speed dw 0
bot3Speed dw 0

bot1Laps dw 0
bot2Laps dw 0
bot3Laps dw 0

;   <><><><><><><><><><>           TEMPORAL VARIABLES          <><><><><><><><><><>

temporalX dw 0
temporalY dw 0

;   <><><><><><><><><><><><><><><><><><><><>               HEADER               <><><><><><><><><><><><><><><><><><><><>
;   <><><><><><><><><><><><><><><><><><><><>                              <><><><><><><><><><><><><><><><><><><><>

;   <><><><><><><><><><>               SUBHEADER               <><><><><><><><><><>
;   <><><><><><><><><><>                              <><><><><><><><><><>
