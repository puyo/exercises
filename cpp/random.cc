#include "random.h"

#include <ctime>
#include <cmath>


// COMMANDS /////////////////////////////////////////////////////////////////

void random_init()
{
  srandom(time(0));
}


// QUERIES //////////////////////////////////////////////////////////////////


int evaluate_dice(int dice, int sides, int modifier)
{
  int result = 0;
  for (int count = 0; count != dice; ++count)
    result += random_integer2(1, sides);
  result += modifier;
  return result;
}



void split_dice_string(const char * input, unsigned int * dice,
                                           unsigned int * sides,
                                           int * modifier)
{
  *dice = *sides = *modifier = 0;

  int len = strlen(input);
  if (len < 3)
    return;

  char dice_str[256], sides_str[256], mod_str[256];
  int offset, i;
 
  // read the number of dice
  i = 0;
  while ((input[i] != 'd') && (input[i] != NULL))
  {
    dice_str[i] = input[i];
    ++i;
  }
  dice_str[i] = 0;
  *dice = atoi(dice_str);
 
  // read the number of sides on the dice
  ++i;  // move past the 'd'
 
  if (i > len) return;
 
  offset = i;
  while ((input[i] != '+') && (input[i] != '-') && (input[i] != NULL))
  {
    sides_str[i - offset] = input[i];
    ++i;
  }
  sides_str[i - offset] = 0;
  *sides = atoi(sides_str);
 
  if (i > len) return;
 
  // read the modification
  offset = i;
  while (input[i] != 0)
  {
    mod_str[i - offset] = input[i];
    ++i;
  }
  mod_str[i - offset] = 0;
  *modifier = atoi(mod_str);
}



int evaluate_dice(const char * dicestring)
{
  // evaluate a dice string, such as "2d4+3"
 
  unsigned int dice = 0, sides = 0;
  int modifier = 0;
 
  split_dice_string(dicestring, &dice, &sides, &modifier);
  return evaluate_dice(dice, sides, modifier);
}



int test(int dice, int goal)
{
  // evaluate a test with 1 set of 6-sided dice against a goal
 
  int i;
  int successes;
 
  successes = 0;
  for (i = 0; i < dice; ++i)
  {
    if (random_integer(1, 6) >= goal)
      ++successes;
  }
  return successes;
}



int challenge(int dice1, int dice2, int goal)
{
  // evaluate a challenge between two sets of 6-sided dice

  return test(dice1, goal) - test(dice1, goal);
}

