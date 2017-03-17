#include "allegro.h"
#include <conio.h>

int main(void)
{
 allegro_init();

 set_gfx_mode(GFX_VGA, 320, 200, 0, 0);

 allegro_exit();

 _set_screen_lines(50);

 return 0;
}
