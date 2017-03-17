#include <iostream>
#include <cstdio>
#include <cstdarg>

#define DEBUGGING

#ifdef DEBUGGING
#define DEBUG(x)  cerr << "Debug: " << (x) << endl;
#define DEBUG_VALUE(x, y)  cerr << "Debug: " << (x) << " = \"" << (y) << "\"" << endl;
#else
#define DEBUG(x)
#define DEBUG_VALUE(x, y)
#endif


int function(int x);


int main(void)
{
 DEBUG("main()");

 DEBUG_VALUE("function(3)", function(3));

 return 0;
}


int function(int x)
{
 DEBUG("function()");

 return 2*x;
}

