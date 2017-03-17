#include <dos.h>
#include <conio.h>

int main(void)
{
   clrscr();
   cprintf("Make sure numlock is off and press any key\r\n");
   getch();
   poke(0x0000,0x0417,0x20);
   cprintf("The numlock is now on\r\n");
   cprintf("%d", getch() - '0');
   return 0;
}

