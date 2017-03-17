; Turn num-lock on

[BITS 16]
[ORG 0x0100]

[SECTION .data]
[SECTION .text]

START:
        mov    [0040:0017], $20

END:
        mov    ax, $4C00         ; This function exits the program
        int    $21               ; and returns control to DOS.
