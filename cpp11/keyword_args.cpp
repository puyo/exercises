#include <iostream>
#include <algorithm>

using namespace std;

struct mul_args{ int x; int y; };

int mul(const mul_args& args) {
  return args.x * args.y;
}

int main() {
  cout << mul({.x = 2, .y = 3}) << endl;
  cout << mul({.y = 2, .x = 3}) << endl;

  return 0;
}

