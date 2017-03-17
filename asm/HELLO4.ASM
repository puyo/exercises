[BITS 16]
[ORG 0x0100]

[SECTION .data]
msg     db      'Hello World!', 10, 13, '$'

[SECTION .text]

START:

PRINT_TEXT:
        mov     ah, $09
        mov     dx, msg
        mov     cx, $0A
.PRINT_AGAIN
        int     $21
        loop    .PRINT_AGAIN
        
END:
        mov     ax, $4C00         ; This function exits the program
        int     $21               ; and returns control to DOS.
