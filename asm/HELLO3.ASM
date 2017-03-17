; Greg's first ASM program!!

[BITS 16]
[ORG 0x0100]

[SECTION .data]
msg     db      'Hello World$'

[SECTION .text]

START:

PRINT_TEXT:
        mov    ah, $9
        mov    dx, msg
        int    $21
        
END:
        mov    ax, $4C00         ; This function exits the program
        int    $21               ; and returns control to DOS.
