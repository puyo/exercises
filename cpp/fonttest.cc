

#include <allegro.h>


int main(void)
{
  allegro_init();
  install_keyboard();

  //set_color_depth(16);
  set_gfx_mode(GFX_AUTODETECT, 320, 240, 0, 0);

  clear(screen);

  text_mode(-1);

  DATAFILE * d = load_datafile("fonts.dat");
  if (!d) return 1;
  set_palette((PALETTE)d[1].dat);
  textout(screen, (FONT *)d[0].dat, "Hello World! This is the font test program.", 10, 10, -1);
  textout(screen, (FONT *)d[0].dat, "BTW, 'The quick brown fox jumped over the lazy dog'.", 10, 20, -1);
  textout(screen, (FONT *)d[0].dat, "And, \"THE QUICK BROWN FOX JUMPED OVER THE LAZY DOG\".", 10, 30, -1);
  unload_datafile(d);

  readkey();
  return 0;
}

