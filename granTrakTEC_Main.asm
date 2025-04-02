[org 0x7C00]
[bits 16]

start:
    ; Inicialización crítica
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    cld

    ; Cambiar a modo gráfico
    mov ax, 0x0013
    int 0x10

    ; Cargar código extendido (8 sectores = 4KB)
    mov ah, 0x02
    mov al, 8
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, 0x7E00
    int 0x13
    jc disk_error

    ; Saltar al código extendido
    jmp 0x0000:0x7E00

disk_error:
    ; Mostrar mensaje de error
    mov si, error_msg
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

error_msg db "Disk error!", 0

times 510-($-$$) db 0
dw 0xAA55