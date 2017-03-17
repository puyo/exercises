
import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;

public class Bounce implements Runnable {
	
	private Frame window;
	
	public static void main(String[] args) {
		Bounce b = new Bounce();
		b.run();
	}
	
	public void run() {
		// Create window.
		window = new BounceWindow();
		window.show();
	}
}

class BounceWindow extends Frame {

	private static final Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
	private Ball ball;
    
	// Double buffering buffer & graphics.
	private Image buffer;
	private Graphics bufferGraphics;

	// Dimensions.
	private int width = 200;
	private int height = 500;
	
	public BounceWindow() {
		// Listen for window events.
		addWindowListener(new MyAdapter());

		// Make the ball.
		ball = new Ball(100, 250, 30, 0.0f);

		try {
			Image offImage = createImage(100, 100);
			//			buffer = createImage(width, height);
			buffer = new BufferedImage(width, height, BufferedImage.TYPE_USHORT_565_RGB); // good
			//			buffer = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_INDEXED); // good
			//			buffer = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR); // crap

			//			buffer = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB); // okay
			System.out.println("buffer = " + buffer);
			System.out.println("offImage = " + offImage);
			bufferGraphics = buffer.getGraphics();
		}
		catch (Exception e) {
			System.exit(1);
		}
			
		pack();
		setBounds((screenSize.width - width)/2, (screenSize.height - height)/2, width, height);
		setResizable(true);
	}

	public void update(Graphics graphics) {
		paint(graphics);
	}

	public void paint(Graphics graphics) {
		redrawBuffer();
		graphics.drawImage(buffer, getInsets().left, getInsets().top, this);
		repaint();
	}

	public void redrawBuffer() {
		bufferGraphics.setColor(Color.black);
		bufferGraphics.fillRect(0, 0, width, height);
		bufferGraphics.setColor(Color.white);

		ball.update(1.0f);
		if (ball.y > height) {
			ball.velocityY = -ball.velocityY;
		}

		ball.paint(bufferGraphics);
	}
	
	/** Inner-class used to handle window manager events.
	 */
    private class MyAdapter extends WindowAdapter {
        public void windowClosing(WindowEvent e) {
            System.exit(0);
        }
    }
}

/** A 2D ball. A circle. */
class Ball {
	public int x;
	public int y;
	public int radius;
	public float velocityY;

	public Ball(int x, int y, int radius, float velocityY) {
		this.x = x;
		this.y = y;
		this.radius = radius;
		this.velocityY = velocityY;
	}
	
	public void move(int dx, int dy) {
		x += dx;
		y += dy;
	}
	
	public void update(float gravityY) {
		velocityY += gravityY;
		y += velocityY;
	}
	
	public void paint(Graphics g) {
		g.drawOval(x, y, radius, radius);
	}
}
