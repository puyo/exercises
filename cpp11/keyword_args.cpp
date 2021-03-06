#include <iostream>
#include <algorithm>

using namespace std;

struct mul_args { int x; int y; };

int mul(const mul_args& args) {
  return (args.x*2) * args.y;
}

struct mul_ref_args { const int& x; const int& y; };

int mul_ref(const mul_ref_args& args) {
  return (args.x*2) * args.y;
}

int main() {
  cout << mul({.x = 5, .y = 4}) << endl;
  cout << mul({.y = 4, .x = 5}) << endl;

  mul_args a = {.y = 2, .x = 1};
  cout << "x = " << a.x << ", y = " << a.y << endl;
  cout << mul(a) << endl;

  int x = 1;
  int y = 2;
  cout << mul_ref({.x = x, .y = y}) << endl;

  return 0;
}

