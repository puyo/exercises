#include <stdio.h>


int main(void)
{
 printf("\nThe date of compilation is: ");
 printf(__DATE__);
 printf("\n");

 printf("\nThe time of compilation is: ");
 printf(__TIME__);
 printf("\n");

 return 0;
}
