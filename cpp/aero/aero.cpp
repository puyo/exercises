
#include "SDL.h"
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include <cstdlib>
#include <cmath>

#define WINDOW_TITLE "Aerodynamics Demo"
#define WINDOW_TITLE_SHORT "Aero"

#define SCREEN_W  800
#define SCREEN_H  600
#define BPP  16

#define X_INITIAL 50.0
#define Y_INITIAL 50.0
#define SPEED_MAX 4.0

#define THRUST_STEP 5.0
#define THRUST_MAX  100.0
#define THRUST_MIN  0.0

#define ANGLE_STEP 3.0

#define LENGTH_INITIAL 30.0

#define LIFT_COEFF 0.5
#define THRUST_COEFF 0.001
#define GRAVITY_INITIAL  0.05
#define FRICTION 0.01


template <class T>
T absolute(T a) {
	if (a < 0.0) {
		return -a;
	}
	return a;
}

class Vector2D {
	protected:
	float a; // Angle
	float m; // Magnitude

	public:
	Vector2D(float a=0.0, float m=0.0) : a(a*M_PI/180.0), m(m) {}
	float angle() const {
		return a;
	}
	float angleDegrees() const {
		return a*180.0/M_PI;
	}
	float magnitude() const {
		return m;
	}
	float x() const {
		return m*cos(a);
	}
	float y() const {
		return m*sin(a);
	}
	float dot(Vector2D& v) const {
		return m*v.magnitude()*cos(a - v.angle());
	}
	Vector2D& operator*=(float scalar) {
		m *= scalar;
		return *this;
	}
	Vector2D& operator*(float scalar);
	Vector2D& operator=(float value) {
		m = value;
		return *this;
	}
	Vector2D& operator+=(float value) {
		m += value;
		return *this;
	}
	Vector2D& operator+=(Vector2D& other) {
		float newx = x() + other.x();
		float newy = y() + other.y();
		setXY(newx, newy);
		return *this;
	}
	float setAngle(float value) {
		a = value;
		wrapAngle();
	}
	float setAngleDegrees(float value) {
		a = value*M_PI/180.0;
		wrapAngle();
	}
	float offsetAngleDegrees(float value) {
		a += value*M_PI/180.0;
		wrapAngle();
	}
	float limitMagnitude(float min, float max) {
		if (m > max)
			m = max;
		else if (m < min)
			m = min;
	}
	void setXY(float x, float y) {
		a = atan2(y, x);
		m = sqrt(x*x + y*y);
	}
	private:
	void wrapAngle() {
		while (a <= -M_PI)
			a += 2*M_PI;
		while (a > M_PI)
			a -= 2*M_PI;
	}
};

static Vector2D result;

Vector2D& Vector2D::operator*(float scalar) {
	result = m*scalar;
	result.setAngle(a);
	return result;
}

class Plane {
	public:

	float x, y;
	Vector2D thrust;
	Vector2D velocity;
	float length;

	Plane() :
		x(X_INITIAL),
		y(Y_INITIAL),
		length(LENGTH_INITIAL)
	{}
};

static Vector2D gravity(90.0, GRAVITY_INITIAL);
static float thrustChange = 0.0;
static float angleChange = 0.0;

// Routines ----------------------------------------------------------

void quit() {
	exit(0);
}

void drawString(int x, int y, char *string)
{
	int len, i;
	glRasterPos2f(x, y);
	len = (int)strlen(string);
	for (i = 0; i < len; i++) {
		glutBitmapCharacter(GLUT_BITMAP_8_BY_13, string[i]);
	}
}

void draw(Plane& plane) {

	// Clear.
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Plane.
	glColor3f(1.0, 1.0, 1.0);
	glPushMatrix();
	glTranslatef(plane.x, plane.y, 0.0);
	glRotatef(plane.thrust.angleDegrees(), 0.0, 0.0, 1.0);
	glBegin(GL_LINES);
	glVertex2f(-plane.length/2.0, 0.0);
	glVertex2f(+plane.length/2.0, 0.0);
	glVertex2f(+plane.length/2.0, 0.0);
	glVertex2f(+plane.length/2.0 - 5.0, -5.0);
	glVertex2f(+plane.length/2.0, 0.0);
	glVertex2f(+plane.length/2.0 - 5.0, +5.0);
	glEnd();
	glPopMatrix();

	// Info.
	float intensity = 0.7;
	char string[1024];
	glColor3f(intensity, intensity, intensity);
	sprintf(string, "thrust=%f,spd=%f", plane.thrust.magnitude(), plane.velocity.magnitude());
	drawString(0, 12, string);
}

const Vector2D& lift(Plane& plane) {
	
}

void update(Plane& plane) {

	// Thrust / Plane angle
	plane.thrust += thrustChange;
	plane.thrust.offsetAngleDegrees(angleChange);

	plane.thrust.limitMagnitude(THRUST_MIN, THRUST_MAX);

	// Velocity
	plane.velocity += plane.thrust;
	plane.velocity += gravity;
	plane.velocity *= 1.0 - FRICTION;

	plane.velocity.limitMagnitude(0.0, SPEED_MAX);

	// Position
	plane.x += plane.velocity.x();
	plane.y += plane.velocity.y();

	if (plane.x < 0)
		plane.x += SCREEN_W;
	if (plane.x > SCREEN_W)
		plane.x -= SCREEN_W;
	if (plane.y < 0)
		plane.y += SCREEN_H;
	if (plane.y > SCREEN_H)
		plane.y -= SCREEN_H;
}


