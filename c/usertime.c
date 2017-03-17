#include <conio.h>
#include "allegro.h"

int counter[10];


void counter_proc(void)
{
 int i;

 for (i = 0; i != 10; ++i)
   ++counter[i];
}
END_OF_FUNCTION(counter_proc);



int main(void)
{
 int i;

 allegro_init();
 install_timer();

 for (i = 0; i != 10; ++i)
   LOCK_VARIABLE(counter[i]);

 LOCK_FUNCTION(counter_proc);

 install_int(counter_proc, 100);

 for (i = 0; i != 10; ++i)
   counter[i] = 0;


 while (counter[0] != 10)
   {
    cprintf("%d", counter[0]);
   }

 return 0;
}
