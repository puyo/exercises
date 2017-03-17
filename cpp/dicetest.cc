
#include "random.h"

#include <conio.h>
#include <allegro.h>

#define SCR_W  640
#define SCR_H  480

#define DICE   160
#define SIDES  4

#define SLOTS  640
#define TESTS  100

#define SCALE  10


int main(void)
{
  int results1[SLOTS];
  int results2[SLOTS];

  // init random number generator
  random_init();

  // init allegro
  allegro_init();
  set_gfx_mode(GFX_AUTODETECT, SCR_W, SCR_H, 0, 0);

  do
  {
    // zero arrays
    for (int i = 0; i != SLOTS; ++i)
      results1[i] = 0;
    for (int i = 0; i != SLOTS; ++i)
      results2[i] = 0;
  
    for (int i = 0; i != TESTS; ++i)
      ++results1[evaluate_dice(DICE, SIDES, 0)];
    for (int i = 0; i != TESTS; ++i)
      ++results2[evaluate_dice2(DICE, SIDES, 0)];
  
    // redraw screen
    clear(screen);
    for (int i = 0; i != SLOTS; ++i)
      line(screen, i, SCR_H, i, SCR_H - (int)(results1[i]*SCALE), 4);
    for (int i = 0; i != SLOTS; ++i)
      line(screen, i, SCR_H/2, i, SCR_H/2 - (int)(results2[i]*SCALE), 2);
  }
  while (getch() != 27);

  return 0;
}