// -------------------------------------------------------------------
// MAIN
// -------------------------------------------------------------------

void reshape(int w, int h) {
	static const float dist = 300; // Distance from camera.
	static const float near = 1.0; // Near-clipping plane.
	static const float far = dist + 1000; // Far-clipping plane.

	glViewport(0, 0, (GLsizei)w, (GLsizei)h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0, w, h, 0, near, far);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glTranslatef(0.0, 0.0, -5.0);
}

SDL_Surface *initSDL() {

	int flags = SDL_DOUBLEBUF;
	int bpp = 0;

	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		fprintf(stderr, "Video initialization failed: %s\n", SDL_GetError());
		exit(1);
	}

	atexit(SDL_Quit);

	const SDL_VideoInfo* info = SDL_GetVideoInfo();    
	if (!info) {
		fprintf(stderr, "Video query failed: %s\n", SDL_GetError());
		exit(1);
	}    

	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

	/* The flags to pass to SDL_SetVideoMode */
	uint videoFlags  = SDL_OPENGL;          /* Enable OpenGL in SDL */
	videoFlags |= SDL_GL_DOUBLEBUFFER; /* Enable double buffering */
	videoFlags |= SDL_HWPALETTE;       /* Store the palette in hardware */
	videoFlags |= SDL_RESIZABLE;       /* Enable window resizing */

	/* This checks to see if surfaces can be stored in memory */
	if (info->hw_available)
		videoFlags |= SDL_HWSURFACE;
	else
		videoFlags |= SDL_SWSURFACE;
    
	/* This checks if hardware blits can be done */
	if (info->blit_hw)
		videoFlags |= SDL_HWACCEL;

	SDL_Surface *screen = SDL_SetVideoMode(SCREEN_W, SCREEN_H, BPP, videoFlags);
	if (screen == NULL) {
		fprintf(stderr, "Could not set video mode: %s\n", SDL_GetError());
		exit(1);
	}
	SDL_WM_SetCaption(WINDOW_TITLE, WINDOW_TITLE_SHORT);

	// Setup GL.
	reshape(SCREEN_W, SCREEN_H);
	glClearColor(0.0, 0.0, 0.0, 0.0);

	glShadeModel(GL_SMOOTH);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	SDL_EnableKeyRepeat(0, 10);

	return screen;
}


int main(int argc, char* argv[])
{
    glutInit(&argc, argv);

	SDL_Surface *screen = initSDL();
	SDL_Event event;

	Plane plane;

	while (true) {

		update(plane);
		draw(plane);
		SDL_GL_SwapBuffers();
		SDL_Delay(10);
		
		while (SDL_PollEvent(&event)) { // Handle next SDL event.
			switch (event.type) {
			case SDL_KEYDOWN:
				switch (event.key.keysym.sym) {
				case SDLK_q:
				case SDLK_ESCAPE:
					quit();
					break;
				case SDLK_UP: thrustChange = +THRUST_STEP; break;
				case SDLK_DOWN: thrustChange = -THRUST_STEP; break;
				case SDLK_LEFT: angleChange = -ANGLE_STEP; break;
				case SDLK_RIGHT: angleChange = +ANGLE_STEP; break;
				default: break;
				}
				break;
			case SDL_KEYUP:
				switch (event.key.keysym.sym) {
				case SDLK_UP:
				case SDLK_DOWN:
					if (thrustChange) thrustChange = 0.0; break;
				case SDLK_LEFT:
				case SDLK_RIGHT:
					if (angleChange) angleChange = 0.0; break;
				default: break;
				}
				break;
			case SDL_QUIT:
				quit();
				break;
			default:
				break;
			}
		}
	}
}


// -------------------------------------------------------------------


	/*
	float a = 0.0;
	float s = 0.0;
	if (plane.angle < 0.0 && plane.angle >= -90.0) {
		a = plane.angle;
		s = 1;
	} else if (plane.angle < -90.0 && plane.angle >= -180.0) {
		a = plane.angle + 90.0;
		s = 1;
	} else if (plane.angle >= 0.0 && plane.angle <= 90.0) {
		a = plane.angle;
		s = 1;
	} else {
		a = plane.angle - 90.0;
		s = 1;
	}
	return LIFT_COEFF*s*plane.speed*sin(M_PI*a*2/180.0);
	float result;
	if (plane.angle < 0.0 && plane.angle >= -90.0) {
		// first quadrant
		result = plane.angle + 90.0;
	} else if (plane.angle < -90.0 && plane.angle >= -180.0) {
		// second quadrant
		result = plane.angle - 90.0;
	} else if (plane.angle >= 0.0 && plane.angle <= 90.0) {
		// fourth quadrant
		result = plane.angle + 90.0;
	} else {
		// third quadrant
		result = plane.angle - 90.0;
	}
	return result;
	*/
