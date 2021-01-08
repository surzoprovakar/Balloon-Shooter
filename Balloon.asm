.MODEL SMALL

.STACK 100H

.DATA

CHARACTER DB "OPS$";,0DH, 0AH,'$; "[ ]",0DH, 0AH,"I I",0DH, 0AH,'$'
        ;  DW  "[ ]",0DH, 0AH
        ;  DW  "I I",0DH, 0AH,'$'
            
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    
    CALL set_display_mode
;    CALL draw_character
    
    lea bp, CHARACTER            ; ES:BP = Far pointer to string
    mov cx, 4        ; CX = Length of string
    mov bl, 4               ; red (http://stackoverflow.com/q/12556973/3512216)
    call print


    ;ENDING
    MOV AH, 4CH
    INT 21H


MAIN ENDP





set_display_mode Proc
; sets display mode and draws boundary
    MOV AH, 0
    MOV AL, 03h; 320x200 4 color
    INT 10h
; select palette    
    MOV AH, 0BH
    MOV BH, 0
    MOV BL, 1
    INT 10h
; set bgd color
    MOV BH, 0
    ;    MOV BL, 1; cyan
    ;INT 10h
    
    RET
set_display_mode ENDP



draw_character PROC near

    LEA DX, CHARACTER
    MOV AH, 9
    INT 21H
    RET

draw_character endp


print PROC                  ; Arguments:
                            ;   ES:BP   Pointer to string
                            ;   CX      Length of string
                            ;   BL      Attribute (color)

    ; http://www.ctyme.com/intr/rb-0088.htm
    push cx                 ; Save CX (needed for Int 10h/AH=13h below)
    mov ah, 03h             ; VIDEO - GET CURSOR POSITION AND SIZE
    xor bh, bh              ; Page 0
    int 10h                 ; Call Video-BIOS => DX is current cursor position
    pop cx                  ; Restore CX

    ; http://www.ctyme.com/intr/rb-0210.htm
    mov ah, 13h             ; VIDEO - WRITE STRING (AT and later,EGA)
    mov al, 1               ; Mode 1: move cursor
    xor bh, bh              ; Page 0
    int 10h                 ; Call Video-BIOS

    ret
print ENDP




END MAIN    