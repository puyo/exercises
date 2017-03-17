BITS 16
ORG 0x100

SECTION .text

START:
        mov al, $4      ; column
        mov ah, $3      ; row
        mov bl, $2      ; fg colour
        mov bh, $0      ; bg colour
        mov cl, $2

        call PUTCHAR

        mov ah, $0      ; pause for a key to be pressed
        int $16

END:
        mov ax, $4C00         ; This function exits the program
        int $21               ; and returns control to DOS.


PUTCHAR:                ; al = column
                        ; ah = row
                        ; bl = foreground colour
                        ; bh = background colour
                        ; cl = character

        mov dx, $0B800  ; make ds point to text video memory
        mov ds, dx

        mov dx, ax      ; keep a copy of ax in dx

        sub dh, $1      ; row = row - 1

        xor ah, ah      ; ah = 0
        mov al, dh      ; al = dh = row - 1
        rol al, $6      ; al = 64*(row - 1)
        rol dh, $4      ; dh = 16*(row - 1)
        add al, dh      ; al = 80*(row - 1)
        
        sub dl, $1      ; col = col - 1
        add al, dl      ; ax = 80*(row - 1) + (col - 1)

        rol ax, $1      ; ax = 2*(80*(row - 1) + (col - 1))

        mov si, ax      ; si = ax (now ds:si points to the place
                        ;          we want to put the char)
        rol bh, $4      ; bh = bh << 4
        or  bh, bl      ; bh = bh | bl

        mov bl, cl      ; setup bx for putting in memory

        mov [ds:si], bx ; move the char to text video memory
        ret
