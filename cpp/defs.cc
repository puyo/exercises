
#include <iostream>

int main(void)
{
#ifdef DJGPP
  cout << "DJGGP" << endl;
#endif
#ifdef _WIN32
  cout << "_WIN32" << endl;
#endif
  return 0;
}
