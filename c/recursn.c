#include <stdio.h>

int main(void)
{
 int i;

 for (i = 200; i != 1000; ++i)
   printf("\nf(%d) = %d\n", i, f(i));

 return 0;
}


int f(int b)
{
 if (b == 1)
   return 99;
 else if ((b % 2) == 0)
   return f(b/2);
 else
   return f(3*b + 1);
}
