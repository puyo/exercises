
#include <vector>
#include <iostream>

typedef struct {
	int x, y, z;
} Blah;

int main(void) {
	vector<Blah> blahs;

	blahs.push_back(*(new Blah));
	blahs.push_back(*(new Blah));
	blahs.push_back(*(new Blah));

	cout << blahs.size() << endl;
	
	return 0;
}
