#include <iostream>
#include <algorithm>

using namespace std;

int main() {
  char s[] = "Hello World!";
  uint uppercase = 0; // modified by the lambda
  for_each(s, s+sizeof(s), [&uppercase] (char c) {
      if (isupper(c))
        uppercase++;
    });
  cout << uppercase << " uppercase letters in: " << s << endl;
}
