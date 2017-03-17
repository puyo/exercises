// $Author: Gregory McIntyre $
// $Date: 2000/06/15 12:24:30 $
// $Revision: 1.2 $
// $Id: random.h,v 1.2 2000/06/15 12:24:30 Gregory McIntyre Exp $

//! author = "$Author: Gregory McIntyre $"

//! section = "Other"


#ifndef _RANDOM_H_
#define _RANDOM_H_

#include <cstdlib>


void random_init();

inline int random_integer(int min, int max)
{
 // random integer between min and max, inclusive
 return min + (random() % (max - min + 1));
}

inline int random_integer2(int min, int max)
{
 // random integer between min and max, inclusive
 return min + (random() / (RAND_MAX / (max - min + 1)));
}

int evaluate_dice(int dice, int sides, int modifier);
int evaluate_dice2(int dice, int sides, int modifier);
int evaluate_dice(const char * string);

int test(int dice, int goal);
int challenge(int dice1, int dice2, int goal);


#endif
