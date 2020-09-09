#include <iostream>
#include <algorithm>

using namespace std;

struct foo {
  int x() const { return _x; }
  foo& x(int v) { _x = v; return *this; }
  private:
  int _x;
};

struct bar {
  int x() const { return _x; }
  bar& x(int v) { _x = v; return *this; }
  private:
  int _x;
};

int proc(const foo& o) {
  return o.x();
}

int proc(const bar& o) {
  return o.x() * 2;
}

int proc(const foo& f, const bar& b) {
  return f.x() * b.x();
}

int proc(const bar& b, const foo& f) {
  return f.x() * b.x() * 2;
}

int main() {
  auto f = foo().x(2);
  auto b = bar().x(2);

  cout << proc(f) << endl;
  cout << proc(b) << endl;

  cout << proc(f, b) << endl;
  cout << proc(b, f) << endl;
  cout << proc(b.x(3), f.x(5)) << endl;

  return 0;
}
