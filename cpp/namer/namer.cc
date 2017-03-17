#include <string>
#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <vector>
#include <iostream>

using namespace std;

enum PART_TYPE
{
    NONE,
    CONSONANT,
    POST_CONSONANT,
    CONSONANT_BLOCK,
    VOWEL
};


class NAMER
{
public:

	NAMER();

	void make(unsigned int length);

	void seed(unsigned int s);

	const string name() const;
	const unsigned int number();

private:
	string myname;

	unsigned int mylength;

	void add_part(string part, PART_TYPE t);
	void add_vowel();
	void add_consonant();
	void add_consonant_block();
	void add_post_consonant();

	vector<string> vowels;
	vector<string> consonants;
	vector<string> consonant_blocks;
	vector<string> post_consonants;

	PART_TYPE last_part_type;
	string last_part;

	unsigned int myseed;
};



float random_percentage();
int random_integer(int min, int max);



int main(int argc, char * argv[])
{
	// start with a c or v, or a consonant block
	// generally, go cvcvcvcvcvcv...
	// vowels can put put next to each-other - sometimes put another vowel down
	// select consonants can be put after other consonants (eg. l, r)

	NAMER n;
	unsigned int s;

	if (argc > 2)
	{
		// print usage
		cout << "Usage" << endl;
		cout << "-----" << endl;
		cout << argv[0] << " [seed]" << endl;
		return 0;
	}
	else if (argc == 2)
		s = (unsigned int)atoi(argv[1]);
	else
		s = (unsigned int)clock();

	do
	{
		n.seed(s++);
		n.make(random_integer(3, 8));
		cout << "Name number " << n.number() << ": " << n.name() << endl;
	}
	while (fgetc(stdin) != 27);

	return 0;
}


// NAMER function definitions ///////////////////////////////////////////////

NAMER::NAMER()
{
	vowels.push_back("a");
	vowels.push_back("e");
	vowels.push_back("i");
	vowels.push_back("o");
	vowels.push_back("u");

	consonants.push_back("b");
	consonants.push_back("c");
	consonants.push_back("d");
	consonants.push_back("f");
	consonants.push_back("g");
	consonants.push_back("h");
	consonants.push_back("j");
	consonants.push_back("k");
	consonants.push_back("l");
	consonants.push_back("m");
	consonants.push_back("n");
	consonants.push_back("p");
	consonants.push_back("r");
	consonants.push_back("s");
	consonants.push_back("t");
	consonants.push_back("v");
	consonants.push_back("w");
	consonants.push_back("x");
	consonants.push_back("y");
	consonants.push_back("z");

	consonant_blocks.push_back("kn");
	consonant_blocks.push_back("qu");
	consonant_blocks.push_back("st");
	consonant_blocks.push_back("th");

	post_consonants.push_back("l");
	post_consonants.push_back("r");
	post_consonants.push_back("y");
}


void NAMER::make(unsigned int length)
{
	myname = "";
	mylength = length;

	float chance = random_percentage();

	if (chance < 0.50)
		add_vowel();
	else
	{
		// start with a consonant or consonant block

		if (random_integer(0, consonants.size() + consonant_blocks.size()) < consonant_blocks.size())
			add_consonant_block();
		else
			add_consonant();
	}


	while (last_part_type != NONE)
	{
		switch (last_part_type)
		{
		case (CONSONANT):
						// 20% chance => add a post consonant
						// 20% chance => repeat a consonant
						// else add a vowel

						chance = random_percentage();

			if (chance < 0.20)
				add_post_consonant();
			else if (chance < 0.40)
				add_part(last_part, CONSONANT);
			else
				add_vowel();

			break;

		case (POST_CONSONANT):
					case (CONSONANT_BLOCK):

							// just add a vowel
							add_vowel();
			break;

		case (VOWEL):
						// 20% chance => add another vowel
						// else add a consonant or consonant block

						chance = random_percentage();

			if (chance < 0.20)
				add_vowel();
			else
	{
				if (random_integer(0, consonants.size() + consonant_blocks.size()) < consonant_blocks.size())
					add_consonant_block();
				else
					add_consonant();
			}
			break;
		};
	}
}


void NAMER::seed(unsigned int s)
{
	srand(s);
	myseed = s;
}


void NAMER::add_part(string part, PART_TYPE t)
{
	if ((myname.size() + part.size()) <= mylength)
	{
		myname += part;
		last_part_type = t;
	}
	else
		last_part_type = NONE;
}


const string NAMER::name() const { return myname; }
const unsigned int NAMER::number() { return myseed; }


void NAMER::add_vowel()
{
	add_part(vowels[random_integer(0, vowels.size() - 1)], VOWEL);
}

void NAMER::add_consonant()
{
	add_part(consonants[random_integer(0, consonants.size() - 1)], CONSONANT);
}

void NAMER::add_consonant_block()
{
	add_part(consonant_blocks[random_integer(0, consonant_blocks.size() - 1)], CONSONANT_BLOCK);
}

void NAMER::add_post_consonant()
{
	add_part(post_consonants[random_integer(0, post_consonants.size() - 1)], POST_CONSONANT);
}



// OTHER function definitions ///////////////////////////////////////////////

float random_percentage()
{
	return (rand() % 100)/100.0;
}


int random_integer(int min, int max)
{
	return min + (rand() % (max - min + 1));
}

