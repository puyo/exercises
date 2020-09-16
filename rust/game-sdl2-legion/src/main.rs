extern crate sdl2;

mod dogfight;
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::pixels::Color;

pub fn main() -> Result<(), String> {
    let sdl_context = sdl2::init()?;
    let video_subsystem = sdl_context.video()?;

    // the window is the representation of a window in your operating system,
    // however you can only manipulate properties of that window, like its size, whether it's
    // fullscreen, ... but you cannot change its content without using a Canvas or using the
    // `surface()` method.
    let window = video_subsystem
        .window("sdl2 demo", 1000, 800)
        .opengl() // this line DOES NOT enable opengl, but allows you to create/get an OpenGL context from your window.
        .build()
        .unwrap();

    // the canvas allows us to both manipulate the property of the window and to change its content
    // via hardware or software rendering. See CanvasBuilder for more info.
    let mut canvas = window
        .into_canvas()
        .index(find_sdl_gl_driver().unwrap())
        .target_texture()
        .present_vsync()
        .build()
        .map_err(|e| e.to_string())?;

    println!("Using SDL_Renderer \"{}\"", canvas.info().name);

    // render

    canvas.set_draw_color(Color::RGB(0, 0, 0));
    // clears the canvas with the color we set in `set_draw_color`.
    canvas.clear();
    // However the canvas has not been updated to the window yet, everything has been processed to
    // an internal buffer, but if we want our buffer to be displayed on the window, we need to call
    // `present`. We need to call this everytime we want to render a new frame on the window.
    canvas.present();

    // this struct manages textures. For lifetime reasons, the canvas cannot directly create
    // textures, you have to create a `TextureCreator` instead.
    // let texture_creator: TextureCreator<_> = canvas.texture_creator();

    // Create a "target" texture so that we can use our Renderer with it later
    // let (square_texture1, square_texture2) = dummy_texture(&mut canvas, &texture_creator)?;
    let mut game = dogfight::dogfight::Game::new();

    let timer = sdl_context.timer()?;

    let mut event_pump = sdl_context.event_pump()?;
    let mut last_counter = timer.performance_counter();
    let freq = timer.performance_frequency();

    'running: loop {
        // input

        for event in event_pump.poll_iter() {
            match event {
                Event::Quit { .. }
                | Event::KeyDown {
                    keycode: Some(Keycode::Escape),
                    ..
                } => break 'running,
                _ => {
                    // game.input_event(event)
                }
            }
        }

        // update

        let now = timer.performance_counter();
        let delta = ((now - last_counter) * 1000) as f64 / freq as f64;
        game.update(delta);
        last_counter = now;

        // render

        // canvas.set_draw_color(Color::RGB(0, 0, 0));
        // canvas.clear();
        // for (i, unit) in (&game).into_iter().enumerate() {
        //     let i = i as u32;
        //     let square_texture = if frame >= 15 {
        //         &square_texture1
        //     } else {
        //         &square_texture2
        //     };
        //     if *unit {
        //         canvas.copy(
        //             square_texture,
        //             None,
        //             Rect::new(
        //                 ((i % PLAYGROUND_WIDTH) * SQUARE_SIZE) as i32,
        //                 ((i / PLAYGROUND_WIDTH) * SQUARE_SIZE) as i32,
        //                 SQUARE_SIZE,
        //                 SQUARE_SIZE,
        //             ),
        //         )?;
        //     }
        // }
        // canvas.present();
    }

    Ok(())
}

fn find_sdl_gl_driver() -> Option<u32> {
    for (index, item) in sdl2::render::drivers().enumerate() {
        if item.name == "opengl" {
            return Some(index as u32);
        }
    }
    None
}
