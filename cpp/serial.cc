// Serial communication test program
// Gregory McIntyre

#include <bios.h>
#include <conio.h>
#include <stdio.h>


bool bit(unsigned int n, unsigned int b);
  // returns the bth bit of n (true of false)


int main(void)
{
 int buf[] = { 1, 2, 3, 0 };
 unsigned int result, k;
 setlinebuf(stdout);

 /* 9600 baud, no parity, one stop, 8 bits */

 result = _bios_serialcom(_COM_INIT, 1, _COM_9600 | _COM_NOPARITY | _COM_STOP1 | _COM_CHR8);

 for (;;)
   {
    // print a menu
    clrscr();

    printf("Serial Communications Program\n");
    printf("-----------------------------\n");
    printf("\n");
    printf("\t  1. Send a byte\n");
    printf("\t  2. Receive a byte\n");
    printf("\t  3. Get serial port status\n");
    printf("\tESC. Quit\n");
    printf("\n");
    printf("Choice: ");
    k = getch() - '0';

    if (k == 1)
      {
       printf("\n\nEnter a byte to send: ");
       k = getche();

       printf("\n");

       do
         {
          result = _bios_serialcom(_COM_SEND, 1, k);
          /*
          if (bit(result, 8))  printf("Data ready\n");
          if (bit(result, 9))  printf("Overrun error\n");
          if (bit(result, 10)) printf("Parity error\n");
          if (bit(result, 11)) printf("Framing error\n");
          if (bit(result, 12)) printf("Break detected\n");
          if (bit(result, 13)) printf("Transmission-hold register empty\n");
          if (bit(result, 14)) printf("Transmission-shift register empty\n");
          */
          if (bit(result, 15))
            printf("Send failed, retrying...\n");
          else
            {
             printf("Send succeeded\n");
             break;
            }
         }
       while (!kbhit());

       printf("\nPress a key to continue...");
       //while (kbhit());
       getch();
      }
    else if (k == 2)
      {
       printf("\n\nReceiving byte, press any key to quit...\n");

       do
         {
          result = _bios_serialcom(_COM_RECEIVE, 1, 0);
          /*
          if (bit(result, 8))
            printf("Data ready\n");

          if (bit(result, 9))
            {
             printf("Overrun error\n");
             break;
            }

          if (bit(result, 10))
            {
             printf("Parity error\n");
             break;
            }

          if (bit(result, 11))
            {
             printf("Framing error\n");
             break;
            }

          if (bit(result, 12))
            printf("Break detected\n");

          if (bit(result, 13))
            printf("Transmission-hold register empty\n");

          if (bit(result, 14))
            printf("Transmission-shift register empty\n");
          */

          if (bit(result, 15))
            printf("Receive failed, retrying...\n");
          else
            {
             result &= 0xFF;
             printf("Byte received: %d\n", result);
             break;
            }
         }
       while (!kbhit());

       printf("\nPress a key to continue...");
       getch();
      }
    else if (k == 3)
      {
       result = _bios_serialcom(_COM_STATUS, 1, 0);

       printf("\n\nStatus\n");
       printf("------\n\n");

       if (bit(result, 0)) printf("Change in clear-to-send status\n");
       if (bit(result, 1)) printf("Change in data-set-ready status\n");
       if (bit(result, 2)) printf("Trailing-edge ring indicator\n");
       if (bit(result, 3)) printf("Change in receive-line signal detected\n");
       if (bit(result, 4)) printf("Clear-to-send\n");
       if (bit(result, 5)) printf("Data-set-ready\n");
       if (bit(result, 6)) printf("Ring indicator\n");
       if (bit(result, 7)) printf("Receive-line signal detected\n");

       if (bit(result, 8))  printf("Data ready\n");
       if (bit(result, 9))  printf("Overrun error\n");
       if (bit(result, 10)) printf("Parity error\n");
       if (bit(result, 11)) printf("Framing error\n");
       if (bit(result, 12)) printf("Break detected\n");
       if (bit(result, 13)) printf("Transmission-hold register empty\n");
       if (bit(result, 14)) printf("Transmission-shift register empty\n");
       if (bit(result, 15)) printf("Timed out\n");

       printf("\nPress a key to continue...");
       getch();
      }
    else if (k == (27 - '0'))
      {
       printf("ESC");
       break;
      }
   }
}


bool bit(unsigned int n, unsigned int b)
{
 return (((n >> b) & 1) == 1);
}

