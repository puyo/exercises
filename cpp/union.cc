#include <stdio.h>


union u
{
 int x;
 int y;
} myunion;


int main(void)
{
 myunion.x = 0;
 myunion.y = 1;

 return 0;
}
