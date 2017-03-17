#include <ClanLib/core.h>
#include <ClanLib/display.h>
#include <ClanLib/gl.h>
#include <ClanLib/application.h>

class DisplayProgram
{
public:
    static int main(const std::vector<CL_String> &args);
};

// Create global application object:
// You MUST include this line or the application start-up will fail to
// locate your application object.
CL_ClanApplication app(&DisplayProgram::main);

int DisplayProgram::main(const std::vector<CL_String> &args)
{
    // Setup clanlib modules:
    CL_SetupCore setup_core;
    CL_SetupDisplay setup_display;
    CL_SetupGL setup_gl;
    
    // Create a window:
    CL_DisplayWindow window("Hello World", 640, 480);
    
    // Retrieve some commonly used objects:
    CL_GraphicContext gc = window.get_gc();
    CL_InputDevice keyboard = window.get_ic().get_keyboard();
    CL_Font font(gc, "Tahoma", 30);
    
    // Loop until user hits escape:
    while (!keyboard.get_keycode(CL_KEY_ESCAPE))
    {
        // Draw some text and lines:
        gc.clear(CL_Colorf::cadetblue);

        CL_Draw::line(gc, 0, 110, 640, 110, CL_Colorf::yellow);
        font.draw_text(gc, 100, 100, "Hello World!", CL_Colorf::lightseagreen);
        
        // Make the stuff visible:
        window.flip();
    
        // Read messages from the windowing system message queue,
        // if any are available:
        CL_KeepAlive::process();
        
        // Avoid using 100% CPU in the loop:
        CL_System::sleep(10);
    }
    
    return 0;
}

